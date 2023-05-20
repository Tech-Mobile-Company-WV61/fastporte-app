import 'package:flutter/material.dart';

class UserCardInformation extends StatelessWidget {
  const UserCardInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12))
        ),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: SizedBox(
            width: 360,
            height: 110,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/imgs/user-vector.png',
                      height: 80,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, bottom: 20, right: 16, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Text('Nombres y Apellidos'),
                      Text('Vehiculo'),
                      Text('Numero de Estrellas')
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}