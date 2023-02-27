class VendorProfile {
  dynamic vendor_id;
  dynamic vendor_name;
  dynamic owner;
  dynamic cityadmin_id;
  dynamic vendor_email;
  dynamic vendor_phone;
  dynamic vendor_logo;
  dynamic vendor_loc;
  dynamic lat;
  dynamic lng;
  dynamic opening_time;
  dynamic closing_time;
  dynamic vendor_pass;
  dynamic created_at;
  dynamic updated_at;
  dynamic vendor_category_id;
  dynamic comission;
  dynamic delivery_range;
  dynamic device_id;
  dynamic otp;
  dynamic phone_verified;
  dynamic ui_type;

  VendorProfile(
      this.vendor_id,
      this.vendor_name,
      this.owner,
      this.cityadmin_id,
      this.vendor_email,
      this.vendor_phone,
      this.vendor_logo,
      this.vendor_loc,
      this.lat,
      this.lng,
      this.opening_time,
      this.closing_time,
      this.vendor_pass,
      this.created_at,
      this.updated_at,
      this.vendor_category_id,
      this.comission,
      this.delivery_range,
      this.device_id,
      this.otp,
      this.phone_verified,
      this.ui_type);

  factory VendorProfile.fromJson(dynamic json) {
    return VendorProfile(
        json['vendor_id'],
        json['vendor_name'],
        json['owner'],
        json['cityadmin_id'],
        json['vendor_email'],
        json['vendor_phone'],
        json['vendor_logo'],
        json['vendor_loc'],
        json['lat'],
        json['lng'],
        json['opening_time'],
        json['closing_time'],
        json['vendor_pass'],
        json['created_at'],
        json['updated_at'],
        json['vendor_category_id'],
        json['comission'],
        json['delivery_range'],
        json['device_id'],
        json['otp'],
        json['phone_verified'],
        json['ui_type']);
  }

  @override
  String toString() {
    return '{vendor_id: $vendor_id, vendor_name: $vendor_name, owner: $owner, cityadmin_id: $cityadmin_id, vendor_email: $vendor_email, vendor_phone: $vendor_phone, vendor_logo: $vendor_logo, vendor_loc: $vendor_loc, lat: $lat, lng: $lng, opening_time: $opening_time, closing_time: $closing_time, vendor_pass: $vendor_pass, created_at: $created_at, updated_at: $updated_at, vendor_category_id: $vendor_category_id, comission: $comission, delivery_range: $delivery_range, device_id: $device_id, otp: $otp, phone_verified: $phone_verified, ui_type: $ui_type}';
  }
}

class CurrencyData {
  dynamic currency_id;
  dynamic currency;
  dynamic currency_sign;

  CurrencyData(this.currency_id, this.currency, this.currency_sign);

  factory CurrencyData.fromJson(dynamic json) {
    return CurrencyData(
        json['currency_id'], json['currency'], json['currency_sign']);
  }

  @override
  String toString() {
    return '{currency_id: $currency_id, currency: $currency, currency_sign: $currency_sign}';
  }
}
