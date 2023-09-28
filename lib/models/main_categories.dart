class MainCategories {
  int? id;
  String? name;
  String? image;
  int? typeId;
  int? count;
  bool? empty;

  MainCategories(
      {this.id, this.name, this.image, this.typeId, this.count, this.empty});

  MainCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    typeId = json['typeId'];
    count = json['count'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['typeId'] = typeId;
    data['count'] = count;
    data['empty'] = empty;
    return data;
  }
}
