
import 'package:rokctapp/presentation/components/loading/loading_list.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/addons/widgets/addon_item.dart';
import 'package:rokctapp/presentation/pages/main/manager/foods/addons/edit/edit_addon_modal.dart';


import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';

class AddonsBody extends StatelessWidget {
  final RefreshController addonsController;

  const AddonsBody({super.key, required this.addonsController});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(addonsProvider);
        final event = ref.read(addonsProvider.notifier);
        return state.isLoading
            ? const LoadingList(
                verticalPadding: 16,
                itemBorderRadius: 0,
                itemPadding: 10,
              )
            : SmartRefresher(
                controller: addonsController,
                physics: const NeverScrollableScrollPhysics(),
                enablePullDown: true,
                enablePullUp: true,
                onLoading: () =>
                    event.fetchMoreAddons(refreshController: addonsController),
                onRefresh: () =>
                    event.refreshAddons(refreshController: addonsController),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: REdgeInsets.only(top: 16),
                  shrinkWrap: true,
                  itemCount: state.addons.length,
                  itemBuilder: (context, index) => AddonItem(
                    addon: state.addons[index],
                    onTap: () {
                      ref
                          .read(editAddonProvider.notifier)
                          .setAddonDetails(state.addons[index]);
                      ref
                          .read(editAddonUnitsProvider.notifier)
                          .setAddonUnit(state.addons[index].unit);
                      help.AppHelpers.showCustomModalBottomSheet(
                        paddingTop: 60,
                        context: context,
                        modal: EditAddonModal(addon: state.addons[index]),
                        isDarkMode: false,
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}

