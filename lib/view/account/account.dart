import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delievery/controller/provider/profileProvider/profileProvider.dart';
import 'package:food_delievery/controller/services/authServices/mobileAuthServices.dart';
import 'package:food_delievery/model/userModel.dart';
import 'package:food_delievery/utils/colors.dart';
import 'package:food_delievery/utils/textStyles.dart';
import 'package:food_delievery/view/addressScreen/addressScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List account = [
    [FontAwesomeIcons.shop, 'Tus pedidos'],
    [FontAwesomeIcons.locationPin, 'Mis direcciones'],
    [FontAwesomeIcons.heart, 'Tus favoritos'],
    [FontAwesomeIcons.star, 'Calificación de restaurantes'],
    [FontAwesomeIcons.wallet, 'Billetera'],
    [FontAwesomeIcons.gift, 'Envía un regalo'],
    [FontAwesomeIcons.suitcase, 'Configuracion de negocios'],
    [FontAwesomeIcons.person, 'Ayuda'],
    [FontAwesomeIcons.tag, 'Promociones'],
    [FontAwesomeIcons.ticket, 'Delievery pro'],
    [FontAwesomeIcons.suitcase, 'Envia domicilios'],
    [FontAwesomeIcons.gear, 'Configuraciones'],
    [FontAwesomeIcons.powerOff, 'Cerrar sesión'],
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      children: [
        SizedBox(
          height: 4.h,
        ),
        Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
          if (profileProvider.userData == null) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 3.h,
                  backgroundColor: black,
                  child: CircleAvatar(
                    radius: 3.h - 2,
                    backgroundColor: white,
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: 3.h,
                      color: grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  'Bienvenido usuario',
                  style: AppTextStyles.body16,
                ),
              ],
            );
          } else {
            UserModel userData = profileProvider.userData!;
            return Row(
              children: [
                CircleAvatar(
                  radius: 3.h,
                  backgroundColor: black,
                  child: CircleAvatar(
                    radius: 3.h - 2,
                    backgroundColor: white,
                    backgroundImage: NetworkImage(userData.profilePicURL),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  userData.name,
                  style: AppTextStyles.body16,
                ),
              ],
            );
          }
        }),
        SizedBox(
          height: 2.h,
        ),
        ListView.builder(
            itemCount: account.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  if (index == 1) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const AddressScreen(),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  }
                  if(index == (account.length - 1)) {
                    MobileAuthServices.signOut(context);
                  }
                },
                leading: FaIcon(
                  account[index][0],
                  size: 3.h,
                  color: black,
                ),
                title: Text(
                  account[index][1],
                  style: AppTextStyles.body14,
                ),
              );
            })
      ],
    ));
  }
}
