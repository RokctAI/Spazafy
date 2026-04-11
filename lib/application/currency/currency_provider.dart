import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/currency/currency_notifier.dart';
import 'package:rokctapp/application/currency/currency_state.dart';

final currencyProvider = StateNotifierProvider<CurrencyNotifier, CurrencyState>(
  (ref) => CurrencyNotifier(currenciesRepository),
);
