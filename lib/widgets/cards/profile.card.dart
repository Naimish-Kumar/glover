import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:glover/constants/app_finance_settings.dart';
import 'package:glover/constants/app_images.dart';
import 'package:glover/constants/app_strings.dart';
import 'package:glover/constants/app_ui_settings.dart';
import 'package:glover/resources/resources.dart';
import 'package:glover/utils/ui_spacer.dart';
import 'package:glover/view_models/profile.vm.dart';
import 'package:glover/widgets/busy_indicator.dart';
import 'package:glover/widgets/cards/custom.visibility.dart';
import 'package:glover/widgets/menu_item.dart';
import 'package:glover/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.model, {Key? key}) : super(key: key);

  final ProfileViewModel model;
  @override
  Widget build(BuildContext context) {
    return model.authenticated
        ? VStack(
            [
              //profile card
              HStack(
                [
                  //
                  CachedNetworkImage(
                    imageUrl: model.currentUser?.photo ?? "",
                    progressIndicatorBuilder: (context, imageUrl, progress) {
                      return BusyIndicator();
                    },
                    errorWidget: (context, imageUrl, progress) {
                      return Image.asset(
                        AppImages.user,
                      );
                    },
                  )
                      .wh(Vx.dp64, Vx.dp64)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make(),

                  //
                  VStack(
                    [
                      //name
                      model.currentUser!.name.text.xl.semiBold.make(),
                      //email
                      model.currentUser!.email.text.light.make(),
                      //share invation code
                      AppStrings.enableReferSystem
                          ? "Share referral code"
                              .tr()
                              .text
                              .sm
                              .color(context.textTheme.bodyLarge!.color)
                              .make()
                              .box
                              .px4
                              .roundedSM
                              .border(color: Colors.grey)
                              .make()
                              .onInkTap(model.shareReferralCode)
                              .py4()
                          : UiSpacer.emptySpace(),
                    ],
                  ).px20().expand(),

                  //
                ],
              ).p12(),

              //
              VStack(
                [
                  MenuItem(
                    title: "Edit Profile".tr(),
                    onPressed: model.openEditProfile,
                    ic: AppIcons.edit,
                  ),
                  //change password
                  MenuItem(
                    title: "Change Password".tr(),
                    onPressed: model.openChangePassword,
                    ic: AppIcons.password,
                  ),
                  //referral
                  CustomVisibilty(
                    visible: AppStrings.enableReferSystem,
                    child: MenuItem(
                      title: "Refer & Earn".tr(),
                      onPressed: model.openRefer,
                      ic: AppIcons.refer,
                    ),
                  ),
                  //loyalty point
                  CustomVisibilty(
                    visible: AppFinanceSettings.enableLoyalty,
                    child: MenuItem(
                      title: "Loyalty Points".tr(),
                      onPressed: model.openLoyaltyPoint,
                      ic: AppIcons.loyaltyPoint,
                    ),
                  ),
                  //Wallet
                  CustomVisibilty(
                    visible: AppUISettings.allowWallet,
                    child: MenuItem(
                      title: "Wallet".tr(),
                      onPressed: model.openWallet,
                      ic: AppIcons.wallet,
                    ),
                  ),
                  //addresses
                  MenuItem(
                    title: "Delivery Addresses".tr(),
                    onPressed: model.openDeliveryAddresses,
                    ic: AppIcons.homeAddress,
                  ),
                  //favourites
                  MenuItem(
                    title: "Favourites".tr(),
                    onPressed: model.openFavourites,
                    ic: AppIcons.favourite,
                  ),
                  //
                  MenuItem(
                    child: "Logout".tr().text.red500.make(),
                    onPressed: model.logoutPressed,
                    suffix: Icon(
                      FlutterIcons.logout_ant,
                      size: 16,
                    ),
                  ),
                  MenuItem(
                    child: "Delete Account".tr().text.red500.make(),
                    onPressed: model.deleteAccount,
                    suffix: Icon(
                      FlutterIcons.delete_ant,
                      size: 16,
                      color: Vx.red400,
                    ),
                  ),
                  //
                  UiSpacer.vSpace(15),
                ],
              ).p12(),
            ],
          )
            .wFull(context)
            .box
            .border(color: Theme.of(context).cardColor)
            .color(Theme.of(context).cardColor)
            .shadow
            .roundedSM
            .make()
        : EmptyState(
            auth: true,
            showAction: true,
            actionPressed: model.openLogin,
          ).py12();
  }
}
