import 'package:flutter/material.dart';
import 'package:glover/constants/app_colors.dart';
import 'package:glover/constants/app_strings.dart';
import 'package:glover/extensions/string.dart';
import 'package:glover/models/vehicle_type.dart';
import 'package:glover/utils/ui_spacer.dart';
import 'package:glover/view_models/taxi.vm.dart';
import 'package:glover/widgets/currency_hstack.dart';
import 'package:glover/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class VehicleTypeListItem extends StatelessWidget {
  const VehicleTypeListItem(
    this.vm,
    this.vehicleType, {
    Key? key,
  }) : super(key: key);
  final VehicleType vehicleType;
  final TaxiViewModel vm;
  @override
  Widget build(BuildContext context) {
    //
    final selected = vm.selectedVehicleType?.id == vehicleType.id;

    //
    return HStack(
      [
        //
        CustomImage(
          imageUrl: vehicleType.photo,
          width: 50,
          height: 70,
          boxFit: BoxFit.contain,
        ),
        UiSpacer.horizontalSpace(space: 10),
        VStack(
          [
            "${vehicleType.name}"
                .text
                .fontWeight(selected ? FontWeight.w600 : FontWeight.w400)
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make(),
            CurrencyHStack([
              "${vehicleType.currency != null ? vehicleType.currency?.symbol : AppStrings.currencySymbol}"
                  .text
                  .fontWeight(selected ? FontWeight.w600 : FontWeight.w400)
                  .make(),
              "${vehicleType.total}"
                  .currencyValueFormat()
                  .text
                  .fontWeight(selected ? FontWeight.w600 : FontWeight.w400)
                  .make(),
            ]),
          ],
        ),
      ],
      alignment: MainAxisAlignment.center,
      // crossAlignment: CrossAxisAlignment.center,
    )
        .box
        .p8
        // .px12
        .color(selected
            ? AppColor.primaryColor.withOpacity(0.15)
            : AppColor.primaryColor.withOpacity(0.01))
        .roundedSM
        .make()
        .onTap(
          () => vm.changeSelectedVehicleType(vehicleType),
        );
  }
}
