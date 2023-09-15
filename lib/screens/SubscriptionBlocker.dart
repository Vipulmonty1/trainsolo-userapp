import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'package:trainsolo/screens/AdRendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trainsolo/model/single_app_param_response.dart';
import '../api/api_service.dart';

import 'package:trainsolo/model/OfferingItemModel.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/utils/RevenueCatUtilities.dart';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class SubscriptionBlocker extends StatefulWidget {
  // const SubscriptionBlocker({Key key}) : super(key: key);
  final void Function() callback;
  final bool leadsToFitness;
  SubscriptionBlocker(this.callback, [this.leadsToFitness = false]);

  @override
  _SubscriptionBlockerState createState() => _SubscriptionBlockerState();
}

class _SubscriptionBlockerState extends State<SubscriptionBlocker> {
  final List<OfferingItemModel> _subscriptionItems = [
    // ItemModel(0, 'assets/listimage.png', "\$89.99 / Year",
    //     'Training + All Features', true),
    // ItemModel(1, 'assets/listimage.png', '\$84.99 / Year', 'Training', true),
    // ItemModel(2, 'assets/listimage.png', '\$9.99 / Month',
    //     'Training + All Features', true),
  ];
  int subscriptionItemSelected = 0;
  Offerings _offerings;
  String _currentOfferingId;

  initializePurchaseOfferings() async {
    print("Initialize purchase offerings running ...");

    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    // print("Purchase Info: $purchaserInfo");
    // print("Entitlements: ${purchaserInfo.entitlements}");

    try {
      _offerings = await Purchases.getOfferings();
      // print("Offerings: $offerings");
      // print("Current Offering: ${offerings.current}");
      print("All offerings: ${_offerings.all}");
    } on PlatformException catch (e) {
      print("Platform Exception: $e");
    }
    addAllOfferings(_offerings);
  }

  // void addCurrentOffering(Offerings offerings) {
  //   this.setState(() {
  //     _subscriptionItems.add(ItemModel(
  //         0,
  //         'assets/listimage.png',
  //         offerings.current.availablePackages[0].product.priceString +
  //             getPaymentSuffix(offerings),
  //         offerings.current.availablePackages[0].product.description,
  //         true));
  //   });
  // }

  // TODO: Sort by price
  void addAllOfferings(Offerings offerings) {
    print("length of offerings ... ${offerings.all.length}");
    this.setState(() {
      int counter = 0;
      offerings.all.forEach((key, value) {
        _subscriptionItems.add(OfferingItemModel(
            counter,
            'assets/listimage.png',
            value.availablePackages[0].product.priceString +
                getPaymentSuffix(value.availablePackages[0].packageType),
            value.availablePackages[0].product.description,
            true,
            value.availablePackages[0].product.price,
            key));
        counter++;
        // print("Counter: ${counter}");
        print("Offering price: ${value.availablePackages[0].product.price}");
        _subscriptionItems
            .sort((a, b) => b.offeringPrice.compareTo(a.offeringPrice));
        _currentOfferingId =
            _subscriptionItems[subscriptionItemSelected].offeringId;
      });
    });
  }

  // TODO: Fix this method
  String getPaymentSuffix(PackageType type) {
    return type == PackageType.annual ? " / Year" : " / Month";
  }

