class VendorOrderList {
  dynamic com_id;
  dynamic vendor_id;
  dynamic vendor_name;
  dynamic order_date;
  dynamic total_price;
  dynamic comission_price;
  dynamic status;
  dynamic cart_id;
  dynamic user_name;
  dynamic payment_method;

  VendorOrderList(
      this.com_id,
      this.vendor_id,
      this.vendor_name,
      this.order_date,
      this.total_price,
      this.comission_price,
      this.status,
      this.cart_id,
      this.user_name,
      this.payment_method);

  factory VendorOrderList.fromJson(dynamic json) {
    return VendorOrderList(
        json['com_id'],
        json['vendor_id'],
        json['vendor_name'],
        json['order_date'],
        json['total_price'],
        json['comission_price'],
        json['status'],
        json['cart_id'],
        json['user_name'],
        json['payment_method']);
  }

  @override
  String toString() {
    return '{com_id: $com_id, vendor_id: $vendor_id, vendor_name: $vendor_name, order_date: $order_date, total_price: $total_price, comission_price: $comission_price, status: $status, cart_id: $cart_id, user_name: $user_name, payment_method: $payment_method}';
  }
}
