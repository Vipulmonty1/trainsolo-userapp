import 'dart:core';

import 'package:flutter/material.dart';
import 'package:trainsolo/api/api_service.dart';
import 'package:trainsolo/model/college_test_info.dart';
import 'package:trainsolo/model/fitness_response.dart';
import 'package:trainsolo/model/search_college_response.dart';
import 'package:trainsolo/utils/Constants.dart';
import 'package:trainsolo/videoplayer/vimeoplayer.dart';

class CollegeFitnessInfo extends StatelessWidget {
  final College college;
  final String IMAGE_URL = Constants.IMAGE_BASE_URL +
      "/images/"; // "http://35.80.202.55:4799/images/";

  const CollegeFitnessInfo({@required this.college});

  @override
  Widget build(BuildContext context) {
    String testOne = college.testone.replaceAll('\\', '');
    CollegeTestInfo collegeTestInfo1 = collegeTestInfoFromJson(testOne);
    String testTwo =
        college.testtwo != null ? college.testtwo.replaceAll('\\', '') : "";
    CollegeTestInfo collegeTestInfo2 =
        testTwo.isNotEmpty ? collegeTestInfoFromJson(testTwo) : null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        //color: Colors.black,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 100,
                width: double.infinity,
                color: Colors.white,
                child: Image.network(
                  college.logoname,
                  //height: 100,
                  //width: 100,
                )),
            SizedBox(
              height: 15,
            ),
            Text(
              collegeTestInfo1.name != null ? collegeTestInfo1.name : "",
              style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 237, 28, 36),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(collegeTestInfo1.explanation,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: 15,
            ),
            this.college.testonestandard != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Standard",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontWeight: FontWeight.w600)),
                  )
                : SizedBox(
                    height: 5,
                  ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  this.college.testonestandard != null
                      ? this.college.testonestandard
                      : "",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              height: 5,
            ),
            collegeTestInfo1.setupImgName != null
                ? Image.network(
                    IMAGE_URL + collegeTestInfo1.setupImgName,
                    height: 300,
                  )
                : SizedBox(
                    height: 5,
                  ),
            SizedBox(
              height: 15,
            ),
            collegeTestInfo1.id != null
                ? FutureBuilder<String>(
                    future: getTestVideoID(collegeTestInfo1.id),
                    builder: (context, snapshot) {
                      return snapshot.data != null
                          ? VimeoPlayer(id: snapshot.data, autoPlay: false)
                          : SizedBox(
                              height: 10,
                            );
                    })
                : SizedBox(
                    height: 1,
                  ),
            SizedBox(
              height: 15,
            ),
            collegeTestInfo2 != null
                ? Text(collegeTestInfo2.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 237, 28, 36),
                        fontWeight: FontWeight.w600))
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            collegeTestInfo2 != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(collegeTestInfo2.explanation,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  )
                : SizedBox(),
            collegeTestInfo2 != null && collegeTestInfo2.setupImgName != null
                ? Image.network(
                    IMAGE_URL + collegeTestInfo2.setupImgName,
                    height: 300,
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            this.college.testtwostandard != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Standard",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 237, 28, 36),
                            fontWeight: FontWeight.w600)),
                  )
                : SizedBox(
                    height: 5,
                  ),
            SizedBox(
              height: 15,
            ),
            this.college.testtwostandard != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        this.college.testtwostandard != null
                            ? this.college.testtwostandard
                            : "",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  )
                : SizedBox(
                    height: 5,
                  ),
            collegeTestInfo2 != null
                ? FutureBuilder<String>(
                    future: getTestVideoID(collegeTestInfo2.id),
                    builder: (context, snapshot) {
                      return snapshot.data != null
                          ? VimeoPlayer(
                              id: snapshot.data,
                              autoPlay: false,
                              position: 10,
                            )
                          : SizedBox(
                              height: 10,
                            );
                    })
                : SizedBox(
                    height: 5,
                  ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getTestVideoID(String strTestID) async {
    String drill = "";
    FitnessResponse fitnessData = await getFitnessList();

    if (fitnessData.status == "true") {
      drill = fitnessData.data[0].vimeoid;
      print("Current Video ID >>>>>>>>" + drill.toString());
    }

    return drill;
  }
}
