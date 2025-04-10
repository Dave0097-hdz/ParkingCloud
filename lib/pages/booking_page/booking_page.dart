import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:parkcloud/components/toast.dart';
import 'package:parkcloud/config/colors.dart';
import 'package:parkcloud/controller/parking_controller.dart';
import 'package:parkcloud/pages/homepage/home_page.dart';

class BookingPage extends StatefulWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final TextEditingController _nameController = TextEditingController();
  //final TextEditingController _vehicleNumberController = TextEditingController();
  
  final String slotId;
  final String slotName;

  BookingPage({Key? key, required this.slotId, required this.slotName}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}
  

class _BookingPageState extends State<BookingPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vehicleNumber = TextEditingController();
    TimeOfDay? _fromTime;
    TimeOfDay? _toTime;
    int _amountToPay = 0;
    bool _isMounted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ParkingController parkingController = Get.put(ParkingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("BOOK SLOT"),
        backgroundColor: blueColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: widget._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animation/running_car.json',
                        width: 300,
                        height: 200,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Book Now",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: blueColor,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Enter Vehicle Number ",
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _vehicleNumber,
                    onChanged: (value) {
                    },
                    decoration: const InputDecoration(
                      fillColor: lightBg,
                      filled: true,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.car_rental,
                        color: blueColor,
                      ),
                      hintText: "Enter Vehicle Number",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Vehicle Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Choose Slot Time (in Minutes)",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("From Time"),
                          const SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              showTimePicker(
                                context: context, 
                                initialTime: TimeOfDay.now(),
                              ).then((selectedTime){
                                if (selectedTime != null) {
                                  setState(() {
                                    _fromTime = selectedTime;
                                    _calculateAmount();
                                  });
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                              decoration: BoxDecoration(
                                border:  Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(_fromTime != null ? _fromTime!.format(context) : 'Select'),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("To Time"),
                          const SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              showTimePicker(
                                context: context, 
                                initialTime: TimeOfDay.now(),
                              ).then((selectedTime){
                                if (selectedTime != null) {
                                  setState(() {
                                    _toTime = selectedTime;
                                    _calculateAmount();
                                  });
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                              decoration: BoxDecoration(
                                border:  Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(_toTime != null ? _toTime!.format(context) : 'Select'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Your Slot Name",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.slotName,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Amount to be Pay"),
                      Row(
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            size: 30,
                            color: blueColor,
                          ),
                          Text(
                            _amountToPay.toString(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: blueColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: (){
                      _paynow();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "PAY NOW",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _calculateAmount() {
    if (_fromTime != null && _toTime != null) {
      int hours = _toTime!.hour - _fromTime!.hour;
      int minutes = _toTime!.minute - _fromTime!.minute;
      if (minutes < 0) {
        hours--; //Decrement hours if the minutes ar negative
        minutes += 60; //Convert negative minutes to positive
      }
      int totalMinutes = hours * 60 + minutes;
      int hourlyRate = 15;
      int perQuarterHourRate = 4;
      int totalAmount = (hours * hourlyRate) + ((totalMinutes % 60) ~/ 15 * perQuarterHourRate);
      _amountToPay = totalAmount;
    } else {
      _amountToPay = 0;
    }
  }

 void _paynow() async {

  String numerovehiculo = _vehicleNumber.text;

  if (numerovehiculo.isEmpty || _fromTime ==null || _toTime == null){
    showToast(message: 'Porfavor rellene todos los campos');
  }else{

    DateTime fecha_inicio = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,_fromTime!.hour,_fromTime!.minute,);
    DateTime fecha_terminar = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,_toTime!.hour,_toTime!.minute,);
    String slotName = widget.slotName;

  _subirInfo(ApartarModel(
    
        matricula: numerovehiculo,
        fecha_inicio: fecha_inicio,
        fecha_terminar: fecha_terminar,
        id:slotName
        
        ));
      }
  }

    void _subirInfo(ApartarModel apartarModel) async {
    final bookCollection = FirebaseFirestore.instance.collection("parking");

    final newUser = apartarModel.toJson();

    try {
      await bookCollection.doc(apartarModel.id).update(newUser);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Tu lugar se ha apartado correctamente"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Regresar a la vista de HomePage
                  Get.offAll(() => HomePage(slotId: apartarModel.id!, slotName: apartarModel.id!));
                },
                child: Text('close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error al apartar el lugar: $e");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Ocurrió un error al apartar el lugar. Por favor, intenta de nuevo más tarde."),
          );
        },
      );
    }
  }
}

class ApartarModel{
    final String? matricula;
    final DateTime? fecha_inicio;
    final DateTime? fecha_terminar;
    final String? id;
    final int estado = 1;

  ApartarModel({required this.fecha_inicio, required this.fecha_terminar,required this.id, required this.matricula, estado});

  static ApartarModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>>snapshot){
    return ApartarModel(
      matricula: snapshot['matricula'],
      fecha_inicio: snapshot['fecha_inicio'],
      fecha_terminar: snapshot['fecha_terminar'],
      estado: snapshot['estado'],
      id: snapshot['id']
      );
  }

  Map<String, dynamic> toJson(){
    return{
      "matricula": matricula,
      "fecha_inicio": fecha_inicio,
      "fecha_terminar": fecha_terminar,
      "id": id,
      "estado": estado
    };
  }
}