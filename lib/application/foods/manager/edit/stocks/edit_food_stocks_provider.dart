import 'package:rokctapp/infrastructure/models/data/stock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/foods/manager/edit/stocks/edit_food_stocks_state.dart';
import 'package:rokctapp/application/foods/manager/edit/stocks/edit_food_stocks_notifier.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';

final editFoodStocksProvider =
    StateNotifierProvider.autoDispose<
      EditFoodStocksNotifier,
      EditFoodStocksState
    >((ref) => EditFoodStocksNotifier(managerProductRepository));
