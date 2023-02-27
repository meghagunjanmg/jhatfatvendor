var baseUrl = "https://jhatfat.com/api/";
var imageBaseUrl = "https://jhatfat.com/";


var termcondition = baseUrl + "termcondition";
var aboutus = baseUrl + "aboutus";
var support = baseUrl + "support";
var currency = baseUrl + "currency";
var storelogin = baseUrl + "storelogin";
var storeprofile_edit = baseUrl + "storeprofile_edit";
var store_addnewproduct = baseUrl + "store_addproductvariant";
var store_addcategory = baseUrl + "store_addcategory";
var store_editcategory = baseUrl + "store_editcategory";
var store_deletecategory = baseUrl + "store_deletecategory";
var store_addsubcategory = baseUrl + "store_addsubcategory";
var store_deletesubcategory = baseUrl + "store_deletesubcategory";
var store_editsubcategory = baseUrl + "store_editsubcategory";
var store_updatenewproduct = baseUrl + "store_updateproductvariant";
var storeverifyphone = baseUrl + "storeverifyphone";
var store_cancel_order = baseUrl + "store_cancel_order";
var store_approve_order = baseUrl + "store_approve_order";
var store_today_order = baseUrl + "store_today_order";
var store_next_day_order = baseUrl + "store_next_day_order";
var store_complete_order = baseUrl + "store_complete_order";
var store_delivery_boy = baseUrl + "store_delivery_boy";
var assigned_store_order = baseUrl + "assigned_store_order";
var store_category = baseUrl + "store_category";
var store_subcategory = baseUrl + "store_subcategory";
var store_subcategoryall = baseUrl + "store_subcategoryshow"; //vendor_id
var store_subcategoryproduct =
    baseUrl + "store_subcategoryproduct"; //vendeo_id,subcat_id
var store_addnewvariant = baseUrl + "store_addnewvariant"; //vendeo_id,subcat_id
var store_deleteproduct = baseUrl + "store_deleteproduct"; //vendeo_id,subcat_id
var store_deletevariant = baseUrl + "store_deletevariant"; //vendeo_id,subcat_id
var store_status = baseUrl + "store_status"; //vendeo_id,subcat_id
var store_current_status = baseUrl + "store_current_status"; //vendeo_id
var vendor_order_list = baseUrl + "vendor_order_list"; //vendeo_id
var send_request = baseUrl + "send_request"; //vendeo_id
var store_timming = baseUrl + "store_timming"; //vendeo_id
var store_order_details = baseUrl + "store_order_details"; //vendeo_id

//Restaurant Api
var vendor_today_order = baseUrl + "vendor_today_order";
var resturant_category = baseUrl + "resturant_category";
var resturant_product = baseUrl + "resturant_product";
var resturant_complete_order = baseUrl + "resturant_complete_order";
var resturant_deleteproduct = baseUrl + "resturant_deleteproduct";
var resturant_deletevariant = baseUrl + "resturant_deletevariant";
var resturant_updateproductvariant = baseUrl + "resturant_updateproductvariant";
var resturant_addnewvariant = baseUrl + "resturant_addnewvariant";
var resturant_updatevariant = baseUrl + "resturant_updatevariant";
var resturant_addaddons = baseUrl + "resturant_addaddons";
var resturant_deleteaddon = baseUrl + "resturant_deleteaddon";
var resturant_addaddons_update = baseUrl + "resturant_addaddons_update";
var resturant_addnewproduct = baseUrl + "resturant_addnewproduct";
var resturant_updatenewproduct = baseUrl + "resturant_updatenewproduct";
var rest_category = baseUrl + "rest_category";
var rest_deletecategory = baseUrl + "rest_deletecategory";
var rest_editcategory = baseUrl + "rest_editcategory";
var rest_addcategory = baseUrl + "rest_addcategory";
var vendor_order_details = baseUrl + "vendor_order_details";


//pharmacy Api
var pharmacy_today_order = baseUrl + "pharmacy_today_order";
var pharmacy_next_day_order = baseUrl + "pharmacy_next_day_order";
var pharmacy_complete_order = baseUrl + "pharmacy_complete_order";
var pharmacy_products = baseUrl + "pharmacy_products";
var pharmacy_product = baseUrl + "pharmacy_product";
var pharmacy_addnewproduct = baseUrl + "pharmacy_addnewproduct";
var pharmacy_updatenewproduct = baseUrl + "pharmacy_updatenewproduct";
var pharmacy_deleteproduct = baseUrl + "pharmacy_deleteproduct";
var pharmacy_category = baseUrl + "pharmacy_category";
var pharmacy_addnewvariant = baseUrl + "pharmacy_addnewvariant";
var pharmacy_updatevariant = baseUrl + "pharmacy_updatevariant";
var pharmacy_deletevariant = baseUrl + "pharmacy_deletevariant";
var pharmacy_addaddons = baseUrl + "pharmacy_addaddons";
var pharmacy_addaddons_update = baseUrl + "pharmacy_addaddons_update";
var pharmacy_deleteaddon = baseUrl + "pharmacy_deleteaddon";

//parcel Api
var parcel_city = baseUrl + "parcel_city";
var parcel_listcharges = baseUrl + "parcel_listcharges";
var parcel_updatecharges = baseUrl + "parcel_updatecharges";
var parcel_deletecharges = baseUrl + "parcel_deletecharges";
var parcel_addcharges = baseUrl + "parcel_addcharges";
var parcel_today_order = baseUrl + "parcel_today_order";
var parcel_next_day_order = baseUrl + "parcel_next_day_order";
var parcel_store_order = baseUrl + "parcel_store_order";
var parcel_complete_order = baseUrl + "parcel_complete_order";


var appname = 'Jhatfat Vendor';

dynamic APP_STORE_URL =
    '';
dynamic PLAY_STORE_URL =
    '';
