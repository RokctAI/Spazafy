import 'package:rokctapp/infrastructure/models/data/manager/subscriptions_data.dart';
import 'package:rokctapp/infrastructure/models/data/payment_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rokctapp/infrastructure/models/data/payment_data.dart';

part 'subscriptions_state.freezed.dart';

@freezed
abstract class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default(false) bool isLoading,
    @Default(false) bool isPaymentLoading,
    @Default(1) int selectPayment,
    @Default(0) int selectSubscribe,
    @Default([]) List<SubscriptionData> list,
    @Default([]) List<PaymentData>? payments,
  }) = _SubscriptionState;

  const SubscriptionState._();
}
