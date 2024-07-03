class AppConstants {
  static const String appName = 'JamiiPass';
  static const double appVersion = 1.0;

  // Shared Preference Key
  static const String token = 'token';
  static const String user = 'user';
  static const String userAccount = 'userAccount';
  static const String isLogin = 'is_login';
  static const String isNotFirstLogin = 'is_not_firstLogin';
  static const String language = 'lang';
  static const String isFirstTime = 'isFirstTime';


  // API URLS
  static const String apiBaseUrl = 'http://192.168.164.128:4000/';
  static const String mediaBaseUrl = 'http://192.168.164.128:4000';
  static const String nidaBaseUrl = 'http://192.168.242.123:5000/api/nida_info';
  static const String apiCorpVerifyOtp =
      'http://192.168.164.128:4000/app/corp/auth/verify_corp_otp';
  static const String verifyPhoneUrl = 'user-management/register';
  static const String apiCorpLogin =
      'http://192.168.164.128:4000/app/corp/auth/login';
  static const String apiUserRegistration =
      'http://192.168.164.128:4000/app/citizen/auth/register';
  static const String apiUserLogin =
      'http://192.168.164.128:4000/app/citizen/auth/login';
  static const String apiUserVerifyOtp =
      'http://192.168.164.128:4000/app/citizen/auth/verify_user_otp';
  static const String corpShareHistory = 'app/corp/share_history';
  static const String corpShareId = 'app/corp/share_id';
  static const String allOrgs = 'app/org/all_orgs';
  static const String allCorps = 'app/corp/all_corporates';
  static const String corpUpdateProfileInfo = 'app/corp/update_profile';
  static const String corpUpdateProfilePic = 'app/corp/update_profile_pic';
  static const String allUsers = 'app/citizen/all_users';
  static const String userUpdateProfileInfo = 'app/citizen/update_profile';
  static const String userUpdateProfilePic = 'app/citizen/update_profile_pic';
   static const String userShareHistory = 'app/citizen/share_history';
   static const String userDeleteShareHistory = 'app/citizen/delete_share_his';
  static const String orgIdentification = 'app/org/org_identifications';
  static const String identificationRequest =
      'app/org/create_identification_request';
  static const String allIdentificationRequest = 'app/citizen/all_id_requests';
  static const String homeStats = 'app/citizen/stats';
  static const String getIdentitiesFromNtwork =
      'channels/mychannel/chaincodes/id';
  static const String networkLogin = 'users/login';
}
