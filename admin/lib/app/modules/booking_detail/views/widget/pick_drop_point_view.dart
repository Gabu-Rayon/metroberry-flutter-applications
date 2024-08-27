import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:admin/app/utils/app_colors.dart';
import 'package:admin/app/utils/dark_theme_provider.dart';
import 'package:admin/widget/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class PickDropPointView extends StatelessWidget {
  final String pickUpAddress;
  final String dropAddress;

  const PickDropPointView({
    super.key,
    required this.pickUpAddress,
    required this.dropAddress,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width  * 100,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: themeChange.isDarkTheme() ? AppThemData.primary950 : AppThemData.primary50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Timeline.tileBuilder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: 0,
        ),
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.basic,
          indicatorBuilder: (context, index) {
            return index == 0 ? SvgPicture.asset("assets/icons/ic_pick_up.svg") : SvgPicture.asset("assets/icons/ic_drop_in.svg");
          },
          connectorBuilder: (context, index, connectorType) {
            return DashedLineConnector(
              color: themeChange.isDarkTheme() ? AppThemData.greyShade50 : AppThemData.greyShade950

            );
          },
          contentsBuilder: (context, index) => index == 0
              ? Container(
                  width: MediaQuery.of(context).size.width  * 100,
                  // padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                      title:   'Pickup Point'.tr,
                        fontSize: 14,

                        // style: GoogleFonts.inter(
                        //   color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade50
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w400,
                        // ),
                      ),
                      TextCustom(
                       title:  pickUpAddress,
                        maxLine: 3,
                        fontSize: 16,
                        // maxLines: 3,
                        // overflow: TextOverflow.ellipsis,
                        // style: GoogleFonts.inter(
                        //   color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade50
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.w500,
                        // ),
                      )
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 100,
              // ResponsiveWidget
                  // padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    TextCustom(
                        title: 'Dropout Point'.tr,
                        fontSize: 14,

                        // style: GoogleFonts.inter(
                        //   color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade50
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w400,
                        // ),
                      ),
                      TextCustom(
                       title:  dropAddress,
                        maxLine: 3,
                        fontSize: 16,

                        // overflow: TextOverflow.ellipsis,
                        // style: GoogleFonts.inter(
                        //   color: themeChange.isDarkTheme() ? AppThemData.greyShade900 : AppThemData.greyShade50
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.w500,
                        ),

                    ],
                  ),
                ),
          itemCount: 2,
        ),
      ),
    );
  }
}
