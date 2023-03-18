class ResponseDecoder{

  static Map<String, dynamic> convertMap(Map<dynamic, dynamic> map) {
    Map<String, dynamic> convertedMap = {};
    for (var key in map.keys) {
      if (map[key] is Map) {
        convertedMap[key.toString()] = convertMap(map[key]);
      }else{
        convertedMap[key.toString()] = map[key];
      }
    }
    return Map<String, dynamic>.from(convertedMap);
  }


  static String formatContentLength(int contentLength){
    if(contentLength >= 1024 * 1024){
      return "${(contentLength / (1024 * 1024)).floorToDouble()} MB";
    }else if(contentLength >= 1024){
      return "${(contentLength/1024).floorToDouble()} KB";
    }
    return "$contentLength B";
  }

}