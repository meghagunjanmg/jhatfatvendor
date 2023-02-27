class ProductBean {
  dynamic product_id;
  dynamic subcat_id;
  dynamic product_name;
  dynamic product_image;
  dynamic created_at;
  dynamic updated_at;
  dynamic vendor_id;
  dynamic category_id;
  dynamic subcat_name;
  dynamic subcat_image;
  dynamic cityadmin_id;
  dynamic category_name;
  dynamic category_image;
  dynamic home;
  int selectedItem;
  List<VarientList> varient_details;

  ProductBean(
      this.product_id,
      this.subcat_id,
      this.product_name,
      this.product_image,
      this.created_at,
      this.updated_at,
      this.vendor_id,
      this.category_id,
      this.subcat_name,
      this.subcat_image,
      this.cityadmin_id,
      this.category_name,
      this.category_image,
      this.home,
      this.selectedItem,
      this.varient_details);

  factory ProductBean.fromJson(dynamic json) {
    var dataList = json['varient_details'] as List;
    List<VarientList> varList =
        dataList.map((e) => VarientList.fromJson(e)).toList();
    return ProductBean(
        json['product_id'],
        json['subcat_id'],
        json['product_name'],
        json['product_image'],
        json['created_at'],
        json['updated_at'],
        json['vendor_id'],
        json['category_id'],
        json['subcat_name'],
        json['subcat_image'],
        json['cityadmin_id'],
        json['category_name'],
        json['category_image'],
        json['home'],
        0,
        varList);
  }

  @override
  String toString() {
    return 'ProductBean{product_id: $product_id, subcat_id: $subcat_id, product_name: $product_name, product_image: $product_image, created_at: $created_at, updated_at: $updated_at, vendor_id: $vendor_id, category_id: $category_id, subcat_name: $subcat_name, subcat_image: $subcat_image, cityadmin_id: $cityadmin_id, category_name: $category_name, category_image: $category_image, home: $home, selectedItem: $selectedItem, varient_details: $varient_details}';
  }
}

class VarientList {
  dynamic varient_id;
  dynamic product_id;
  dynamic quantity;
  dynamic unit;
  dynamic strick_price;
  dynamic price;
  dynamic description;
  dynamic varient_image;
  dynamic vendor_id;
  dynamic stock;

  VarientList(
      this.varient_id,
      this.product_id,
      this.quantity,
      this.unit,
      this.strick_price,
      this.price,
      this.description,
      this.varient_image,
      this.vendor_id,
      this.stock);

  factory VarientList.fromJson(dynamic json) {
    return VarientList(
        json['varient_id'],
        json['product_id'],
        json['quantity'],
        json['unit'],
        json['strick_price'],
        json['price'],
        json['description'],
        json['varient_image'],
        json['vendor_id'],
        json['stock']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VarientList &&
          runtimeType == other.runtimeType &&
          varient_id == other.varient_id;

  @override
  int get hashCode => varient_id.hashCode;

  @override
  String toString() {
    return 'VarientList{varient_id: $varient_id, product_id: $product_id, quantity: $quantity, unit: $unit, strick_price: $strick_price, price: $price, description: $description, varient_image: $varient_image, vendor_id: $vendor_id, stock: $stock}';
  }
}

class RestProductArray {
  dynamic product_id;
  dynamic product_name;
  dynamic cat_name;
  dynamic product_image;
  dynamic vendor_id;
  dynamic description;
  int selectedItem;
  List<RestProdVarient> varient_details;
  List<RestAddOn> addons;

  RestProductArray(
      this.product_id,
      this.product_name,
      this.cat_name,
      this.product_image,
      this.vendor_id,
      this.description,
      this.selectedItem,
      this.varient_details,
      this.addons);

  factory RestProductArray.fromJson(dynamic json) {
    var jsData = json['varient_details'] as List;
    List<RestProdVarient> orderDetails = [];
    if (jsData != null) {
      orderDetails = jsData.map((e) => RestProdVarient.fromJson(e)).toList();
    }

    var jaddons = json['addons'] as List;
    List<RestAddOn> addonList = [];
    if (jaddons != null && jaddons.toString().length > 2) {
      addonList = jaddons.map((e) => RestAddOn.fromJson(e)).toList();
    }

    return RestProductArray(
        json['product_id'],
        json['product_name'],
        json['cat_name'],
        json['product_image'],
        json['vendor_id'],
        json['description'],
        0,
        orderDetails,
        addonList);
  }

  @override
  String toString() {
    return '{product_id: $product_id, product_name: $product_name, cat_name: $cat_name, product_image: $product_image, vendor_id: $vendor_id, varient_details: $varient_details, addons: $addons}';
  }
}

class RestProdVarient {
  dynamic variant_id;
  dynamic product_id;
  dynamic quantity;
  dynamic unit;
  dynamic strick_price;
  dynamic price;
  dynamic vendor_id;

  RestProdVarient(this.variant_id, this.product_id, this.quantity, this.unit,
      this.strick_price, this.price, this.vendor_id);

  factory RestProdVarient.fromJson(dynamic json) {
    return RestProdVarient(
        json['variant_id'],
        json['product_id'],
        json['quantity'],
        json['unit'],
        json['strick_price'],
        json['price'],
        json['vendor_id']);
  }

  @override
  String toString() {
    return '{variant_id: $variant_id, product_id: $product_id, quantity: $quantity, unit: $unit, strick_price: $strick_price, price: $price, vendor_id: $vendor_id}';
  }
}

class RestAddOn {
  dynamic addon_id;
  dynamic addon_name;
  dynamic addon_price;
  dynamic product_id;
  dynamic vendor_id;

  RestAddOn(this.addon_id, this.addon_name, this.addon_price, this.product_id,
      this.vendor_id);

  factory RestAddOn.fromJson(dynamic json) {
    return RestAddOn(json['addon_id'], json['addon_name'], json['addon_price'],
        json['product_id'], json['vendor_id']);
  }

  @override
  String toString() {
    return '{addon_id: $addon_id, addon_name: $addon_name, addon_price: $addon_price, product_id: $product_id, vendor_id: $vendor_id}';
  }
}
