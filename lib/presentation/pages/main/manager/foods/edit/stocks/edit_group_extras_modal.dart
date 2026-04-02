import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart'
    as help;
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/theme/app_style.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_drag.dart';
import 'package:rokctapp/presentation/components/helper/manager/modal_wrap.dart';
import 'package:rokctapp/presentation/components/list_items/manager/group_extras_item.dart';

import 'package:rokctapp/infrastructure/models/data/manager/extras.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/app_helpers.dart';

class EditGroupExtrasModal extends ConsumerStatefulWidget {
  final int groupIndex;

  const EditGroupExtrasModal({super.key, required this.groupIndex});

  @override
  ConsumerState<EditGroupExtrasModal> createState() =>
      _EditGroupsExtrasModalState();
}

class _EditGroupsExtrasModalState extends ConsumerState<EditGroupExtrasModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(editFoodStocksProvider.notifier)
          .fetchGroupExtras(context, groupIndex: widget.groupIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrap(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const ModalDrag(),
              TitleAndIcon(
                title: help.AppHelpers.getTranslation(TrKeys.extras),
                titleSize: 16,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(editFoodStocksProvider);
                  final event = ref.read(editFoodStocksProvider.notifier);
                  return state.isLoading
                      ? Padding(
                          padding: REdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.r,
                              color: AppStyle.primary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: REdgeInsets.symmetric(vertical: 20),
                          shrinkWrap: true,
                          itemCount: state.activeGroupExtras.length,
                          itemBuilder: (context, index) => GroupExtrasItem(
                            extras: state.activeGroupExtras[index],
                            onTap: () => event.setActiveExtrasIndex(
                              itemIndex: index,
                              groupIndex: widget.groupIndex,
                            ),
                            isSelected: (state.selectGroups.values.any(
                              (List<Extras?> element) => element.any(
                                (Extras? item) =>
                                    item?.id ==
                                    state.activeGroupExtras[index].id,
                              ),
                            )),
                          ),
                        );
                },
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
