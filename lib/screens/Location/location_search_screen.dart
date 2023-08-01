import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_final/screens/Location/network_utility.dart';
import 'package:project_final/screens/Location/place_auto_complate_response.dart';
import 'package:project_final/screens/cartScreen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/helper.dart';
import './location_list_tile.dart';
import 'autocomplate_prediction.dart';
import 'constants.dart';

class SearchLocationScreen extends StatefulWidget {
  static const routeName = "/location";
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<AutocompletePrediction> placePridiction = [];

  void placeAutocomplate(String query)async{
    Uri uri = Uri.https("maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input":query,
        "key":apiKey,
      }

    );
    String? reponse = await NetworkUtility.fetchUrl(uri);
    if(reponse != null ){
      print(reponse);
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(reponse);
      if(result.predictions != null){
        setState(() {
          placePridiction = result.predictions!;
        });
      }
    }


  }


  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String temp="";
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: defaultPadding),
          child: CircleAvatar(
            backgroundColor:secondaryColor10LightTheme,
            child:Image.asset(
              Helper.getAssetName(
                "location.png",
                "real",
              ), height: 16,
              width: 16,),

          ),
        ),
        backgroundColor:  Colors.white,

        title: const Text(
          "Địa chỉ nhận hàng",
          style: TextStyle(color: textColorLightTheme, fontSize: 20),
        ),
        actions: [
          CircleAvatar(
            backgroundColor:Color(0xFFEEEEEE),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(CartScreen.routeName);

              },
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          const SizedBox(width: defaultPadding)
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                onChanged: (value) {
                  temp = value;
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Tìm kiếm địa chỉ của bạn",
                  fillColor: secondaryColor5LightTheme,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Image.asset(
                      Helper.getAssetName(
                        "location_pin.png",
                        "real",
                      ), height: 16,
                      width: 16,),
                  ),

                ),

              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton.icon(
              onPressed: () {
                placeAutocomplate(temp);
              },
              icon: Image.asset(
                Helper.getAssetName(
                  "location.png",
                  "real",
                ), height: 16,
                ),
              label: const Text("Tìm kiếm"),

              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor10LightTheme,
                foregroundColor: textColorLightTheme,
                elevation: 0,
               minimumSize: const Size.fromHeight(30),
                fixedSize: const Size(double.infinity, 45),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                textStyle: TextStyle(fontSize: 18)
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: placePridiction.length,
                itemBuilder: (context,index)=>LocationListTile(
                  press: () {
                    Map<Object,Object> data1 = {
                      "bio":placePridiction[index].description!
                    };
                    ap.editUser(data1: data1);
                    Timer(Duration(milliseconds: 2000), () {
                      Navigator.of(context).pushReplacementNamed(CartScreen.routeName);

                    });
                  },
                  location: placePridiction[index].description!,
                ),),
          )

        ],
      ),
    );
  }
}