  @override
  void initState() {
    initializePurchaseOfferings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      scrollable: true,
      // insetPadding: EdgeInsets.only(bottom: 100.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      // title: Row(
      //   children: [
      //     Expanded(
      //       flex: 1,
      //       child: Container(),
      //     ),
      //     Expanded(
      //       flex: 0,
      //       child: Positioned(
      //           child: Align(
      //         alignment: Alignment.topRight,
      //         child: GestureDetector(
      //             onTap: () {
      //               Navigator.pop(context);
      //               // Navigator.pop(context);
      //             },
      //             child: Container(
      //               width: 20.0,
      //               height: 20.0,
      //               decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   border: Border.all(
      //                     color: Colors.white,
      //                   ),
      //                   borderRadius:
      //                       BorderRadius.all(Radius.circular(20))),
      //               child: Center(
      //                 child: Icon(Icons.close,
      //                     color: Colors.black, size: 10),
      //               ),
      //             )),
      //       )),
      //     ),
      //   ],
      // ),
      content: Builder(
        builder: (context) {
          Color getColor(Set<MaterialState> states) {
            return Colors.red;
          }

          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  "Unlock",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'BebasNeue',
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "trainsolo Elite",
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'BebasNeue',
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //     "Keep working optimally towards fulfilling your potential and dreams!",
                //     maxLines: 2,
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16,
                //       fontFamily: 'HelveticaNeue',
                //     )),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: SizedBox.expand(
                                child: FittedBox(
                                  child: Image.asset('assets/subs1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150.0,
                            width: 150.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox.expand(
                                child: FittedBox(
                                  child: Image.asset("assets/subs2.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "CHOOSE YOUR PLAN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'HelveticaNeue',
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 240,
                  child: ListView.builder(
                      // Widget which creates [ItemWidget] in scrollable list.
                      itemCount: _subscriptionItems
                          .length, // Number of widget to be created.
                      itemBuilder: (context, itemIndex) => InkWell(
                            // Enables taps for child and add ripple effect when child widget is long pressed.
                            //onTap: () {},
                            onTap: () {
                              print("item was tapped");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 70,
                                child: Container(
                                  margin: const EdgeInsets.all(0.0),
                                  padding: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                  ),
                                  child: Container(
                                      child: Row(
                                    children: [
                                      Expanded(
                                        flex: 0,
                                        child: Checkbox(
                                          checkColor: Colors.white,
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                                  getColor),
                                          value: subscriptionItemSelected ==
                                              itemIndex,
                                          onChanged: (bool value) {
                                            setState(() {
                                              print(
                                                  "Checkbox item was clicked");
                                              subscriptionItemSelected =
                                                  itemIndex;
                                              _currentOfferingId =
                                                  _subscriptionItems[
                                                          subscriptionItemSelected]
                                                      .offeringId;
                                              print(
                                                  "New current offering id: $_currentOfferingId");
                                            });
                                          },
                                        ),
                                        // child: IconButton(
                                        //   icon: const Icon(
                                        //       this.subscriptionItemSelected ==
                                        //               itemIndex
                                        //           ? Icons.check_circle
                                        //           : Icons
                                        //               .radio_button_unchecked,
                                        //       color: Colors.red),
                                        //   tooltip:
                                        //       'Increase volume by 10',
                                        //   onPressed: () {
                                        //     setState(() {});
                                        //   },
                                        // ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  _subscriptionItems[itemIndex]
                                                      .title,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'HelveticaNeue',
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                              SizedBox(
                                                //Use of SizedBox
                                                height: 5,
                                              ),
                                              Text(
                                                  _subscriptionItems[itemIndex]
                                                      .description,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'HelveticaNeue',
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ],
                                          )),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                          )),
                ),
                SizedBox(height: 20),
                // button For CLOSE
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 4.0),
                //     child: FloatingActionButton.extended(
                //       backgroundColor: Color.fromARGB(255, 237, 28, 36),
                //       label: Text("Continue"),
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       shape: RoundedRectangleBorder(
                //           borderRadius:
                //               BorderRadius.all(Radius.circular(8.0))),
                //     ),
                //   ),
                // ),
                FlatButton(
                  padding: EdgeInsets.all(15.0),
                  color: Color.fromARGB(255, 237, 28, 36),
                  onPressed: () => {
                    //TODO: Need to test w/ physical iPhone to make sure I'm getting the subscription choice info printed out corectly and nothing bugs
                    Amplitude.getInstance(
                            instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
                        .logEvent("Subscription Start Training Clicked",
                            eventProperties: {
                          "subscription_choice_id": _offerings
                              .all[_currentOfferingId]
                              .availablePackages[0]
                              .identifier,
                          "subscription_choice_string_price": _offerings
                              .all[_currentOfferingId]
                              .availablePackages[0]
                              .product
                              .priceString,
                          "subscription_choice_double_price": _offerings
                              .all[_currentOfferingId]
                              .availablePackages[0]
                              .product
                              .price
                        }),
                    beginPurchaseFlow(),
                    // print("2 Route${ModalRoute.of(context)?.settings?.name}");
                    // Navigator.of(context, rootNavigator: true).pop();
                    // Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  // side: BorderSide(color: Colors.white)),
                  child: Text("Start Training",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
                FlatButton(
                  padding: EdgeInsets.all(15.0),
                  color: Colors.transparent,
                  onPressed: () {
                    startAdFlow();
                    // Navigator.of(context, rootNavigator: true).pop();
                    // Navigator.of(context, rootNavigator: true).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      side: BorderSide(color: Colors.white)),
                  child: Text(
                      "I'm not interested in 1,000+ personalized session plans.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ),
                // SizedBox(height: 20),
                // Text("Enter promocode in Profile",
                //     style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(height: 20),
                InkWell(
                    child: Text("Terms and Conditions",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    onTap: () => {
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent(
                                  "Subscription Terms and Conditions Clicked"),
                          launch(
                              'https://www.trainsolosoccer.com/terms-and-conditions')
                        }),
                SizedBox(height: 20),
                InkWell(
                    child: Text("Privacy Policy",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    onTap: () => {
                          Amplitude.getInstance(
                                  instanceName:
                                      Constants.AMPLITUDE_INSTANCE_NAME)
                              .logEvent("Subscription Privacy Policy Clicked"),
                          launch(
                              'https://www.trainsolosoccer.com/privacy-policy')
                        }),
                // Center(
                //   child: Text(
                //       "I'm not interested in 1,000+ personalized session plans",
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontFamily: 'SF UI Display'),
                //       textAlign: TextAlign.center),
                // ),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 4.0),
                //     child: FloatingActionButton.extended(
                //       backgroundColor: Colors.transparent,
                //       // width: MediaQuery.of(context).size.width,
                //       label: Text(
                //           "No, I don't want 1,000+ personalized sessions."),
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       shape: RoundedRectangleBorder(
                //           borderRadius:
                //               BorderRadius.all(Radius.circular(8.0)),
                //           side: BorderSide(color: Colors.white)),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.only(top: 5.0),
                //   child: Text(
                //       "TERMS OF AGREEMENTS. PAYMENT CAN ONLY BE STOPPED THROUGH A CANCELLATION 24 HOURS BEFORE THE BILLING DATE",
                //       maxLines: 4,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 10,
                //         fontFamily: 'HelveticaNeue',
                //       )),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> setAdAppParam(String paramKey, String paramDefault) async {
    String returnVal = paramDefault;
    SingleAppParamResponse adResponse = await getSingleAppParam(paramKey);
    if (adResponse != null && adResponse.data[0]['PAR_VALUE'] != null) {
      print("Param val: ${adResponse.data[0]['PAR_VALUE']}");
      returnVal = adResponse.data[0]['PAR_VALUE'];
    }
    return returnVal;
  }

  void startAdFlow() async {
    Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
        .logEvent("Subscription I'm Not Interested Clicked");
    String adDuration = await setAdAppParam("AD_DURATION", "20");
    String adVimeoId = await setAdAppParam("AD_VIDEO_VIMEO_ID", "689497169");
    String adHyperlink = await setAdAppParam(
        "AD_HYPERLINK", "https://www.americascoresbayarea.org/");
    String adButtonText = await setAdAppParam("AD_BUTTON_TEXT", "Learn More");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(seconds: int.parse(adDuration)), () {
            Navigator.of(context).pop(true);
          });
          return AdRendering(
            adVimeoId: adVimeoId,
            adHyperlink: adHyperlink,
            adButtonText: adButtonText,
            adDuration: adDuration,
          );
        });
    print("After show dialog mod");
    Future.delayed(Duration(seconds: int.parse(adDuration) + 1), () {
      Navigator.of(context).pop(true);
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("User completed ad", eventProperties: {
        "vimeoID": adVimeoId,
        "hyperlink": adHyperlink,
        "buttonText": adButtonText,
        "duration": adDuration
      });
      widget.callback();
    });
  }

  void beginPurchaseFlow() async {
    await makePurchase();
    bool userSuccessfullySubscribed = false;
    if (widget.leadsToFitness) {
      userSuccessfullySubscribed = await checkFitnessAccess();
    } else {
      userSuccessfullySubscribed = await checkNonFitnessAccess();
    }
    if (userSuccessfullySubscribed) {
      Navigator.of(context, rootNavigator: true).pop();
      widget.callback();
    } else {
      print("Before show dialog");
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 5), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text('Ad would go here'),
            );
          });
      print("After show dialog");
      Navigator.of(context, rootNavigator: true).pop();
    }
    // print("Route${ModalRoute.of(context)?.settings?.name}");
  }

  void makePurchase() async {
    try {
      print("All offerings: ${_offerings.all}");
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(
          _offerings.all[_currentOfferingId].availablePackages[0]);
      print(
          "Amplitdue ID that would be logged: ${_offerings.all[_currentOfferingId].availablePackages[0].identifier}");
      print(
          "Amplitdue price that would be logged: ${_offerings.all[_currentOfferingId].availablePackages[0].product.price}");
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Subscription Purchase Flow Successfully Completed",
              eventProperties: {
            "subscription_choice_id": _offerings
                .all[_currentOfferingId].availablePackages[0].identifier,
            "subscription_choice_string_price": _offerings
                .all[_currentOfferingId]
                .availablePackages[0]
                .product
                .priceString,
            "subscription_choice_double_price": _offerings
                .all[_currentOfferingId].availablePackages[0].product.price
          });
      print("Updated Entitlements: ${purchaserInfo.entitlements}");
    } on PlatformException catch (e) {
      Amplitude.getInstance(instanceName: Constants.AMPLITUDE_INSTANCE_NAME)
          .logEvent("Subscription Error During Purchase Flow",
              eventProperties: {
            "subscription_choice_id": _offerings
                .all[_currentOfferingId].availablePackages[0].identifier,
            "subscription_choice_string_price": _offerings
                .all[_currentOfferingId]
                .availablePackages[0]
                .product
                .priceString,
            "subscription_choice_double_price": _offerings
                .all[_currentOfferingId].availablePackages[0].product.price,
            "error": e
          });
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      print("Error Code: $errorCode");
    }
  }
}

// Future<void> _blockWithSubscription(BuildContext context) async {
//   // TODO: refactor into its own widget
//   return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (_) {
//         return SubscriptionBlocker(() => print("Callback"));
//       });
// }
