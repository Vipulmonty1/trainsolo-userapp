import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/SubscriptionBlocker.dart';

Future<void> _blockWithSubscription(BuildContext context, Function) async {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return SubscriptionBlocker(() => Function);
      });
}
