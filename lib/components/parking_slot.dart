import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkcloud/config/colors.dart';
import 'package:parkcloud/pages/booking_page/booking_page.dart';


class ParkingSlot extends StatelessWidget {
  final bool? isParked;
  final bool? isBooked;
  final String? slotName;
  final String slotId;
  final String time;

  const ParkingSlot({
    super.key,
    this.isParked,
    this.isBooked,
    this.slotName,
    this.slotId = "0.0",
    required this.time, required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DashedContainer(
      dashColor: Colors.blue.shade300,
      dashedLength: 10.0,
      blankLength: 9.0,
      strokeWidth: 1.0,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 180,
        height: 120,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                time == ""
                    ? SizedBox(width: 1)
                    : Container(
                        child: Text(time),
                      ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade100,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    slotName.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  child: Text(""),
                )
              ],
            ),
            SizedBox(height: 10),
            if (isBooked == false)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/car.png"),
                    Text(
                      "BOOKED",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              )
            else if (isParked == true && (slotId == "1" || slotId == "2" || slotId == "3"))
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/car.png"),
                    Text(
                      "PARKED",
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Get.to(BookingPage(
                        slotId: slotId,
                        slotName: slotName.toString(),
                      ));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "BOOK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
