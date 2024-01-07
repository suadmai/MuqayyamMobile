import 'package:flutter/material.dart';

class PrayerTimeWidget extends StatefulWidget {
  final String prayerName;
  final Color iconColour;
  final IconData prayerIcon;
  final String prayerTime;
  const PrayerTimeWidget({
    Key? key,
    required this.prayerName,
    required this.iconColour,
    required this.prayerIcon,
    required this.prayerTime,
  }) : super(key: key);

  @override
  _PrayerTimeState createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State <PrayerTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            widget.prayerIcon,
            color: widget.iconColour,
            size: 32,
          ),
          //SizedBox(height: 3,),
          Text(widget.prayerName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
          //display prayer time in 24 hour format
          Text(
          widget.prayerTime,
          style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}