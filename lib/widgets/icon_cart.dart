import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/cartScreen.dart';
import 'package:badges/badges.dart' as badges;

class IconCart extends StatelessWidget {


  const IconCart({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.setNumberCart();
    return  GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: badges.Badge(
          badgeContent: Text(ap.number.toString(),style: TextStyle(color: Colors.white,fontSize: 17),),
          child: Icon(
            Icons.shopping_cart,
          ),
        ),
      ),
    );
  }
}
