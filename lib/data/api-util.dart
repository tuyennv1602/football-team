class ApiUtil {
  static final ApiUtil _instance = ApiUtil.internal();
  factory ApiUtil() => _instance;
  ApiUtil.internal();

  static const HOST = 'https://thedropapp.co/driverapi/';
  static const String AUTHORIZATION_DATA = "Xxx-Access-Token";
  static String token = '';

  
}