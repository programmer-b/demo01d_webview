class KFMasterUrlModel {
  String? url;
  Headers? headers;
  String? method;
  String? hasGesture;
  String? isForMainFrame;
  String? isRedirect;

  KFMasterUrlModel(
      {this.url,
      this.headers,
      this.method,
      this.hasGesture,
      this.isForMainFrame,
      this.isRedirect});

  KFMasterUrlModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    headers =
        json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    method = json['method'];
    hasGesture = json['hasGesture'];
    isForMainFrame = json['isForMainFrame'];
    isRedirect = json['isRedirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    if (headers != null) {
      data['headers'] = headers!.toJson();
    }
    data['method'] = method;
    data['hasGesture'] = hasGesture;
    data['isForMainFrame'] = isForMainFrame;
    data['isRedirect'] = isRedirect;
    return data;
  }
}

class Headers {
  String? userAgent;
  String? referer;
  String? acceptEncoding;
  String? range;

  Headers({this.userAgent, this.referer, this.acceptEncoding, this.range});

  Headers.fromJson(Map<String, dynamic> json) {
    userAgent = json['User-Agent'];
    referer = json['Referer'];
    acceptEncoding = json['Accept-Encoding'];
    range = json['Range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['User-Agent'] = userAgent;
    data['Referer'] = referer;
    data['Accept-Encoding'] = acceptEncoding;
    data['Range'] = range;
    return data;
  }
}
