import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/create_product/driver/create_product_notifier.dart';
import 'package:rokctapp/application/create_product/driver/create_product_state.dart';

final createProductProvider =
    StateNotifierProvider<CreateProductNotifier, CreateProductState>(
      (ref) => CreateProductNotifier(),
    );
