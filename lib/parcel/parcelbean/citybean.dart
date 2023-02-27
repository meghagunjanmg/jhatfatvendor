class City {
  dynamic city_id;
  dynamic city_name;
  dynamic city_image;
  dynamic lat;
  dynamic lng;
  dynamic vendor_id;
  dynamic created_at;
  dynamic updated_at;

  City(this.city_id, this.city_name, this.city_image, this.lat, this.lng,
      this.vendor_id, this.created_at, this.updated_at);

  factory City.fromJson(dynamic json) {
    return City(
        json['city_id'],
        json['city_name'],
        json['city_image'],
        json['lat'],
        json['lng'],
        json['vendor_id'],
        json['created_at'],
        json['updated_at']);
  }

  @override
  String toString() {
    return '{city_id: $city_id, city_name: $city_name, city_image: $city_image, lat: $lat, lng: $lng, vendor_id: $vendor_id, created_at: $created_at, updated_at: $updated_at}';
  }
}
