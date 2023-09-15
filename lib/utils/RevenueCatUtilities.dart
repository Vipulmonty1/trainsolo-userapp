import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/check_promocode_response.dart';
import 'package:trainsolo/model/comp_user_response.dart';
import 'package:trainsolo/model/user_subscription_status_response.dart';

import 'Constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/user_subscription_status_response.dart';

Future<bool> checkNonFitnessAccess() async {
  try {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    if ((purchaserInfo.entitlements.all[Constants.ALL_ACCESS_ENTITLEMENT] !=
                null &&
            purchaserInfo
                .entitlements.all[Constants.ALL_ACCESS_ENTITLEMENT].isActive) ||
        (purchaserInfo.entitlements.all[Constants.LIMITED_ACCESS_ENTITLEMENT] !=
                null &&
            purchaserInfo.entitlements.all[Constants.LIMITED_ACCESS_ENTITLEMENT]
                .isActive)) {
      print("Active Entitlement ...");
      return true;
    } else {
      print("No active entitlement ...");
      return false;
    }
    // access latest purchaserInfo
  } on PlatformException catch (e) {
    // Error fetching purchaser info
    print("Error fetching purchaser info: $e");
    return false;
  }
}

Future<bool> checkFitnessAccess() async {
  try {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    print("List of entitlements: ${purchaserInfo.entitlements}");
    if (purchaserInfo.entitlements.all[Constants.ALL_ACCESS_ENTITLEMENT] !=
            null &&
        purchaserInfo
            .entitlements.all[Constants.ALL_ACCESS_ENTITLEMENT].isActive) {
      print("Active Fitness Entitlement ...");
      return true;
    } else {
      print("No active Fitness entitlement ...");
      return false;
    }
    // access latest purchaserInfo
  } on PlatformException catch (e) {
    // Error fetching purchaser info
    print("Error fetching purchaser info: $e");
    return false;
  }
}

// Checks whether user has had app for 14 days or 3 + sessions, return true if blocker should be rendered
// TODO: incorporate promo codes into this stage of the logic
Future<bool> checkAPIBlocker() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userdata = prefs.getString(Constants.USER_DATA);
  // print("User data: $userdata");
  final jsonResponse = json.decode(userdata);
  // print("Type of login input: ${jsonResponse.runtimeType}");
  LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);
  if (loginResponse.data != null) {
    String userId = loginResponse.data.user.userId.toString();
    print("User ID: $userId");
    // CheckPromoCodeResponse checkPromoCodeResponse =
    //     await checkUserPromocodeMapping(userId);
    // if (checkPromoCodeResponse != null &&
    //     checkPromoCodeResponse.status != null) {
    //   print("returned response");
    //   print("Response status: ${checkPromoCodeResponse.status}");
    //   if (checkPromoCodeResponse.status == "false") {
    //     return false;
    //   }
    // }
    CompTeamResponse compTeamResponse = await compUserTeam(userId);
    print("Team Response: $compTeamResponse");
    print("Team Response Status: ${compTeamResponse.status}");
    if (compTeamResponse != null && compTeamResponse.status != null) {
      if (compTeamResponse.status == "true") {
        return false;
      }
    }
    UserSubscriptionStatusResponse response =
        await getUserSubscriptionStatus(userId);
    print(
        "Response subscription required? ${response.data.subscription_required}");
    if (response != null && response.data != null) {
      if (response.data.subscription_required == "false") {
        return false;
      }
    }
    return true;
  } else {
    return true;
  }
}
