import 'package:flutter/material.dart';
import 'package:glover/extensions/string.dart';
import 'package:glover/utils/ui_spacer.dart';
import 'package:glover/view_models/cart.vm.dart';
import 'package:glover/views/pages/cart/widgets/amount_tile.dart';
import 'package:glover/views/pages/cart/widgets/apply_coupon.dart';
import 'package:glover/widgets/base.page.dart';
import 'package:glover/widgets/buttons/custom_button.dart';
import 'package:glover/widgets/custom_list_view.dart';
import 'package:glover/widgets/list_items/cart.list_item.dart';
import 'package:glover/widgets/states/cart.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dotted_line/dotted_line.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      title: "My Cart".tr(),
      body: SafeArea(
        child: ViewModelBuilder<CartViewModel>.reactive(
          viewModelBuilder: () => CartViewModel(context),
          onViewModelReady: (model) => model.initialise(),
          builder: (context, model, child) {
            return Container(
              key: model.pageKey,
              child: VStack(
                [
                  //
                  if (model.cartItems.isEmpty)
                    EmptyCart().centered().expand()
                  else
                    VStack(
                      [
                        //cart items list
                        CustomListView(
                          noScrollPhysics: true,
                          dataSet: model.cartItems,
                          itemBuilder: (context, index) {
                            //
                            final cart = model.cartItems[index];
                            final product = cart.product;
                            return InkWell(
                              child: CartListItem(
                                cart,
                                onQuantityChange: (qty) =>
                                    model.updateCartItemQuantity(qty, index),
                                deleteCartItem: () =>
                                    model.deleteCartItem(index),
                              ),
                              onTap: () => model.productSelected(product!),
                            );
                          },
                        ),

                        //
                        UiSpacer.divider(height: 20),
                        ApplyCoupon(model),
                        UiSpacer.verticalSpace(),
                        AmountTile(
                            "Total Item".tr(), model.totalCartItems.toString()),
                        AmountTile(
                            "Sub-Total".tr(),
                            "${model.currencySymbol} ${model.subTotalPrice}"
                                .currencyFormat()),
                        Visibility(
                          visible: model.coupon != null &&
                              !model.coupon!.for_delivery,
                          child: AmountTile(
                              "Discount".tr(),
                              "${model.currencySymbol} ${model.discountCartPrice}"
                                  .currencyFormat()),
                        ),
                        //
                        Visibility(
                          visible: model.coupon != null &&
                              model.coupon!.for_delivery,
                          child: VStack(
                            [
                              DottedLine(
                                dashColor: context.textTheme.bodyLarge!.color!,
                              ).py12(),
                              "Discount will be applied to delivery fee on checkout"
                                  .tr()
                                  .text
                                  .medium
                                  .make(),
                            ],
                          ).py(4),
                        ),
                        DottedLine(
                                dashColor: context.textTheme.bodyLarge!.color!)
                            .py12(),
                        AmountTile(
                            "Total".tr(),
                            "${model.currencySymbol} ${model.totalCartPrice}"
                                .currencyFormat()),
                        //
                        CustomButton(
                          title: "CHECKOUT".tr(),
                          onPressed: model.checkoutPressed,
                        ).h(Vx.dp48).py32(),
                      ],
                    )
                        .pOnly(bottom: context.mq.viewPadding.bottom)
                        .scrollVertical(padding: EdgeInsets.all(20))
                        .expand(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
