class ResponseModel<T> {
  final dynamic links;
  final dynamic warning;
  final T? payload;
  final dynamic attributes;
  final dynamic errors;
  final dynamic generated;

  ResponseModel({
    this.links,
    this.warning,
    this.payload,
    this.attributes,
    this.errors,
    this.generated,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? payloadParser,
  }) {
    return ResponseModel<T>(
      links: json['_links'],
      warning: json['_warning'],
      payload: payloadParser != null && json['payload'] != null ? payloadParser(json['payload']) : json['payload'],
      attributes: json['_attributes'],
      errors: json['_errors'],
      generated: json['_generated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_links': links,
      '_warning': warning,
      'payload': payload,
      '_attributes': attributes,
      '_errors': errors,
      '_generated': generated,
    };
  }
}