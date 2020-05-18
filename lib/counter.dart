import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final String number;
  final String title;
  final Color color;

  Counter({this.number, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shadowColor: Colors.teal,
        color: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(6),
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(.26),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: color,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                number,
                style: TextStyle(
                  fontSize: 28,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
