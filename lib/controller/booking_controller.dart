import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final Rx<TimeOfDay?> fromTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> toTime = Rx<TimeOfDay?>(null);

  final RxInt parkingAmount = 0.obs;

  final RxBool isNameValid = false.obs;
  final RxBool isVehicleNumberValid = false.obs;
  final RxBool isTimeValid = false.obs;

  void validateName(String value) {
    isNameValid.value = value.isNotEmpty;
  }

  void validateVehicleNumber(String value) {
    isVehicleNumberValid.value = value.isNotEmpty;
  }

  //void validateTime() {
    //isTimeValid.value = fromTime.value != null && toTime.value != null && fromTime.value!.isBefore(toTime.value!);
  //}

  void calculateAmountToPay() {
    if (isTimeValid.value) {
      int hours = toTime.value!.hour - fromTime.value!.hour;
      int minutes = toTime.value!.minute - fromTime.value!.minute;
      int totalMinutes = hours * 60 + minutes;
      parkingAmount.value = totalMinutes * 15;
    }
  }

  Map<String, dynamic> getPaypalMessage() {
    return {
      "amount": {
        "total": parkingAmount.value.toString(),
        "currency": "MXN",
        "details": {
          "subtotal": parkingAmount.value.toString(),
          "shipping": '0',
          "shipping_discount": 0
        }
      },
      "description": "Parking Fee Payment",
      "item_list": {
        "items": [
          {
            "name": "Parking Fee",
            "quantity": 1,
            "price": parkingAmount.value.toString(),
            "currency": "MXN"
          }
        ],
        "shipping_address": {
          "recipient_name": nameController.text,
          "line1": "",
          "line2": "",
          "city": "",
          "country_code": "MX",
          "postal_code": "",
          "phone": "",
          "state": ""
        },
      }
    };
  }

  void reset() {
    nameController.clear();
    vehicleNumberController.clear();
    fromTime.value = null;
    toTime.value = null;
    parkingAmount.value = 0;
    isNameValid.value = false;
    isVehicleNumberValid.value = false;
    isTimeValid.value = false;
  }
}