
class TodayOrderRestaurant{

  dynamic area_id;
  dynamic order_id;
  dynamic user_id;
  dynamic delivery_date;
  dynamic user_name;
  dynamic dboy_id;
  dynamic delivery_charge;
  dynamic total_price;
  dynamic total_product_mrp;
  dynamic delivery_boy_name;
  dynamic order_status;
  dynamic cart_id;
  dynamic user_number;
  dynamic address;
  dynamic time_slot;
  dynamic paid_by_wallet;
  dynamic remaining_price;
  dynamic price_without_delivery;
  dynamic coupon_discount;
  dynamic vendor_name;
  dynamic payment_method;
  dynamic payment_status;
  dynamic delivery_boy_num;
  dynamic store_status;

  List<TodayRestaurantOrderDetails> order_details;
  List<AddonList> addons;
  dynamic surgecharge;
  dynamic nightcharge;
  dynamic convcharge;
  dynamic packaging_charge;
  dynamic gst;

  TodayOrderRestaurant(
      this.area_id,
      this.order_id,
      this.user_id,
      this.delivery_date,
      this.user_name,
      this.dboy_id,
      this.delivery_charge,
      this.total_price,
      this.total_product_mrp,
      this.delivery_boy_name,
      this.order_status,
      this.cart_id,
      this.user_number,
      this.address,
      this.time_slot,
      this.paid_by_wallet,
      this.remaining_price,
      this.price_without_delivery,
      this.coupon_discount,
      this.vendor_name,
      this.payment_method,
      this.payment_status,
      this.delivery_boy_num,
      this.store_status,
      this.order_details,
      this.addons,

      this.surgecharge,
      this.nightcharge,
      this.convcharge,
      this.packaging_charge,
      this.gst,
      );

  factory TodayOrderRestaurant.fromJson(dynamic json){

    var jsData = json['order_details'] as List;
    List<TodayRestaurantOrderDetails> orderDetails = [];
    if(jsData!=null){
      orderDetails = jsData.map((e) => TodayRestaurantOrderDetails.fromJson(e)).toList();
    }

    var jaddons = json['addons'] as List;
    List<AddonList> addonList = [];
    if(jaddons!=null){
      addonList = jaddons.map((e) => AddonList.fromJson(e)).toList();
    }

    return TodayOrderRestaurant(json['area_id'], json['order_id'], json['user_id'], json['delivery_date'], json['user_name'], json['dboy_id'], json['delivery_charge'], json['total_price'], json['total_product_mrp'], json['delivery_boy_name'], json['order_status'], json['cart_id'], json['user_number'], json['address'], json['time_slot'], json['paid_by_wallet'], json['remaining_price'], json['price_without_delivery'], json['coupon_discount'], json['vendor_name'], json['payment_method'], json['payment_status'], json['delivery_boy_num'],  json['store_status'],orderDetails, addonList, json["surgecharge"],json["nightcharge"],json["convcharge"],json['packaging_charge'],json['gst']);
  }

  @override
  String toString() {
    return '{area_id: $area_id, order_id: $order_id, user_id: $user_id, delivery_date: $delivery_date, user_name: $user_name, dboy_id: $dboy_id, delivery_charge: $delivery_charge, total_price: $total_price, total_product_mrp: $total_product_mrp, delivery_boy_name: $delivery_boy_name, order_status: $order_status, cart_id: $cart_id, user_number: $user_number, address: $address, time_slot: $time_slot, paid_by_wallet: $paid_by_wallet, remaining_price: $remaining_price, price_without_delivery: $price_without_delivery, coupon_discount: $coupon_discount, vendor_name: $vendor_name, payment_method: $payment_method, payment_status: $payment_status, delivery_boy_num: $delivery_boy_num, store_status:$store_status ,order_details: $order_details, addons: $addons ,surgecharge:$surgecharge , nightcharge:$nightcharge , convcharge:$convcharge , packaging_charge : $packaging_charge,gst:$gst}';
  }
}



class TodayRestaurantOrderDetails{

  dynamic product_name;
  dynamic price;
  dynamic unit;
  dynamic quantity;
  dynamic product_image;
  dynamic description;
  // dynamic addon_price;
  // dynamic addon_name;
  dynamic varient_id;
  dynamic store_order_id;
  dynamic qty;
  // dynamic total_items;

  TodayRestaurantOrderDetails(
      this.product_name,
      this.price,
      this.unit,
      this.quantity,
      this.product_image,
      this.description,
      this.varient_id,
      this.store_order_id,
      this.qty);

  factory TodayRestaurantOrderDetails.fromJson(dynamic json){
    return TodayRestaurantOrderDetails(json['product_name'], json['price'], json['unit'], json['quantity'], json['product_image'], json['description'], json['varient_id'], json['store_order_id'], json['qty']);
  }

  @override
  String toString() {
    return '{product_name: $product_name, price: $price, unit: $unit, quantity: $quantity, product_image: $product_image, description: $description, varient_id: $varient_id, store_order_id: $store_order_id, qty: $qty}';
  }
}

class AddonList{

  dynamic addon_id;
  dynamic addon_price;
  dynamic addon_name;
  dynamic product_name;

  AddonList(this.addon_id, this.addon_price,this.addon_name,this.product_name);

  factory AddonList.fromJson(dynamic json){
    return AddonList(json['addon_id'], json['addon_price'], json['addon_name'], json['product_name']);
  }

  @override
  String toString() {
    return '{addon_id: $addon_id, addon_price: $addon_price, addon_name: $addon_name, product_name: $product_name}';
  }
}