import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/admin/admin_create_category_screen.dart';
// import 'package:Erdenet24/screens/admin/admin_create_category_screen.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/controller/product_controller.dart';

class UserProfileAdminMainScreen extends StatefulWidget {
  const UserProfileAdminMainScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileAdminMainScreen> createState() =>
      _UserProfileAdminMainScreenState();
}

class _UserProfileAdminMainScreenState
    extends State<UserProfileAdminMainScreen> {
  int _userId = 0;
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordRepeat = TextEditingController();
  final _prodCtrl = Get.put(ProductController());
  final Widget _divider = const Divider(height: 0.7, color: MyColors.grey);

  @override
  void initState() {
    super.initState();
    setState(() {
      _userId = RestApiHelper.getUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: MyColors.fadedGrey,
          ),
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: MyColors.fadedGrey,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "${URL.AWS}/users/$_userId.png",
                    imageBuilder: (context, imageProvider) => Container(
                      width: Get.width * .5,
                      height: Get.width * .5,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => CustomShimmer(
                      width: Get.width * .5,
                      height: Get.width * .5,
                    ),
                    errorWidget: (context, url, error) => const Image(
                        image: AssetImage("assets/images/png/no_image.png")),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Admin",
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    text: "+976-99990286",
                    color: MyColors.gray,
                  ),
                  SizedBox(height: 8),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _listItem(
                  IconlyLight.add_user,
                  "Дэлгүүр үүсгэх",
                  "Шинээр дэлгүүр нэмэх",
                  // () => Get.to(() => const UserProfileAdminStoreScreen()),
                  () {}),
              _divider,
              _listItem(IconlyLight.calendar, "Захиалгууд харах",
                  "Бүх захиалгууд харах", () => Get.to(() {})),
              _divider,
              _listItem(
                IconlyLight.plus,
                "Ангилал нэмэх",
                "Шинэ ангилал нэмэх",
                () => Get.to(() => const AdminCreateCategoryScreen()),
              ),
              _divider,
              // _listItem(IconlyLight.setting, "Ангилал засах", "Засах, устгах",
              //     () => Get.to("")),
              // _divider,
              _listItem(
                IconlyLight.login,
                "Гарах",
                "Системээс гарах",
                () => showLogout(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showLogout() {
    Get.bottomSheet(Container(
      height: Get.height * .2,
      color: MyColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const CustomText(text: "Та гарахдаа итгэлтэй байна уу?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: Get.width * .4,
                child: CustomButton(
                  text: "Үгүй",
                  textColor: MyColors.black,
                  onPressed: () => Get.back(),
                  bgColor: MyColors.fadedGrey,
                  cornerRadius: 25,
                  isFullWidth: false,
                ),
              ),
              SizedBox(
                width: Get.width * .4,
                child: CustomButton(
                  text: "Тийм",
                  textColor: MyColors.primary,
                  onPressed: () {
                    // _prodCtrl.logout();
                    Get.back();
                  },
                  bgColor: MyColors.fadedGrey,
                  cornerRadius: 25,
                  isFullWidth: false,
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}

Widget _listItem(
    IconData leadingIcon, String title, String subtitle, dynamic onTap) {
  return CustomInkWell(
    onTap: onTap,
    borderRadius: BorderRadius.zero,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              leadingIcon,
              color: MyColors.black,
              size: 20,
            ),
          ],
        ),
        title: CustomText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        subtitle: CustomText(
          text: subtitle,
          fontSize: 12,
        ),
      ),
    ),
  );
}
