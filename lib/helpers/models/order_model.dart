class OrderModel {
  int? id, menuId, quantity;
  String? amount, itemName, status;

  OrderModel({this.id, this.menuId, this.quantity, this.amount, this.itemName, this.status});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      menuId: json['menuId'],
      quantity: json['quantity'],
      amount: json['amount'],
      itemName: json['itemName'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'menuId': menuId,
      'quantity': quantity,
      'amount': amount,
      'itemName': itemName,
      'status': status,
    };
  }
}
