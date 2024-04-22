import 'package:flutter/material.dart';
import 'package:glover/constants/app_routes.dart';
import 'package:glover/models/search.dart';
import 'package:glover/models/vendor.dart';
import 'package:glover/models/vendor_type.dart';
import 'package:glover/requests/vendor.request.dart';
import 'package:glover/view_models/base.view_model.dart';

class SectionVendorsViewModel extends MyBaseViewModel {
  SectionVendorsViewModel(
    BuildContext context,
    this.vendorType, {
    this.type = SearchFilterType.you,
    this.byLocation = false,
  }) {
    this.viewContext = context;
  }

  //
  List<Vendor> vendors = [];
  VendorType? vendorType;
  SearchFilterType type;
  bool? byLocation;
  VendorRequest _vendorRequest = VendorRequest();

  //
  initialise() {
    fetchVendors();
  }

  //
  fetchVendors() async {
    setBusy(true);
    try {
      //filter by location if user selects delivery address
      vendors = await _vendorRequest.vendorsRequest(
        byLocation: byLocation ?? true,
        params: {
          "vendor_type_id": vendorType?.id,
          "type": type.name,
        },
      );

      clearErrors();
    } catch (error) {
      print("error loading vendors ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  vendorSelected(Vendor vendor) async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: vendor,
    );
  }
}
