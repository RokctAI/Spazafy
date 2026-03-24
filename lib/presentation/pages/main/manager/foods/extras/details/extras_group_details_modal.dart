import 'package:rokctapp/infrastructure/models/data/product_data.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'widgets/edit_extras_item_modal.dart';
import 'widgets/delete_extras_item_modal.dart';
import 'widgets/group_detail_extras_item.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/extras/delete/delete_extras_group_modal.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/extras/update/update_extras_group_modal.dart';
import 'package:rokctapp/presentation/components/components_manager.dart';
import 'widgets/create_new_group_item_modal.dart';
import 'package:rokctapp/application/providers_manager.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';

class ExtrasGroupDetailsModal extends ConsumerStatefulWidget {
  final Group group;

  const ExtrasGroupDetailsModal({super.key, required this.group});

  @override
  ConsumerState<ExtrasGroupDetailsModal> createState() =>
      _ExtrasGroupDetailsModalState();
}

class _ExtrasGroupDetailsModalState
    extends ConsumerState<ExtrasGroupDetailsModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(extrasGroupDetailsProvider.notifier)
          .fetchGroupExtras(groupId: widget.group.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const ModalDrag(),
            ButtonsBouncingEffect(
              child: GestureDetector(
                onTap: () => help.AppHelpers.showCustomModalBottomSheet(
                  context: context,
                  modal: CreateNewGroupItemModal(group: widget.group),
                  isDarkMode: false,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterRemix.play_list_add_line,
                      color: AppStyle.blue,
                      size: 18.r,
                    ),
                    10.horizontalSpace,
                    Text(
                      help.AppHelpers.getTranslation(TrKeys.addNewExtras),
                      style: AppStyle.interSemi(
                        size: 14,
                        color: AppStyle.blue,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UnderlinedTextField(
              label: '',
              readOnly: true,
              initialText: widget.group.translation?.title,
              onTap: () => help.AppHelpers.showCustomModalBottomSheet(
                context: context,
                modal: UpdateExtrasGroupModal(group: widget.group),
                isDarkMode: true,
              ),
              suffixIcon: widget.group.shopId == LocalStorage.getShop()?.id
                  ? GestureDetector(
                      onTap: () => help.AppHelpers.showCustomModalBottomSheet(
                        context: context,
                        isDarkMode: true,
                        modal: DeleteExtrasGroupModal(group: widget.group),
                      ),
                      child: Icon(
                        FlutterRemix.delete_bin_fill,
                        size: 24.r,
                        color: AppStyle.red,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(extrasGroupDetailsProvider);
                  return state.isLoading
                      ? Center(
                          child: SizedBox(
                            width: 30.r,
                            height: 30.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 4.r,
                              color: AppStyle.blackColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: REdgeInsets.only(top: 16, bottom: 24),
                          shrinkWrap: true,
                          itemCount: state.extras.length,
                          itemBuilder: (context, index) =>
                              GroupDetailExtrasItem(
                                extras: state.extras[index],
                                onEditTap: () =>
                                    help.AppHelpers.showCustomModalBottomSheet(
                                      context: context,
                                      modal: EditExtrasItemModal(
                                        group: widget.group,
                                        extras: state.extras[index],
                                      ),
                                      isDarkMode: false,
                                    ),
                                onDeleteTap: () =>
                                    help.AppHelpers.showCustomModalBottomSheet(
                                      context: context,
                                      modal: DeleteExtrasItemModal(
                                        extras: state.extras[index],
                                      ),
                                      isDarkMode: false,
                                    ),
                              ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
