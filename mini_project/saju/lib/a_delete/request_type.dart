enum RequestType { normal, hash }

extension RequestTypeQuery on RequestType {
  String get query => name; // "normal" | "hash"
}
