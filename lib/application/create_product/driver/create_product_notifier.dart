import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/application/create_product/driver/create_product_state.dart';

class CreateProductNotifier extends StateNotifier<CreateProductState> {
  CreateProductNotifier() : super(const CreateProductState());

  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
