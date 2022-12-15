import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findus/constants/common_sizes.dart';
import 'package:findus/global_widgets/custom_text_form_field.dart';
import 'package:findus/global_widgets/custom_textarea.dart';
import 'package:findus/modules/work/work_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selector/selector.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kpostal/kpostal.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../constants/style.dart';

class WorkUpdatePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();
  final _payAmountTxt = TextEditingController();
  final _phone = TextEditingController();
  final _address1 = "".obs;
  final _address2 = TextEditingController();
  final _selectedRegionName = "지역을_선택해주세요".tr.obs;
  final _selectedCategoryName = "업종을_선택해주세요".tr.obs;
  late int _selectedRegionId = -1;
  late int _selectedCategoryId = -1;

  final _selectedPayAmount = 100000.obs;

  @override
  Widget build(BuildContext context) {
    Selector.init(
        height: 300,
        radius: 8,
        itemExtent: 48,
        padding: 12,
        textSize: 14,
        textLeft: '취소'.tr,
        textRight: '선택'.tr,
        textColor: Colors.black,
        textColorLeft: Colors.black,
        textColorRight: Colors.black,
        lineColor: Colors.white70,
        backgroundColor: Colors.white,
    );

    final WorkController workController = Get.find();
    _title.text = workController.work.value?.subject ?? '';
    _content.text = workController.work.value?.content ?? '';
    var payTemp = workController.payList.where(
        (element) => element['value'] == workController.work.value?.workPay);
    if (payTemp.isEmpty) {
      _payAmountTxt.text = workController.work.value?.workPay.toString() ?? '0';
      _selectedPayAmount.value = 100000;
    } else {
      _selectedPayAmount.value = workController.work.value?.workPay ?? 100000;
    }
    _payAmountTxt.text = '${workController.work.value?.workPay ?? ''}';
    var _endDate = (workController.work.value?.endDate ??
            DateTime.now().toString().split(" ")[0])
        .obs;
    _phone.text = workController.work.value?.workPhone ?? '';
    _address1.value = workController.work.value?.workAddr1_ko ?? '';
    _address2.text = workController.work.value?.workAddr2_ko ?? '';

    _selectedRegionName.value =
        workController.work.value?.regionName ?? _selectedRegionName.value;
    _selectedCategoryName.value = workController.work.value?.workCategoryName ??
        _selectedCategoryName.value;
    _selectedRegionId = workController.work.value?.workRegionId ?? -1;
    _selectedCategoryId = workController.work.value?.workCategoryId ?? -1;

    var _lat = workController.work.value?.workLat;
    var _lng = workController.work.value?.workLng;
/* DatePicker 띄우기 */
    void showDatePickerPop() {
      Future<DateTime?> selectedDate = showDatePicker(
        context: context,
        initialDate: DateTime.parse(_endDate.value),
        //초기값
        firstDate: DateTime(2020),
        //시작일
        lastDate: DateTime(2030),
        //마지막일
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light(), //다크 테마
            child: child!,
          );
        },
      );

      selectedDate.then((dateTime) {
        if (dateTime != null) {
          _endDate?.value = dateTime.toString().split(" ")[0];
        }
      });
    }

    var maskPhoneFormatter = MaskTextInputFormatter(
        mask: '###-####-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    var maskCommaFormatter = MaskTextInputFormatter(
        mask: '###,###,###,###,###₩',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    var format = NumberFormat('###,###,###,###');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('모집글_작성'.tr, style: tapMenuTitleTextStyle),
        actions: [
          TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  workController.work.value?.subject = _title.text;
                  workController.work.value?.content = _content.text;
                  workController.work.value?.workPay =
                      (_selectedPayAmount.value == 0
                          ? int.parse(_payAmountTxt.text.replaceAll(',', ''))
                          : _selectedPayAmount.value);
                  workController.work.value?.workPhone = _phone.text;
                  workController.work.value?.workAddr1_ko = _address1.value;
                  workController.work.value?.workAddr2_ko = _address2.text;
                  workController.work.value?.endDate = _endDate.value;
                  workController.work.value?.workLat = _lat;
                  workController.work.value?.workLng = _lng;
                  workController.work.value?.workRegionId = _selectedRegionId;
                  workController.work.value?.workCategoryId =
                      _selectedCategoryId;
                  if (_title.text.isEmpty) {
                    throw Get.snackbar('알림'.tr, '제목을_입력해주세요_알림'.tr);
                  }
                  if (_content.text.isEmpty) {
                    throw Get.snackbar('알림'.tr, '내용을_입력해주세요_알림'.tr);
                  }
                  if (_selectedRegionId == -1) {
                    throw Get.snackbar('알림'.tr, '지역을_선택해주세요_알림'.tr);
                  }
                  if (_selectedCategoryId == -1) {
                    throw Get.snackbar('알림'.tr, '업종을_선택해주세요_알림'.tr);
                  }
                  if (_phone.text.isEmpty) {
                    throw Get.snackbar('알림'.tr, '핸드폰_번호를_입력해주세요_알림'.tr);
                  }
                  if (_address1.isEmpty) {
                    throw Get.snackbar('알림'.tr, '주소를_입력해주세요_알림'.tr);
                  }
                  if (_address2.text.isEmpty) {
                    throw Get.snackbar('알림'.tr, '상세주소를_입력해주세요_알림'.tr);
                  }
                  await workController.writeWork(workController.work.value!);

                  Get.back();

                  workController.work.value?.workId != null
                      ? Get.snackbar('알림'.tr, '게시글이_수정되었습니다'.tr)
                      : Get.snackbar('알림'.tr, '게시글이_등록되었습니다'.tr);
                }
              },
              child: Text(
                workController.work.value?.workId != null ? "편집".tr : "등록".tr,
                style: const TextStyle(color: Colors.blueAccent),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(CommonGap.m),
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CustomTextFormField(
                  controller: _title,
                  hint: '${"제목을_입력해주세요".tr}',
                  funValidator: null,
                ),
              ),
              const SizedBox(
                height: CommonGap.xxs,
              ),
              CustomTextArea(
                controller: _content,
                hint: "내용을_입력해주세요__10글자_이상".tr,
                funValidator: null,
              ),
              const SizedBox(
                height: CommonGap.m,
              ),
              Text(
                "근무지역".tr,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'SF-Pro-Regular'
                    // fontStyle: FontStyle.italic,
                    ),
              ),
              Obx(() => Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          print(workController.regionSelectorItem);
                          Selector.showSingleSelector(context,
                              list: workController.regionSelectorItem,
                              callBack: (selectorItem, position) {
                            _selectedRegionId = int.parse(selectorItem.id);
                            _selectedRegionName.value = selectorItem.name;
                          });
                        },
                        child: Text(
                          _selectedRegionName.value,
                        )),
                  )),
              const Divider(),
              const SizedBox(
                height: CommonGap.xs,
              ),
              Text(
                "업종".tr,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'SF-Pro-Regular'
                    // fontStyle: FontStyle.italic,
                    ),
              ),
              Obx(() => Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          print(workController.categorySelectorItem);
                          Selector.showSingleSelector(context,
                              list: workController.categorySelectorItem,
                              callBack: (selectorItem, position) {
                            _selectedCategoryId = int.parse(selectorItem.id);
                            _selectedCategoryName.value = selectorItem.name;
                          });
                        },
                        child: Text(_selectedCategoryName.value)),
                  )),
              const Divider(),
              const SizedBox(
                height: CommonGap.xs,
              ),
              Text(
                "일당".tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  // fontStyle: FontStyle.italic,
                ),
              ),
              Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'SF-Pro-Regular',
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: workController.payList
                          .map((item) => DropdownMenuItem(
                                value: item["value"],
                                child: Text(
                                  item["name"] as String,
                                  style: const TextStyle(
                                    fontFamily: 'SF-Pro-Regular',
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: _selectedPayAmount.value,
                      onChanged: (value) {
                        _selectedPayAmount.value = value as int;
                      },
                      // icon: const SizedBox.shrink(),
                      buttonElevation: 2,
                      itemHeight: 35,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 140,
                      dropdownWidth: Get.width / 1.2,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 2,
                      scrollbarAlwaysShow: true,
                    ),
                  )),
              Obx(() => Visibility(
                    visible: _selectedPayAmount.value == 0,
                    child: CustomTextFormField(
                      keyboardType: TextInputType.number,
                      controller: _payAmountTxt,
                      hint: "일당을_입력해주세요".tr,
                      changeEvent: (e) {
                        _payAmountTxt.text = format.format(
                            int.parse(_payAmountTxt.text.replaceAll(',', '')));
                        _payAmountTxt.value = TextEditingValue(
                            text: _payAmountTxt.text,
                            selection: TextSelection.collapsed(
                                offset: _payAmountTxt.text.length));
                      },
                      funValidator: null,
                    ),
                  )),
              const SizedBox(
                height: CommonGap.s,
              ),
              Text(
                "전화번호".tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  // fontStyle: FontStyle.italic,
                ),
              ),
              CustomTextFormField(
                keyboardType: TextInputType.number,
                controller: _phone,
                hint: "010-0000-0000",
                inputFormatters: [maskPhoneFormatter],
                funValidator: null,
              ),
              const SizedBox(
                height: CommonGap.xs,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "주소".tr,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'SF-Pro-Regular'
                        // fontStyle: FontStyle.italic,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KpostalView(
                                callback: (Kpostal result) {
                                  print(result.latitude);
                                  print(result.longitude);
                                  print(result.address);
                                  _address1.value = result.address;
                                  _lat = result.latitude;
                                  _lng = result.longitude;
                                },
                              ),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          '검색하기'.tr,
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        _address1.value,
                        style: const TextStyle(
                            fontSize: 16, fontFamily: 'SF-Pro-Regular'
                            // fontStyle: FontStyle.italic,
                            ),
                      )),
                ],
              ),
              Obx(() => _address1.value.length < 1
                  ? Text(
                      '주소를_검색해주세요'.tr,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 14),
                    )
                  : const Text(
                      '',
                      style: TextStyle(color: Colors.black54, fontSize: 0),
                    )),
              const SizedBox(
                height: CommonGap.xxs,
              ),
              const Divider(
                thickness: 1,
              ),
              CustomTextFormField(
                controller: _address2,
                hint: "상세_주소를_입력해주세요".tr,
                funValidator: null,
              ),
              const SizedBox(
                height: CommonGap.xs,
              ),
              Text(
                "마감일".tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  // fontStyle: FontStyle.italic,
                ),
              ),
              Obx(() => Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          showDatePickerPop();
                        },
                        child: Text(_endDate?.value as String)),
                  )),
              const SizedBox(
                height: CommonSize.buttonHeight * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
