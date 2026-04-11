import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/shipping/table/table_state.dart';
import 'package:rokctapp/application/order/manager/shipping/table/table_notifier.dart';

final tableProvider = StateNotifierProvider<TableNotifier, TableState>(
  (ref) => TableNotifier(),
);
