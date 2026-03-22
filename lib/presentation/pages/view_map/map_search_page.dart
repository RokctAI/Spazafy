import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_place/google_place.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/presentation/components/buttons/pop_button.dart';
import 'package:rokctapp/presentation/components/text_fields/search_text_field.dart';
import 'package:rokctapp/presentation/theme/theme.dart';
import 'package:rokctapp/infrastructure/services/utils/app_connectivity.dart';
import 'package:rokctapp/infrastructure/services/utils/app_helpers.dart';
import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart';

@RoutePage()
class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  List<AutocompletePrediction> searchResult = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              16.verticalSpace,
              SearchTextField(
                autofocus: true,
                isBorder: true,
                onChanged: (title) async {
                  final connected = await AppConnectivity.connectivity();
                  if (connected) {
                    final res = await googlePlace.autocomplete.get(title);
                    if (mounted) {
                      searchResult = res?.predictions ?? [];
                      setState(() {});
                    }
                  } else {
                    if (mounted) {
                      AppHelpers.showCheckTopSnackBar(
                        context,
                        AppHelpers.getTranslation(
                          TrKeys.checkYourNetworkConnection,
                        ),
                      );
                    }
                  }
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResult.length,
                  padding: EdgeInsets.only(bottom: 22.h),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.maybePop(searchResult[index].placeId);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          22.verticalSpace,
                          Text(
                            searchResult[index]
                                    .structuredFormatting
                                    ?.mainText ??
                                "",
                            style: AppStyle.interNormal(size: 14),
                          ),
                          Text(
                            searchResult[index]
                                    .structuredFormatting
                                    ?.secondaryText ??
                                "",
                            style: AppStyle.interNormal(size: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Divider(color: AppStyle.borderColor),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: const PopButton(),
      ),
    );
  }
}

@RoutePage()
class ManagerMapSearchPage extends MapSearchPage {
  const ManagerMapSearchPage({super.key});
}
