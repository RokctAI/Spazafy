import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/utils/payfast/enums/recurring_payment_types.dart';
import 'recurring_billing_types/subscription_payment.dart';
import 'recurring_billing_types/tokenization_billing.dart';

class RecurringBilling {
  SubscriptionPayment? subscriptionPayment;
  TokenizationBilling? tokenizationBilling;

  RecurringPaymentType recurringPaymentType;

  RecurringBilling({required this.recurringPaymentType});
}
