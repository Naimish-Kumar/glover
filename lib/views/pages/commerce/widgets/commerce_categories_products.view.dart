import 'package:flutter/material.dart';
import 'package:glover/models/vendor_type.dart';
import 'package:glover/view_models/vendor/categories.vm.dart';
import 'package:glover/views/pages/commerce/widgets/products_section.view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceCategoryProducts extends StatelessWidget {
  const CommerceCategoryProducts(
    this.vendorType, {
    this.length = 2,
    Key? key,
  }) : super(key: key);

  final VendorType vendorType;
  final int length;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      viewModelBuilder: () =>
          CategoriesViewModel(context, vendorType: vendorType),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return VStack(
          [
            //
            ...(model.categories
                .sublist(
                    0,
                    model.categories.length < length
                        ? model.categories.length
                        : length)
                .map(
              (category) {
                //
                return ProductsSectionView(
                  category.name,
                  vendorType: model.vendorType,
                  category: category,
                  showGrid: false,
                );
              },
            ).toList()),
          ],
        );
      },
    );
  }
}
