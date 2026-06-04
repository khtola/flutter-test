import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:first_app/product_detail_screen.dart';

Widget widgetGridView(BuildContext context,{required Function onClick}){
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
    padding: const EdgeInsets.only(top: 3),
    height: MediaQuery.of(context).size.height * 0.6,
    width: double.infinity,
    child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  ),),
                Expanded( 
                  flex: 1, 
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  ),),
                Expanded( 
                  flex: 1, 
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail()),
                        );
                      },
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  ),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  )),
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  )),
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap:() => onClick(),
                      child: Image.asset('assets/Screenshot1.png',fit: BoxFit.fill,height: 130,),
                    ),
                  )),
              ],
            ),
          ],
        )),
    );
  }
  
