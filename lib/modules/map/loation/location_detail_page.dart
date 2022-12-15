import 'package:findus/constants/common_sizes.dart';
import 'package:findus/global_widgets/banner_ad.dart';
import 'package:findus/helper/show_toast.dart';
import 'package:findus/model/Location.dart';
import 'package:findus/modules/app/app.dart';
import 'package:findus/modules/map/map_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocationDetail extends GetView<MapController> {
  const LocationDetail(this.location, {super.key});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(CommonGap.xs),
          child: AppBar(
            leading: const SizedBox(),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              curve: Curves.ease,
                              height: Get.height * 40 / 100,
                              duration: const Duration(milliseconds: 800),
                              child: ImageSlideshow(
                                width: Get.width * 85 / 100,
                                indicatorColor: Colors.blueAccent,
                                children: controller
                                        .locationDetail.value!.image!.isEmpty
                                    ? [Image.asset('assets/splash.png')]
                                    : List.generate(
                                        controller.locationDetail.value!.image!
                                            .length, (index) {
                                        return Image.network(
                                          controller.locationDetail.value!
                                              .image![index].imageUrl!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        );
                                      }),
                              ),
                            ),
                          ),
                        ],
                      )),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.only(top: CommonGap.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              location!.locationName!,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'SF-Pro-Regular',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if(location.room_number!= null)
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${location.room_number}${'호'.tr}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'SF-Pro-Regular',
                                    fontWeight: FontWeight.bold),
                              )
                            ),
                          const SizedBox(
                            height: 10,
                          ),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              location!.categoryName!,
                              style: TextStyle(
                                  color: HexColor('#444444'),
                                  fontSize: 16.0,
                                  fontFamily: 'SF-Pro-Regular'),
                            ),
                          ),
                          const SizedBox(
                            height: CommonGap.s,
                          ),
                          SizedBox(
                            height: Get.height / 10,
                            width: Get.width,
                            child: const Center(child: BannerAdWidget()),
                          ),
                          const SizedBox(
                            height: CommonGap.s,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: controller.detail_page_menu == 1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                SvgPicture.asset(
                                    'assets/find_us_images/common/mappicker.svg'),
                                const SizedBox(
                                  width: CommonGap.m,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Get.width * 60 / 100,
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            strutStyle:
                                                const StrutStyle(fontSize: 1.0),
                                            text: TextSpan(
                                                text:
                                                    '${location!.address1_en} ${location!.address2_en}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  height: 1.4,
                                                  fontSize: 14.0,
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    '${location!.address1_en!} ${location!.address2_en!}'));
                                            //Get.snackbar('알림'.tr, '복사_완료'.tr, backgroundColor: Colors.white, margin: EdgeInsets.only(top: 5) );
                                            showToast(context, '복사_완료'.tr);
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/find_us_images/common/copy.svg'),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                '복사'.tr,
                                                style: const TextStyle(
                                                    color: Colors.blueAccent),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Get.width * 60 / 100,
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            strutStyle:
                                                const StrutStyle(fontSize: 1.0),
                                            text: TextSpan(
                                                text:
                                                    '${location!.address1_ko} ${location!.address2_ko}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  height: 1.4,
                                                  fontSize: 14.0,
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                              text:
                                                  '${location!.address1_ko} ${location!.address2_ko}',
                                            ));
                                            //Get.snackbar('알림'.tr, '복사_완료'.tr);
                                            showToast(context, '복사_완료'.tr);
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/find_us_images/common/copy.svg'),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                '복사'.tr,
                                                style: const TextStyle(
                                                    color: Colors.blueAccent),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                SvgPicture.asset(
                                    'assets/find_us_images/common/phone.svg'),
                                const SizedBox(
                                  width: CommonGap.m,
                                ),
                                Text(controller
                                    .selectedLocation.value!.locationPhone!),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    FlutterPhoneDirectCaller.callNumber(
                                      controller.selectedLocation.value!
                                          .locationPhone!,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/find_us_images/common/phone.svg',
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '전화걸기'.tr,
                                        style: const TextStyle(
                                            color: Colors.blueAccent),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          controller.locationDetail.value?.openTime != null &&
                                  ((controller.locationDetail.value?.openTime
                                              ?.length ??
                                          0) >
                                      1)
                              ? const Divider()
                              : SizedBox(),
                          controller.locationDetail.value?.openTime != null &&
                                  ((controller.locationDetail.value?.openTime
                                              ?.length ??
                                          0) >
                                      1)
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      SvgPicture.asset(
                                          'assets/find_us_images/common/worktime.svg'),
                                      const SizedBox(
                                        width: CommonGap.m,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...controller
                                              .locationDetail.value!.openTime!
                                              .map(
                                                (e) => Row(
                                                  children: [
                                                    Text(
                                                      e.openDay ?? '',
                                                    ),
                                                    const SizedBox(
                                                      height: CommonGap.xl,
                                                    ),
                                                    Text(
                                                        ' ${e.openTime!} ~ ${e.closeTime!}'),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                SvgPicture.asset(
                                    'assets/find_us_images/common/document.svg'),
                                const SizedBox(
                                  width: CommonGap.m,
                                ),
                                Expanded(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                    strutStyle: const StrutStyle(fontSize: 1.0),
                                    text: TextSpan(
                                        text: '${location!.description}!',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          height: 1.4,
                                          fontSize: 14.0,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height / 15,
                child: FloatingActionButton(
                  onPressed: () {
                    Get.back();
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.navigate_before,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void onInit() {}
}
