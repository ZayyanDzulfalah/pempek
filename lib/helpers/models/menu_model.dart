class MenuModel {
  int? id;
  String? name, description, price, category;

  MenuModel({this.id, this.name, this.description, this.price, this.category});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
    };
  }
}
