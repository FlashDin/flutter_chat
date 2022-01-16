
class ResponseList {

  List<dynamic> content;
  Object pageable;
  int totalPages;
  int totalElements;
  bool last;
  int size;
  int number;
  Object sort;
  bool first;
  int numberOfElements;
  bool empty;

  ResponseList(
      this.content,
      this.pageable,
      this.totalPages,
      this.totalElements,
      this.last,
      this.size,
      this.number,
      this.sort,
      this.first,
      this.numberOfElements,
      this.empty);

  factory ResponseList.fromJson(dynamic map) {
    return ResponseList(
        map["content"],
        map["pageable"],
        map["totalPages"],
        map["totalElements"],
        map["last"],
        map["size"],
        map["number"],
        map["sort"],
        map["first"],
        map["numberOfElements"],
        map["empty"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "pageable": pageable,
      "totalPages": totalPages,
      "totalElements": totalElements,
      "last": last,
      "size": size,
      "number": number,
      "sort": sort,
      "first": first,
      "numberOfElements": numberOfElements,
      "empty": empty
    };
  }

}
