import 'package:get/get.dart';
import 'package:validators/validators.dart';

Function validateUsername() {
  //GetUtils.isEmail()
  return (String? value) {
    value = value?.trim();
    if (value!.isEmpty) {
      return "유저네임에 들어갈 수 없습니다.";
    } else if (!isAlphanumeric(value)) {
      return "유저네임에 한글이나 특수 문자가 들어갈 수 없습니다.";
    } else if (value.length > 12) {
      return "유저네임의 길이를 초과하였습니다.";
    } else if (value.length < 3) {
      return "유저네임의 최소 길이는 3자입니다.";
    } else {
      return null;
    }
  };
}

Function validatePassword() {
  return (String? value) {
    value = value?.trim();
    if (value!.isEmpty) {
      return "패스워드 공백이 들어갈 수 없습니다.";
    } else if (value.length > 12) {
      return "패스워드의 길이를 초과하였습니다.";
    } else if (value.length < 4) {
      return "패스워드의 최소 길이는 4자입니다.";
    } else {
      return null;
    }
  };
}

Function validateEmail() {
  return (String? value) {
    value = value?.trim();
    if (value!.isEmpty) {
      return "이메일은 공백이 들어갈 수 없습니다.";
    } else if (!isEmail(value)) {
      return "이메일 형식에 맞지 않습니다.";
    } else {
      return null;
    }
  };
}

Function validateTitle() {
  return (String? value) {
    value = value?.trim();
    if (value!.isEmpty) {
      return "제목은_공백이_들어갈_수_없습니다".tr;
    } else if (value.length > 30) {
      return "제목의 길이를 초과하였습니다. 30자 이내로 작성해주세요.";
    } else {
      return null;
    }
  };
}

Function validateContent() {
  return (String? value) {
    value = value?.trim();
    if (value!.isEmpty) {
      return "내용은_공백이_들어갈_수_없습니다".tr;
    } else if (value.length > 500) {
      return "내용의_길이를_초과하였습니다".tr;
    } else if (value.length < 10) {
      return "본문은_10글자_이상_입력해주세요".tr;
    } else {
      return null;
    }
  };
}



String? Function(String? value) validateComment() {
  return (String? value) {
    value = value?.trim();
    if (value!.isEmpty) {
      return "댓글은 공백이 들어갈 수 없습니다.";
    } else if (value.length < 0 ) {
      return "댓글은 1글자 이상 입력해주세요.";
    } else {
      return null;
    }
  };
}

String? Function(String? value) validatePhone() {


  return (String? value) {
    value = value?.trim();
    if (value!.isEmpty) {
      return "전화번호는_공백이_들어갈_수_없습니다".tr;
    }
    else if ( RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(value)) {
      return "전화번호_형식에_맞지_않습니다".tr;
    } else {
      return null;
    }
  };
}