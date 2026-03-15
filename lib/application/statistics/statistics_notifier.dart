import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:venderfoodyman/domain/interface/user.dart';
import 'package:venderfoodyman/infrastructure/models/customer/models.dart';
import 'statistics_state.dart';

class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final UserFacade _userRepository;
  int page = 1;

  StatisticsNotifier(this._userRepository) : super(const StatisticsState());

  // Shared fetch methods
  Future<void> fetchStatistics({
    required DateTime endTime,
    required DateTime startTime,
    bool isSeller = true,
  }) async {
    state = state.copyWith(isLoading: true);
    final response = await _userRepository.getStatistics(
      startTime: startTime,
      endTime: endTime,
    );
    response.when(
      success: (data) {
        if (isSeller) {
          state = state.copyWith(countData: data.data, isLoading: false);
          addChartInfo(
            chart: data.data?.chart ?? [],
            startTime: startTime,
            endTime: endTime,
          );
        } else {
          // Driver logic (different model structure usually)
          state = state.copyWith(
              countDataDriver: data as StatisticsIncomeResponse,
              isLoading: false);
        }
      },
      failure: (fail, status) {
        state = state.copyWith(isLoading: false);
        debugPrint('==> error with fetching statistics $fail');
      },
    );
  }

  Future<void> fetchStatisticsOrder({
    DateTime? endTime,
    DateTime? startTime,
  }) async {
    page = 1;
    state = state.copyWith(isLoading: true, isRefresh: true);
    final response = await _userRepository.getStatisticsOrder(
      startTime: startTime,
      endTime: endTime,
      page: 1,
    );
    response.when(
      success: (data) {
        state = state.copyWith(listOfOrder: data.data ?? [], isLoading: false);
      },
      failure: (fail, status) {
        state = state.copyWith(isLoading: false);
        debugPrint('==> error with fetching statistics order $fail');
      },
    );
  }

  void addChartInfo({
    required List<Chart> chart,
    required DateTime endTime,
    required DateTime startTime,
  }) {
    List<num> prices = [];
    List<DateTime> times = [];
    if (chart.isNotEmpty) {
      num price = 0;
      for (var element in chart) {
        if (price < (element.totalPrice ?? 0)) {
          price = element.totalPrice ?? 0;
        }
      }
      num a = price / 6;
      prices = List.generate(7, (index) => (price - (index * a)));
      times = List.generate(
        startTime.difference(endTime).inDays.abs() == 0
            ? 24
            : startTime.difference(endTime).inDays.abs(),
        (index) => DateTime.now().subtract(
          startTime.difference(endTime).inDays.abs() == 0
              ? Duration(hours: index)
              : Duration(days: index),
        ),
      );
    }
    state = state.copyWith(
      prices: prices.reversed.toList(),
      time: times,
      isLoading: false,
    );
  }
}
