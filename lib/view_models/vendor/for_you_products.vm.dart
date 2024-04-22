import 'package:flutter/material.dart';
import 'package:glover/constants/app_routes.dart';
import 'package:glover/models/product.dart';
import 'package:glover/models/vendor_type.dart';
import 'package:glover/requests/product.request.dart';
import 'package:glover/view_models/base.view_model.dart';

class ForYouProductsViewModel extends MyBaseViewModel {
  //
  ProductRequest _productRequest = ProductRequest();
  //
  List<Product> products = [];
  VendorType? vendorType;

  ForYouProductsViewModel(BuildContext context, this.vendorType) {
    this.viewContext = context;
  }

  //
  initialise() async {
    setBusy(true);
    try {
      products = await _productRequest.forYouProductsRequest(
        queryParams: {
          "vendor_type_id": vendorType?.id,
        },
      );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  productSelected(Product product) async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.product,
      arguments: product,
    );
  }
}
