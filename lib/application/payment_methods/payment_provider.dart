import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/payment_methods/payment_notifier.dart';
import 'package:rokctapp/application/payment_methods/payment_state.dart';

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(paymentsRepository),
);
