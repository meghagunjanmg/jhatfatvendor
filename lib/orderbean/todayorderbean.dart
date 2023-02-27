
import 'dart:convert';

TodayOrderDetails todayOrderDetailsFromJson(String str) => TodayOrderDetails.fromJson(json.decode(str));

String todayOrderDetailsToJson(TodayOrderDetails data) => json.encode(data.toJson());

class TodayOrderDetails {
  TodayOrderDetails({
    this.pres,
    this.idProof,
    this.orderId,
    this.userId,
    this.deliveryDate,
    this.userName,
    this.dboyId,
    this.deliveryCharge,
    this.totalPrice,
    this.totalProductMrp,
    this.deliveryBoyName,
    this.orderStatus,
    this.cartId,
    this.userNumber,
    this.address,
    this.timeSlot,
    this.paidByWallet,
    this.remainingPrice,
    this.priceWithoutDelivery,
    this.couponDiscount,
    this.paymentMethod,
    this.paymentStatus,
    this.deliveryBoyNum,
    this.orderDetails,
    this.basketProducts,
    this.total_items,

    this.surgecharge,
    this.nightcharge,
    this.convcharge,
    this.gst,

  });

  dynamic pres;
  dynamic idProof;
  dynamic orderId;
  dynamic userId;
  dynamic deliveryDate;
  dynamic userName;
  dynamic dboyId;
  dynamic deliveryCharge;
  dynamic totalPrice;
  dynamic totalProductMrp;
  dynamic deliveryBoyName;
  dynamic orderStatus;
  dynamic cartId;
  dynamic userNumber;
  dynamic address;
  dynamic timeSlot;
  dynamic paidByWallet;
  dynamic remainingPrice;
  dynamic priceWithoutDelivery;
  dynamic couponDiscount;
  dynamic paymentMethod;
  dynamic paymentStatus;
  dynamic deliveryBoyNum;
  List<OrderDetail> orderDetails;
  List<BasketProduct> basketProducts;
  dynamic total_items;
  dynamic surgecharge;
  dynamic nightcharge;
  dynamic convcharge;
  dynamic gst;


  factory TodayOrderDetails.fromJson(Map<String, dynamic> json) => TodayOrderDetails(
    pres: json["pres"],
    idProof: json["id_proof"],
    orderId: json["order_id"],
    userId: json["user_id"],
    deliveryDate: json["delivery_date"],
    userName: json["user_name"],
    dboyId: json["dboy_id"],
    deliveryCharge: json["delivery_charge"],
    totalPrice: json["total_price"],
    totalProductMrp: json["total_product_mrp"],
    deliveryBoyName: json["delivery_boy_name"],
    orderStatus: json["order_status"],
    cartId: json["cart_id"],
    userNumber: json["user_number"],
    address: json["address"],
    timeSlot: json["time_slot"],
    paidByWallet: json["paid_by_wallet"],
    remainingPrice: json["remaining_price"],
    priceWithoutDelivery: json["price_without_delivery"],
    couponDiscount: json["coupon_discount"],
    paymentMethod: json["payment_method"],
    paymentStatus: json["payment_status"],
    deliveryBoyNum: json["delivery_boy_num"],
    orderDetails: List<OrderDetail>.from(json["order_details"].map((x) => OrderDetail.fromJson(x))),
    basketProducts: List<BasketProduct>.from(json["basket_products"].map((x) => BasketProduct.fromJson(x))),
    total_items: json["total_items"],
      surgecharge: json["surgecharge"],
      nightcharge: json["nightcharge"],
      convcharge: json["convcharge"],
      gst: json["gst"],
  );

  Map<String, dynamic> toJson() => {
    "pres": pres,
    "id_proof": idProof,
    "order_id": orderId,
    "user_id": userId,
    "delivery_date":deliveryDate,
    "user_name": userName,
    "dboy_id": dboyId,
    "delivery_charge": deliveryCharge,
    "total_price": totalPrice,
    "total_product_mrp": totalProductMrp,
    "delivery_boy_name": deliveryBoyName,
    "order_status": orderStatus,
    "cart_id": cartId,
    "user_number": userNumber,
    "address": address,
    "time_slot": timeSlot,
    "paid_by_wallet": paidByWallet,
    "remaining_price": remainingPrice,
    "price_without_delivery": priceWithoutDelivery,
    "coupon_discount": couponDiscount,
    "payment_method": paymentMethod,
    "payment_status": paymentStatus,
    "delivery_boy_num": deliveryBoyNum,
    "order_details": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
    "basket_products": List<dynamic>.from(basketProducts.map((x) => x.toJson())),
    "total_items": total_items,
    "surgecharge": surgecharge,
    "nightcharge": nightcharge,
    "convcharge": convcharge,
    "gst": gst,
  };
}

class BasketProduct {
  BasketProduct({
    this.productName,
    this.price,
    this.unit,
    this.quantity,
    this.varientImage,
    this.description,
    this.varientId,
    this.storeOrderId,
    this.qty,
    this.totalItems,
    this.addToBasket,
  });

  dynamic productName;
  dynamic price;
  dynamic unit;
  dynamic quantity;
  dynamic varientImage;
  dynamic description;
  dynamic varientId;
  dynamic storeOrderId;
  dynamic qty;
  dynamic totalItems;
  dynamic addToBasket;

  factory BasketProduct.fromJson(Map<String, dynamic> json) => BasketProduct(
    productName: json["product_name"],
    price: json["price"],
    unit: json["unit"],
    quantity: json["quantity"],
    varientImage: json["varient_image"],
    description: json["description"],
    varientId: json["varient_id"],
    storeOrderId: json["store_order_id"],
    qty: json["qty"],
    totalItems: json["total_items"],
    addToBasket: json["add_to_basket"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "price": price,
    "unit": unit,
    "quantity": quantity,
    "varient_image": varientImage,
    "description": description,
    "varient_id": varientId,
    "store_order_id": storeOrderId,
    "qty": qty,
    "total_items": totalItems,
    "add_to_basket": addToBasket,
  };
}

class OrderDetail {
  OrderDetail({
    this.vendorId,
    this.vendorName,
    this.vendordetails,
    this.store_status,
    this.instruction,
  });

  dynamic vendorId;
  dynamic vendorName;
  dynamic store_status;
  List<BasketProduct> vendordetails;
  dynamic instruction;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    vendorId: json["vendor_id"],
    vendorName: json["vendor_name"],
    store_status: json["store_status"],
    vendordetails: List<BasketProduct>.from(json["vendordetails"].map((x) => BasketProduct.fromJson(x))),
      instruction: json['instruction'],
  );

  Map<String, dynamic> toJson() => {
    "vendor_id": vendorId,
    "vendor_name": vendorName,
    "store_status": store_status,
    "vendordetails": List<dynamic>.from(vendordetails.map((x) => x.toJson())),
    "instruction": instruction,
  };
}
