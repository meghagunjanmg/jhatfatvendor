class SubcategoryList {
  dynamic subcatId;
  dynamic subcatName;
  dynamic subcatImage;
  dynamic istabacco;
  dynamic ispres;
  dynamic isid;
  dynamic isbasket;
  dynamic category_id;

  SubcategoryList(
      {this.subcatId,
        this.subcatName,
        this.subcatImage,
        this.istabacco,
        this.ispres,
        this.isid,
        this.isbasket,
        this.category_id,

      });

  SubcategoryList.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'];
    subcatName = json['subcat_name'];
    subcatImage = json['subcat_image'];
    istabacco = json['istabacco'];
    ispres = json['ispres'];
    isid = json['isid'];
    isbasket = json['isbasket'];
    category_id = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['subcat_name'] = this.subcatName;
    data['subcat_image'] = this.subcatImage;
    data['istabacco'] = this.istabacco;
    data['ispres'] = this.ispres;
    data['isid'] = this.isid;
    data['isbasket'] = this.isbasket;
    data['category_id'] = this.category_id;
    return data;
  }
}


class CategoryRestList {
  dynamic resturant_cat_id;
  dynamic cat_name;
  dynamic cat_image;
  dynamic vendor_id;

  CategoryRestList(
      this.resturant_cat_id, this.cat_name, this.cat_image, this.vendor_id);

  factory CategoryRestList.fromJson(dynamic json) {
    return CategoryRestList(json['resturant_cat_id'], json['cat_name'],
        json['cat_image'], json['vendor_id']);
  }

  @override
  String toString() {
    return 'SubcategoryList{subcat_id: $resturant_cat_id, subcat_name: $cat_name, subcat_image: $cat_image, vendor_id: $vendor_id}';
  }
}
