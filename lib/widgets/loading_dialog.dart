import 'package:flutter/material.dart';
import 'package:jit_food/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  LoadingDialog({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(
            height: 10,
          ),
          Text(
            message! + "Please Wait...",
          ),
        ],
      ),
    );
  }
}
