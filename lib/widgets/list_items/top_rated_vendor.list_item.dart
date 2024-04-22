import 'package:flutter/material.dart';
import 'package:glover/constants/app_colors.dart';
import 'package:glover/models/vendor.dart';
import 'package:glover/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class TopRatedVendorListItem extends StatelessWidget {
  const TopRatedVendorListItem({
    required this.vendor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Vendor vendor;
  final Function(Vendor) onPressed;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Hero(
          tag: vendor.heroTag ?? vendor.id,
          child: CustomImage(
            imageUrl: vendor.logo,
            height: 60,
            width: 60,
          ).box.roundedSM.clip(Clip.antiAlias).make(),
        ).centered(),

        //
        VStack(
          [
            //name
            vendor.name.text.lg.center.medium
                .maxLines(1)
                .overflow(TextOverflow.ellipsis)
                .make(),
            //rating
            VxRating(
              maxRating: 5.0,
              value: double.parse(vendor.rating.toString()),
              isSelectable: false,
              onRatingUpdate: (value) {},
              selectionColor: AppColor.ratingColor,
              size: 14,
            ).centered(),
          ],
        ).p4().centered(),
      ],
    )
        .centered()
        .onInkTap(
          () => this.onPressed(this.vendor),
        )
        .wOneThird(context)
        .card
        .make()
        .box
        .outerShadow
        .shadowOutline(outlineColor: AppColor.primaryColor)
        .roundedSM
        .make();
  }
}
