import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parkcloud/Data.dart';

// ignore: camel_case_types
class Splace_Screen extends StatelessWidget {
  const Splace_Screen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Expanded(
            flex: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animation/running_car.json',
                      width: 300,
                      height: 300,
                      ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CAR PARKING",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Esta es una aplicacion de estacionamiento inteligente. Aqui puedes encontrar espacios disponibles y reservar su espacio desde cualquier lugar en el que se encuentre todo puede hacerlo desde un dispositivo movil",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Flexible(
                  child: Image.asset(
                    collageLogo,
                    fit: BoxFit.contain,
                    width: 700,
                  ))
                ],
              )),
        ]),
      ),
    );
  }
}