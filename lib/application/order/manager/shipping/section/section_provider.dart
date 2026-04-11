import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/order/manager/shipping/section/section_state.dart';
import 'package:rokctapp/application/order/manager/shipping/section/section_notifier.dart';

final sectionProvider = StateNotifierProvider<SectionNotifier, SectionState>(
  (ref) => SectionNotifier(),
);
