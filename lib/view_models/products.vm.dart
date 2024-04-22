import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:glover/constants/app_strings.dart';
import 'package:glover/enums/product_fetch_data_type.enum.dart';
import 'package:glover/models/product.dart';
import 'package:glover/models/user.dart';
import 'package:glover/models/vendor_type.dart';
import 'package:glover/requests/product.request.dart';
import 'package:glover/services/auth.service.dart';
import 'package:glover/services/location.service.dart';
import 'package:glover/view_models/base.view_model.dart';

class ProductsViewModel extends MyBaseViewModel {
  //
  ProductsViewModel(
    BuildContext context,
    this.vendorType,
    this.type, {
    this.categoryId,
    this.byLocation,
  }) {
    this.viewContext = context;
    if (this.byLocation == null) {
      this.byLocation = AppStrings.enableFatchByLocation;
    }
  }

  //
  User? currentUser;

  //
  VendorType? vendorType;
  int? categoryId;
  ProductFetchDataType type;
  ProductRequest productRequest = ProductRequest();
  List<Product> products = [];
  late bool? byLocation;

  bool get anyProductWithOptions {
    try {
      return products.firstOrNullWhere(
            (e) =>
                e.optionGroups.isNotEmpty &&
                e.optionGroups.first.options.isNotEmpty,
          ) !=
          null;
    } catch (error) {
      return false;
    }
  }

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    deliveryaddress?.address = LocationService.currenctAddress?.addressLine;
    deliveryaddress?.latitude =
        LocationService.currenctAddress?.coordinates?.latitude;
    deliveryaddress?.longitude =
        LocationService.currenctAddress?.coordinates?.longitude;

    //get today picks
    fetchProducts();
  }

  //
  fetchProducts() async {
    //
    setBusy(true);
    try {
      Map<String, dynamic> queryParams = {
        "category_id": categoryId,
        "vendor_type_id": vendorType?.id,
        "type": type.name.toLowerCase(),
      };

      if ((byLocation != null && byLocation!) &&
          deliveryaddress?.latitude != null) {
        queryParams.addAll({
          "latitude": deliveryaddress?.latitude,
          "longitude": deliveryaddress?.longitude,
        });
      }

      products = await productRequest.getProdcuts(
        queryParams: queryParams,
      );
    } catch (error) {
      print("fetchProducts Error ==> $error");
    }
    setBusy(false);
  }
}
