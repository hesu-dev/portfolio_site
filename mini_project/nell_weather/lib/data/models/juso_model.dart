class JusoModel {
  final String roadAddr;      // 전체 도로명 주소
  final String jibunAddr;     // 지번 주소
  final String zipNo;         // 우편번호
  final String siNm;          // 시도명
  final String sggNm;         // 시군구명
  final String emdNm;         // 읍면동명
  final String rn;            // 도로명
  final String bdNm;          // 건물명 (API 응답 필드 확인 필요, 보통 bdNm)
  
  JusoModel({
    required this.roadAddr,
    required this.jibunAddr,
    required this.zipNo,
    required this.siNm,
    required this.sggNm,
    required this.emdNm,
    required this.rn,
    this.bdNm = '',
  });

  factory JusoModel.fromJson(Map<String, dynamic> json) {
    return JusoModel(
      roadAddr: json['roadAddr'] ?? '',
      jibunAddr: json['jibunAddr'] ?? '',
      zipNo: json['zipNo'] ?? '',
      siNm: json['siNm'] ?? '',
      sggNm: json['sggNm'] ?? '',
      emdNm: json['emdNm'] ?? '',
      rn: json['rn'] ?? '',
      bdNm: json['bdNm'] ?? '', // 행안부 API에서 건물명 필드
    );
  }
}

class JusoResponse {
  final List<JusoModel> jusoList;
  final String errorMessage;

  JusoResponse({required this.jusoList, this.errorMessage = ''});

  factory JusoResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'];
    if (results == null) return JusoResponse(jusoList: []);

    final common = results['common'];
    if (common != null && common['errorCode'] != '0') {
      return JusoResponse(jusoList: [], errorMessage: common['errorMessage'] ?? 'Unknown Error');
    }

    final jusoData = results['juso'];
    if (jusoData is List) {
      return JusoResponse(
        jusoList: jusoData.map((e) => JusoModel.fromJson(e)).toList(),
      );
    }
    
    return JusoResponse(jusoList: []);
  }
}
