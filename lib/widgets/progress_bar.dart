import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.amber,
      ),
    ),
  );
}
