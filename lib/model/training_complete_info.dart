// To parse this JSON data, do
//
//     final trainingCompleteInfo = trainingCompleteInfoFromJson(jsonString);

import 'dart:convert';

TrainingCompleteInfo trainingCompleteInfoFromJson(String str) => TrainingCompleteInfo.fromJson(json.decode(str));

String trainingCompleteInfoToJson(TrainingCompleteInfo data) => json.encode(data.toJson());

class TrainingCompleteInfo {
  TrainingCompleteInfo({
    this.status,
    this.message,
    this.data,
  });

  String status;
  String message;
  List<trainingCompleteInfo> data;

  factory TrainingCompleteInfo.fromJson(Map<String, dynamic> json) => TrainingCompleteInfo(
    status: json["Status"],
    message: json["Message"],
    data: json["Data"] != null ?List<trainingCompleteInfo>.from(json["Data"].map((x) => trainingCompleteInfo.fromJson(x))):null,
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class trainingCompleteInfo {
  trainingCompleteInfo({
    this.completeHeader,
    this.currentStreak,
    this.alltimeWorkouts,
    this.completedDate,
    this.sessionTime,
    this.globalAvgSessionTime,
    this.drillsCompleted,
    this.globalAvgDrillsCompleted,
    this.levelNo,
    this.barForLevel,
    this.remainingLevelUpStr,
  });

  String completeHeader;
  int currentStreak;
  int alltimeWorkouts;
  String completedDate;
  String sessionTime;
  String globalAvgSessionTime;
  int drillsCompleted;
  String globalAvgDrillsCompleted;
  int levelNo;
  int barForLevel;
  String remainingLevelUpStr;

  factory trainingCompleteInfo.fromJson(Map<String, dynamic> json) => trainingCompleteInfo(
    completeHeader: json["COMPLETE_HEADER"],
    currentStreak: json["CURRENT_STREAK"],
    alltimeWorkouts: json["ALLTIME_WORKOUTS"],
    completedDate: json["COMPLETED_DATE"],
    sessionTime: json["SESSION_TIME"],
    globalAvgSessionTime: json["GLOBAL_AVG_SESSION_TIME"],
    drillsCompleted: json["DRILLS_COMPLETED"],
    globalAvgDrillsCompleted: json["GLOBAL_AVG_DRILLS_COMPLETED"],
    levelNo: json["LEVEL_NO"],
    barForLevel: json["BAR_FOR_LEVEL"],
    remainingLevelUpStr: json["REMAINING_LEVEL_UP_STR"],
  );

  Map<String, dynamic> toJson() => {
    "COMPLETE_HEADER": completeHeader,
    "CURRENT_STREAK": currentStreak,
    "ALLTIME_WORKOUTS": alltimeWorkouts,
    "COMPLETED_DATE": completedDate,
    "SESSION_TIME": sessionTime,
    "GLOBAL_AVG_SESSION_TIME": globalAvgSessionTime,
    "DRILLS_COMPLETED": drillsCompleted,
    "GLOBAL_AVG_DRILLS_COMPLETED": globalAvgDrillsCompleted,
    "LEVEL_NO": levelNo,
    "BAR_FOR_LEVEL": barForLevel,
    "REMAINING_LEVEL_UP_STR": remainingLevelUpStr,
  };
}
