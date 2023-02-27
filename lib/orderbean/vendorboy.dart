class DeliveryBoyList {
  dynamic delivery_boy_id;
  dynamic vendor_id;
  dynamic delivery_boy_name;
  dynamic delivery_boy_image;
  dynamic delivery_boy_phone;
  dynamic delivery_boy_pass;
  dynamic lat;
  dynamic lng;
  dynamic device_id;
  dynamic created_at;
  dynamic updated_at;
  dynamic delivery_boy_status;
  dynamic is_confirmed;
  dynamic otp;
  dynamic phone_verify;
  dynamic cityadmin_id;

  DeliveryBoyList(
      this.delivery_boy_id,
      this.vendor_id,
      this.delivery_boy_name,
      this.delivery_boy_image,
      this.delivery_boy_phone,
      this.delivery_boy_pass,
      this.lat,
      this.lng,
      this.device_id,
      this.created_at,
      this.updated_at,
      this.delivery_boy_status,
      this.is_confirmed,
      this.otp,
      this.phone_verify,
      this.cityadmin_id);

  factory DeliveryBoyList.fromJson(dynamic json) {
    return DeliveryBoyList(
        json['delivery_boy_id'],
        json['vendor_id'],
        json['delivery_boy_name'],
        json['delivery_boy_image'],
        json['delivery_boy_phone'],
        json['delivery_boy_pass'],
        json['lat'],
        json['lng'],
        json['device_id'],
        json['created_at'],
        json['updated_at'],
        json['delivery_boy_status'],
        json['is_confirmed'],
        json['otp'],
        json['phone_verify'],
        json['cityadmin_id']);
  }

  @override
  String toString() {
    return 'DeliveryBoyList{delivery_boy_id: $delivery_boy_id, vendor_id: $vendor_id, delivery_boy_name: $delivery_boy_name, delivery_boy_image: $delivery_boy_image, delivery_boy_phone: $delivery_boy_phone, delivery_boy_pass: $delivery_boy_pass, lat: $lat, lng: $lng, device_id: $device_id, created_at: $created_at, updated_at: $updated_at, delivery_boy_status: $delivery_boy_status, is_confirmed: $is_confirmed, otp: $otp, phone_verify: $phone_verify, cityadmin_id: $cityadmin_id}';
  }
}
