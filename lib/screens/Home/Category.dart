import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/screens/Menu/menuScreen.dart';
import 'package:project_final/utils/helper.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Awaiting result...');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else {
              if (snapshot.hasData == null) {
                return Text('Error');
              }
              var array = snapshot.data?.docs ?? [];
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: array.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuScreen(categoryId: array[index]['id'], categoryName: array[index]['name']),
                            ),
                          );
                        },
                        child:
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  child: Image.network(
                                    array[index]['imageHome'],
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              array[index]['name'],
                              style: Helper.getTheme(context).headline4?.copyWith(color: AppColor.primary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
        }
      },
    );
  }
}
