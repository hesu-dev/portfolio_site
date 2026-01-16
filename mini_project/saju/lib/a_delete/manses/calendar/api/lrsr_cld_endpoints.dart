// http://apis.data.go.kr/B090041/openapi/service/LrsrCldInfoService/
// getLunCalInfo?solYear=2015&solMonth=01&solDay=01&ServiceKey=서비스키
class LrsrCldEndpoints {
  static const String hostHttps = 'https://apis.data.go.kr';
  static const String basePath = '/B090041/openapi/service/LrsrCldInfoService';

  static const String getLunCalInfo = '$basePath/getLunCalInfo';
  static const String getSolCalInfo = '$basePath/getSolCalInfo';
  static const String getSpcifyLunCalInfo = '$basePath/getSpcifyLunCalInfo';
  static const String getJulDayInfo = '$basePath/getJulDayInfo';
}
