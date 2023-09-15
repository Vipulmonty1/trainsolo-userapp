import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainsolo/model/chart_response.dart';
import 'package:trainsolo/model/college_list.dart';

import 'package:trainsolo/model/check_promocode_response.dart';
import 'package:trainsolo/model/check_token_response.dart';
import 'package:trainsolo/model/common_success.dart';
import 'package:trainsolo/model/comp_user_response.dart';
import 'package:trainsolo/model/fitness_response.dart';
import 'package:trainsolo/model/forgot_password_response.dart';
import 'package:trainsolo/model/get_all_position_response.dart';
import 'package:trainsolo/model/get_all_t_h_drill_records_response.dart';
import 'package:trainsolo/model/get_all_tech_hub_response.dart';
import 'package:trainsolo/model/get_drill_response.dart';
import 'package:trainsolo/model/get_global_leader_board_response.dart';
import 'package:trainsolo/model/get_plan_info_response.dart';
import 'package:trainsolo/model/get_plan_list_by_id_response.dart';
import 'package:trainsolo/model/get_t_h_drills_by_category_response.dart';
import 'package:trainsolo/model/get_team_by_userId.dart';
import 'package:trainsolo/model/get_teams_list_response.dart';
import 'package:trainsolo/model/get_users_response.dart';
import 'package:trainsolo/model/get_user_data_from_user_id_response.dart';
import 'package:trainsolo/model/get_videos_by_category_response.dart';
import 'package:trainsolo/model/insert_promocode_response.dart';
import 'package:trainsolo/model/library_response.dart';
import 'package:trainsolo/model/login_response.dart';
import 'package:trainsolo/model/reset_password_response.dart';
import 'package:trainsolo/model/single_app_param_response.dart';
import 'package:trainsolo/model/user_subscription_status_response.dart';

import 'package:http/http.dart' as http;
import 'package:trainsolo/model/mission_leaderboard_response.dart';
import 'package:trainsolo/model/mission_list_response.dart';
import 'package:trainsolo/model/personal_stats_response.dart';
import 'package:trainsolo/model/search_college_response.dart';
import 'package:trainsolo/model/search_drills_response.dart';
import 'package:trainsolo/model/shared_stats_response.dart';
import 'package:trainsolo/model/shared_stats_users_data_response.dart';

import 'dart:async';

import 'package:trainsolo/model/signup_response.dart';
import 'package:trainsolo/model/training_complete_info.dart';
import 'package:trainsolo/utils/Constants.dart';

Future login(String username, String password) async {
  String url = "signin";
  print("Username: $username");
  final json = {"USERNAME": username, "PASSWORD": password};
  http.Response response =
      await http.post(Uri.parse(Constants.apiBaseURL + url), body: json);
  final parsdata = jsonDecode(response?.body);
  print("Login Pars Data: $parsdata");
  // print("Login Pars Data runtime type: ${parsdata.runtimeType}");
  LoginResponse logindata = new LoginResponse.fromJson(parsdata);
  return logindata;
}

Future forgotPassword(String email) async {
  String url = "forgot-password";
  final json = {"EMAIL": email};
  http.Response response =
      await http.post(Uri.parse(Constants.apiBaseURL + url), body: json);
  final parsdata = jsonDecode(response?.body);
  ForgotPasswordResponse forgotpasswordreponse =
      new ForgotPasswordResponse.fromJson(parsdata);
  return forgotpasswordreponse;
}

Future checktoken(String email) async {
  String url = "check-token";
  final json = {"EMAIL": email};
  http.Response response =
      await http.post(Uri.parse(Constants.apiBaseURL + url), body: json);
  final parsdata = jsonDecode(response?.body);
  CheckTokenResponse checkTokenResponse =
      new CheckTokenResponse.fromJson(parsdata);
  return checkTokenResponse;
}

Future resetPassword(
    String email, String accessToken, String newPassword) async {
  String url = "reset-password";
  final json = {"EMAIL": email, "PASSWORD": newPassword, "TOKEN": accessToken};
  http.Response response =
      await http.post(Uri.parse(Constants.apiBaseURL + url), body: json);
  final parsdata = jsonDecode(response?.body);
  ResetPasswordResponse resetPasswordResponse =
      new ResetPasswordResponse.fromJson(parsdata);
  return resetPasswordResponse;
}

