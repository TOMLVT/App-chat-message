import 'package:app_chat_small/Login%20Signup/login.dart';
import 'package:flutter/material.dart';

class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.53,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.53,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                   image: DecorationImage(
                     image: AssetImage("images/imgchat.png"),
                     fit: BoxFit.cover,
                   ),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
                  ),
                ),

              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.88,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/imgchat.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.88,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child:  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nhắn tin mọi nơi" , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("Trò chuyện cùng nhau và \n gặp gỡ mọi người nơi khác..." , style: TextStyle(color: Colors.black54 , fontSize: 18),),
                          Padding(
                            padding: EdgeInsets.only(left: 15 , right: 15, top: 60),
                            child: Row(
                              children: [
                                Container(
                                  width : 16,
                                 height: 16,
                                 decoration: BoxDecoration(
                                   color: Colors.blue,
                                   borderRadius: BorderRadius.circular(200),
                                   border: Border.all(width: 1.5, color: Colors.blue),
                                 ),
                                ),
                                SizedBox(width: 16,),
                                Container(
                                  width : 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(200),
                                    border: Border.all(width: 1.5, color: Colors.blue),
                                  ),
                                ),
                                SizedBox(width: 16,),
                                Container(
                                  width : 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(200),
                                    border: Border.all(width: 1.5, color: Colors.blue),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                  },
                                  child: Container(
                                    height: 75,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                     color: Colors.blue,
                                    ),
                                    child:  Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Row(
                                            children: [
                                              Text("Bắt đầu chat" , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , color: Colors.white, ),),
                                              SizedBox(width: 10,),
                                              Icon(Icons.send , size: 22 , color: Colors.white,),
                                            ],
                                          ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
