import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:glover/constants/app_routes.dart';
import 'package:glover/models/delivery_address.dart';
import 'package:glover/requests/delivery_address.request.dart';
import 'package:glover/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DeliveryAddressesViewModel extends MyBaseViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  List<DeliveryAddress> deliveryAddresses = [];

  //
  DeliveryAddressesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    fetchDeliveryAddresses();
  }

  //
  fetchDeliveryAddresses() async {
    //
    setBusyForObject(deliveryAddresses, true);
    try {
      deliveryAddresses = await deliveryAddressRequest.getDeliveryAddresses();
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(deliveryAddresses, false);
  }

  //
  newDeliveryAddressPressed() async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.newDeliveryAddressesRoute,
    );
    fetchDeliveryAddresses();
  }

  //
  editDeliveryAddress(DeliveryAddress deliveryAddress) async {
    await Navigator.of(viewContext).pushNamed(
      AppRoutes.editDeliveryAddressesRoute,
      arguments: deliveryAddress,
    );
    fetchDeliveryAddresses();
  }

  //
  deleteDeliveryAddress(DeliveryAddress deliveryAddress) {
    //
    CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.confirm,
        title: "Delete Delivery Address".tr(),
        text: "Are you sure you want to delete this delivery address?".tr(),
        confirmBtnText: "Delete".tr(),
        onConfirmBtnTap: () {
          viewContext.pop();
          processDeliveryAddressDeletion(deliveryAddress);
        });
  }

  //
  processDeliveryAddressDeletion(DeliveryAddress deliveryAddress) async {
    setBusy(true);
    //
    final apiResponse = await deliveryAddressRequest.deleteDeliveryAddress(
      deliveryAddress,
    );

    //remove from list
    if (apiResponse.allGood) {
      deliveryAddresses.remove(deliveryAddress);
    }

    setBusy(false);

    CoolAlert.show(
      context: viewContext,
      type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
      title: "Delete Delivery Address".tr(),
      text: apiResponse.message,
    );
  }
}