Future drillsall() async {
  String url = "drills";
  http.Response response = await http.get(Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetDrillResponse drillsdata = new GetDrillResponse.fromJson(parsdata);
  return drillsdata;
}

Future<FitnessResponse> getFitnessList() async {
  String url = "fitness";
  http.Response response = await http.get(Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  FitnessResponse fitnessdata = new FitnessResponse.fromJson(parsdata);
  return fitnessdata;
}

Future getFitnessByID(String strID) async {
  String url = "fitness/getFitnesstestById";

  http.Response response = await http.get(Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  FitnessResponse fitnessdata = new FitnessResponse.fromJson(parsdata);
  return fitnessdata;
}

Future generateFitnessChart(String userid, String username) async {
  String url = "fitness/generateChart";
  final json = {"USR_ID": userid, "USERNAME": username};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  ChartResponse fitnessdata = ChartResponse.fromJson(parsdata);
  return fitnessdata;
}

Future getTeamsList() async {
  String url = "teams";
  http.Response response = await http.get(Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetTeamsListResponse teamsListData =
      new GetTeamsListResponse.fromJson(parsdata);
  return teamsListData;
}

Future getTeamsListByUser(String userid) async {
  String url = "teams/getTeamByUserId";
  final json = {"USR_ID": userid};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetTeamsListResponse teamsListData =
      new GetTeamsListResponse.fromJson(parsdata);
  return teamsListData;
}

Future getUserList() async {
  String url = "users";
  http.Response response = await http.get(Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetUsersResponse userListData = new GetUsersResponse.fromJson(parsdata);
  return userListData;
}

Future getlibrary() async {
  String url = "library";
  http.Response response = await http.get(Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  LibraryResponse libraryResponsedata = new LibraryResponse.fromJson(parsdata);
  return libraryResponsedata;
}

Future getDrillByCategory(String category) async {
  String url = "commons/filterDrillsByCategory";

  final json = {"QUERY_INPUT": category};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetDrillResponse drillsdata = new GetDrillResponse.fromJson(parsdata);
  return drillsdata;
}

Future getAllTechHub(String category) async {
  String url = "techhub/getAllTechHub";
  print("::::::::::::::::::::::::::::::::tab::::::::::" + category);
  final json = {"TECHHUB_DIFFICULTY": category};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print("::::::::::::::::::::::::::::::::body::::::::::" + parsdata.toString());
  GetAllTechHubResponse drillsdata =
      new GetAllTechHubResponse.fromJson(parsdata);

  return drillsdata;
}

Future getTHDrillsByCategory(String tabName, String categoryName) async {
  String url = "techhub/getTHDrillsByCategory";
  final json = {"TECHHUB_DIFFICULTY": tabName, "CATEGORY": categoryName};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);

  GetTHDrillsByCategoryResponse drillsdata =
      new GetTHDrillsByCategoryResponse.fromJson(parsdata);

  return drillsdata;
}

Future getAllTHDrillRecords(String username, String userid) async {
  String url = "techhub/getAllTHDrillRecords";
  final json = {"USR_ID": userid, "USERNAME": username};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print("::::::::::::::::::::::::::::::::body::::::::::" + parsdata.toString());
  GetAllTHDrillRecordsResponse drillsdata =
      new GetAllTHDrillRecordsResponse.fromJson(parsdata);

  return drillsdata;
}

Future getPersonalStats(String userid, String username) async {
  String url = "profile/personalStats";
  final json = {"USR_ID": userid, "USERNAME": username};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print("PERSONAL STATS PARS DATA: $parsdata");
  PersonalStatsResponse responseData =
      new PersonalStatsResponse.fromJson(parsdata);

  return responseData;
}

Future getUserSubscriptionStatus(String userid) async {
  String url = "subscription/userSubscriptionStatus";
  final json = {"USR_ID": userid};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  // print("Pars Data: $parsdata");
  print("Type of subscription runtime type: ${parsdata.runtimeType}");
  UserSubscriptionStatusResponse responseData =
      new UserSubscriptionStatusResponse.fromJson(parsdata);

  return responseData;
}

Future updateSharingPlan(String userid, String username, String planid,
    String players, String teams, String sharewith) async {
  String url = "myplans/updateSharingPlan";

  final json = {
    "USR_ID": userid,
    "PLAN_ID": planid,
    "TEAMIDS": teams,
    "USERIDS": players,
    "USERNAME": username,
    "SHARE_WITH": sharewith
  };
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print(
      "::::::::::::::::::::::::::::::::body:::::::Shared Plan Store::::::::::::::::::::::::::::::::" +
          parsdata.toString());
  print("Pars Data: $parsdata");
  print("Pars Data runtime type: ${parsdata.runtimeType}");
  CommonSuccess responseData = new CommonSuccess.fromJson(parsdata);

  return responseData;
}

Future getSharedStats(String userid, String username) async {
  String url = "profile/sharedStats";
  print("::::::::::::::::::::::::::::::::username::::::::::" + username);
  print("::::::::::::::::::::::::::::::::userid::::::::::" + userid);
  final json = {"USR_ID": userid, "USERNAME": username};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print(
      "::::::::::::::::::::::::::::::::body:::::::getPersonalStats::::::::::::::::::::::::::::::::" +
          parsdata.toString());
  SharedStatsResponse responseData = new SharedStatsResponse.fromJson(parsdata);
  return responseData;
}

Future getSharedPlanUserList(String plnid) async {
  String url = "profile/sharedStatsUsers";
  final json = {"PLN_ID": plnid};

  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print(parsdata);
  SharedStatsUsersResponse userListData =
      new SharedStatsUsersResponse.fromJson(parsdata);
  return userListData;
}

Future createTeam(
    String userid, String username, String teamName, String players) async {
  String url = "teams/createTeam";
  print("::::::::::::::::::::::::::::::::username::::::::::" + username);
  print("::::::::::::::::::::::::::::::::userid::::::::::" + userid);
  print("::::::::::::::::::::::::::::::::teamName::::::::::" + teamName);
  print(
      "::::::::::::::::::::::::::::::::players::::::::::" + players.toString());
  final json = {
    "TEAM_ID": "",
    "USR_ID": userid,
    "USERNAME": username,
    "TEAM_NAME": teamName,
    "PLAYERS": players,
    "ADMINID": "",
    "RELATION_COACH_USR": ""
  };
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print("::::::::::::::::::::::::::::::::body::::::::::" + parsdata.toString());
  CommonSuccess commonSuccessData = new CommonSuccess.fromJson(parsdata);
  return commonSuccessData;
}

Future updateTeam(String userid, String username, String teamName,
    String players, TeamData teamData) async {
  String url = "teams/updateTeam";
  print("::::::::::::::::::::::::::::::::username::::::::::" + username);
  print("::::::::::::::::::::::::::::::::userid::::::::::" + userid);
  print("::::::::::::::::::::::::::::::::teamName::::::::::" + teamName);
  print(
      "::::::::::::::::::::::::::::::::players::::::::::" + players.toString());
  final json = {
    "TEAM_ID": teamData.teamid.toString(),
    "USR_ID": userid,
    "USERNAME": username,
    "TEAM_NAME": teamName,
    "PLAYERS": players,
    "ADMINID": "",
    "RELATION_COACH_USR": ""
  };
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print("::::::::::::::::::::::::::::::::body::::::::::" + parsdata.toString());
  CommonSuccess commonSuccessData = new CommonSuccess.fromJson(parsdata);
  return commonSuccessData;
}

Future getVideoByCategory(String category) async {
  String url = "library/getVideosByCategory";

  final json = {"GRP_BY": category};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetVideosByCategoryResponse videoistdata =
      new GetVideosByCategoryResponse.fromJson(parsdata);
  return videoistdata;
}

Future generatePlan(
    String participants,
    String objectives,
    String drillTime,
    String noOfDrills,
    String skillLevel,
    String userId,
    String userName) async {
  String url = "myplans/generatePlan";

  final json = {
    "NO_OF_PARTICIPANTS": participants,
    "CATEGORY": objectives,
    "SKILL_LEVEL": skillLevel,
    "NUMBER_OF_DRILLS": noOfDrills,
    "DURATIONS": drillTime,
    "USR_ID": userId,
    "USERNAME": userName
  };
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetDrillResponse drillsdata = new GetDrillResponse.fromJson(parsdata);
  return drillsdata;
}

Future createPlan(
    String planId,
    String userId,
    String userName,
    String planTitle,
    String durationJsonData,
    String totalDuration,
    StringthumbNail,
    String isbookd) async {
  String url = "myplans/createPlan";

  final json = {
    "PLAN_ID": planId,
    "USR_ID": userId,
    "USERNAME": userName,
    "PLAN_TITLE": planTitle,
    "DRILLS_JSON_DATA": durationJsonData,
    "TOTAL_DURATION": totalDuration,
    "THUMBNAIL_NAME": StringthumbNail,
    "IS_BOOKMARKED": isbookd
  };
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CommonSuccess commonSuccess = new CommonSuccess.fromJson(parsdata);
  return commonSuccess;
}

Future updatePlan(
    String planId,
    String userId,
    String userName,
    String planTitle,
    String durationJsonData,
    String totalDuration,
    StringthumbNail,
    String isbookd) async {
  String url = "myplans/updatePlan";

  final json = {
    "PLAN_ID": planId,
    "USR_ID": userId,
    "USERNAME": userName,
    "PLAN_TITLE": planTitle,
    "DRILLS_JSON_DATA": durationJsonData,
    "TOTAL_DURATION": totalDuration,
    "THUMBNAIL_NAME": StringthumbNail,
    "IS_BOOKMARKED": isbookd
  };
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CommonSuccess commonSuccess = new CommonSuccess.fromJson(parsdata);
  return commonSuccess;
}

Future getPlanInfo(String planId) async {
  String url = "myplans/getplanInfo";

  final json = {"PLAN_ID": planId};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetPlanInfoResponse getPlanInfoResponse =
      new GetPlanInfoResponse.fromJson(parsdata);
  return getPlanInfoResponse;
}

Future deletePlan(String planId) async {
  String url = "myplans/deletePlan";

  final json = {"PLAN_ID": planId};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CommonSuccess commonSuccess = new CommonSuccess.fromJson(parsdata);
  return commonSuccess;
}

Future searchDrill(String searchtext) async {
  String url = "commons/searchDrills";

  final json = {"QUERY_INPUT": searchtext};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  SearchDrillsResponse drillsdata = new SearchDrillsResponse.fromJson(parsdata);
  return drillsdata;
}

Future searchCollage(String searchtext) async {
  String url = "commons/searchCollege";

  final json = {"QUERY_INPUT": searchtext};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  SearchCollegeResponse collegedata =
      new SearchCollegeResponse.fromJson(parsdata);
  return collegedata;
}

Future collegeList() async {
  String url = "college";

  http.Response response = await http.get(Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CollegeList collegedata = new CollegeList.fromJson(parsdata);
  return collegedata;
}

Future getAllPositionList() async {
  String url = "usermanagement/getAllPosition";
  final json = {};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetAllPositionResponse getPositiondata =
      new GetAllPositionResponse.fromJson(parsdata);
  return getPositiondata;
}

Future getGlobalLeaderBoard(String userid) async {
  String url = "leaderboard/getGlobalLeaderBoard";

  final json = {"USR_ID": userid};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetGlobalLeaderBoardResponse globalleaderboardData =
      new GetGlobalLeaderBoardResponse.fromJson(parsdata);
  return globalleaderboardData;
}

Future getTeamsByUserId(String userid) async {
  String url = "teams/getTeamByUserId";
  final json = {"USR_ID": userid};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetTeamByUserIdResponse getTeamByUserIdResponse =
      new GetTeamByUserIdResponse.fromJson(parsdata);
  return getTeamByUserIdResponse;
}

Future getTimeTrainedLeaderBoard(String userid, int teamId) async {
  String url = "leaderboard/getTeamLeaderBoard";
  final json = {"USR_ID": userid, "TEAM_ID": teamId.toString()};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetGlobalLeaderBoardResponse getTeamLeaderShipBoard =
      new GetGlobalLeaderBoardResponse.fromJson(parsdata);
  return getTeamLeaderShipBoard;
}

Future getFitnessLeaderBoard(String userid, String fitnessId) async {
  String url = "leaderboard/getFitnessLeaderboard";
  final json = {"USR_ID": userid, "FITNESS_ID": fitnessId};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetGlobalLeaderBoardResponse getTeamLeaderShipBoard =
      new GetGlobalLeaderBoardResponse.fromJson(parsdata);
  return getTeamLeaderShipBoard;
}

Future preUserRegistration(
    String usernameSignup,
    String firstnameSignup,
    String lastnameSignup,
    String year,
    String month,
    String day,
    String emailSignup,
    String passwordSignup,
    String role,
    String gender,
    String level,
    String reason,
    String userPosition,
    String uuid,
    String teamProperty) async {
  String url = "usermanagement/preUserRegistration";
  final json = {
    "USER_ID": "",
    "USERNAME": usernameSignup,
    "PASSWORD": passwordSignup,
    "PIN": "",
    "PREFIX": "",
    "FIRST_NAME": firstnameSignup,
    "LAST_NAME": lastnameSignup,
    "ROLE": role,
    "LEVEL": level,
    "REASON_FOR_JOINING": reason,
    "EMAIL": emailSignup,
    "MOBILE": "",
    "CITY_ID": "",
    "STATE_ID": "",
    "COUNTRY_ID": "",
    "STATUS": "",
    "STATUS_REASON": "",
    "PROFILE_PIC_URL": "",
    "KICK_STARTER_ID": "",
    "GENDER": gender,
    "BIRTH_YEAR": year,
    "BIRTH_MONTH": month,
    "BIRTH_DAY": day,
    "POSITION_CODE": userPosition,
    "USER_SUBSCRIPTION_ID": uuid,
    "TEAM_PROPERTY": teamProperty
  };

  http.Response response =
      await http.post(Uri.parse(Constants.apiBaseURL + url), body: json);
  final parsdata = jsonDecode(response?.body);
  SignupResponse signupResponse = new SignupResponse.fromJson(parsdata);
  return signupResponse;
}

Future updateUserData(
    String firstname,
    String lastname,
    String year,
    String month,
    String day,
    String email,
    String userid,
    String prifix,
    String username,
    String role,
    String level,
    String gender,
    String reason,
    String mobile,
    String picurl,
    String positioncode,
    String teamproperty) async {
  String url = "usermanagement/updateUserData";
  // TEMPORARILY ADDING HARDCODED TEAM PROPERTY AS PART OF THE JSON
  final json = {
    "USR_ID": userid,
    "USERNAME": username,
    "EMAIL": email,
    "PREFIX": prifix != null ? prifix : "",
    "FIRST_NAME": firstname,
    "LAST_NAME": lastname,
    "ROLE": role,
    "LEVEL": level,
    "REASON_FOR_JOINING": reason,
    "MOBILE":
        mobile != null && mobile != "null" && mobile.length > 0 ? mobile : "",
    "PROFILE_PIC_URL":
        picurl != null && picurl != "null" && picurl.length > 0 ? picurl : "",
    "POSITION_CODE": positioncode,
    "GENDER": gender,
    "TEAM_PROPERTY": teamproperty
  };

  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());

  final parsdata = jsonDecode(response?.body);
  print("UPDATE USER DATA PROFILE RESPONSE: $parsdata");
  CommonSuccess updateUserDataresponse = new CommonSuccess.fromJson(parsdata);
  return updateUserDataresponse;
}

Future saveDataToTechHub(String userid, String username, String drillid,
    String date, String goals) async {
  String url = "techhub/saveDataToTechHub";
  final json = {
    "USR_ID": userid,
    "USERNAME": username,
    "DRILL_ID": drillid,
    "SCORE_TEXT": goals,
    "SCORE_DATE": date
  };
  print("JSON::::::::: ${jsonEncode(json)}");
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CommonSuccess commonSuccess = new CommonSuccess.fromJson(parsdata);
  return commonSuccess;
}

Future getPlansById(String userId, String name, String rowStatus) async {
  String url = "myplans/getPlansByUserId";
  final json = {"USR_ID": userId, "USERNAME": name, "RowStatus": rowStatus};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetPlanListByIdResponse planListResponse =
      new GetPlanListByIdResponse.fromJson(parsdata);
  return planListResponse;
}

Future getPlansByPlanId(String planId) async {
  String url = "myplans/getplanInfo";
  final json = {"PLAN_ID": planId};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  GetPlanListByIdResponse planListResponse =
      new GetPlanListByIdResponse.fromJson(parsdata);
  return planListResponse;
}

Future addingUserPractiseDuration(String userid, String username, int drillId,
    String planId, int rec_id, DateTime startDate, DateTime endDate) async {
  String url = "myplans/updateUsrTrnRecs";

  int duration = endDate.difference(startDate).inSeconds;

  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');

  final json = {
    "USR_ID": userid,
    "USERNAME": username,
    "DRILL_ID": drillId.toString(),
    "PLAN_ID": planId.toString(),
    "REC_ID": rec_id.toString(),
    "DURATIONS": duration.toString(),
    "STARTDATE": formatter.format(startDate),
    "ENDDATE": formatter.format(endDate)
  };
  print("JSON::::::::: ${jsonEncode(json)}");
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  print("JSON Response ${parsdata}");
  TrainingCompleteInfo trainingCompleteInfo =
      TrainingCompleteInfo.fromJson(parsdata);
  return trainingCompleteInfo;
}

Future getUserPractiseDuration(
    String userid, String username, String planId) async {
  String url = "myplans/checkCompletedDrills";

  final json = {
    "USR_ID": userid,
    "USERNAME": username,
    "PLAN_ID": planId.toString(),
  };

  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);

  TrainingCompleteInfo trainingCompleteInfo =
      TrainingCompleteInfo.fromJson(parsdata);
  return trainingCompleteInfo;
}

Future checkPromocode(String userid, String promocodeValue) async {
  String url = "promocode/check";
  final json = {"USR_ID": userid, "PROMOCODE": promocodeValue};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CheckPromoCodeResponse checkPromoCodeResponse =
      new CheckPromoCodeResponse.fromJson(parsdata);
  return checkPromoCodeResponse;
}

Future checkUserPromocodeMapping(String userid) async {
  String url = "promocode/checkUserMapping";
  final json = {"USR_ID": userid};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CheckPromoCodeResponse checkPromoCodeResponse =
      new CheckPromoCodeResponse.fromJson(parsdata);
  return checkPromoCodeResponse;
}

Future insertUserPromoCodeMapping(String userid, String validPromocode) async {
  String url = "promocode/InsertUserMapping";
  final json = {"USR_ID": userid, "PROMOCODE": validPromocode};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  InsertPromoCodeResponse checkPromoCodeResponse =
      new InsertPromoCodeResponse.fromJson(parsdata);
  return checkPromoCodeResponse;
}

Future getMissionLists(String userid, String username) async {
  String url = "missions/missionList";
  final json = {"USR_ID": userid, "USERNAME": username};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);

  MissionListResponse responseData = new MissionListResponse.fromJson(parsdata);

  return responseData;
}

Future enrolledForMissionAPI(
    String userid, String username, String missionId) async {
  String url = "missions/enrollInMission";

  final json = {
    "USR_ID": userid,
    "USERNAME": username,
    "MISSION_ID": missionId
  };
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);

  MissionListResponse responseData = new MissionListResponse.fromJson(parsdata);

  return responseData;
}

Future getUserDataFromId(String userId) async {
  String url = "users/getUserInfoById";

  final json = {"USR_ID": userId};

  // print("About to request response ...");
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  // print("About to parse data ...");
  // print("Response body: ${response?.body}");
  final parsdata = jsonDecode(response?.body);
  UserDataFromId responseData = new UserDataFromId.fromJson(parsdata);
  print("Response user data: $responseData");
  print("User data profile pic: ${responseData.profilepicurl}");
  print("User data username: ${responseData.username}");
  return responseData;
}

Future<Map<String, String>> getJWTTokenHeader() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userdata = prefs.getString(Constants.USER_DATA);
  final jsonResponse = json.decode(userdata);
  LoginResponse loginResponse = new LoginResponse.fromJson(jsonResponse);

  String JWTtoken = loginResponse.data.token;
  Map<String, String> tokens = Map();
  tokens = {"Authorization": "Bearer " + JWTtoken};

  return tokens;
}

Future getMissionLeaderBoard() async {
  String url = "leaderboard/missionLeaderboard";

  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      headers: await getJWTTokenHeader());

  final parsdata = jsonDecode(response?.body);

  MissionLeaderBoardResponse responseData =
      new MissionLeaderBoardResponse.fromJson(parsdata);
  print(responseData);
  return responseData;
}

Future getSingleAppParam(String appParamKey) async {
  String url = "appparams/getAppParamsByInput";
  final json = {"PAR_NAME": appParamKey};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  SingleAppParamResponse singleAppParamResponse =
      new SingleAppParamResponse.fromJson(parsdata);
  print("App param data: ${singleAppParamResponse.data}");
  print(singleAppParamResponse.data[0]['PAR_VALUE']);
  return singleAppParamResponse;
}

Future compUserTeam(String userId) async {
  String url = "usermanagement/checkTeamProperty";
  final json = {"USR_ID": userId};
  http.Response response = await http.post(
      Uri.parse(Constants.apiBaseURL + url),
      body: json,
      headers: await getJWTTokenHeader());
  final parsdata = jsonDecode(response?.body);
  CompTeamResponse compTeamResponse = new CompTeamResponse.fromJson(parsdata);
  return compTeamResponse;
}

class ChartDataList {
  final int index;
  //final String TEST_NAME;
  final int val;
  ChartDataList(this.index, this.val);
}
