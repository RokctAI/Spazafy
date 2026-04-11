import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/application/subscriptions/manager/subscriptions_state.dart';
import 'package:rokctapp/application/subscriptions/manager/subscriptions_notifier.dart';

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
      (ref) =>
          SubscriptionNotifier(subscriptionRepository, paymentRepositoryNew),
    );
