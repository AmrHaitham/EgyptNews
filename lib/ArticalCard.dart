import 'package:flutter/material.dart';
class ArticalCard extends StatelessWidget {
  final String title;
  final String content;
  final String urlToImage;
  final String author;
  final String url;
  final String sourceName;
  final String time;
  final Function onPressed;
  const ArticalCard({Key key, this.title, this.content, this.urlToImage, this.author, this.url, this.onPressed, this.sourceName, this.time}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  height:MediaQuery.of(context).size.height*0.29,
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topRight:Radius.circular(10) ,topLeft: Radius.circular(10)),
                    child: Image(
                      image: NetworkImage(
                          urlToImage
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black12,
                        ),
                        child: Text("${time.split("T")[0]} , ${time.split("T")[1].split("Z")[0]}"),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Text("${title}",style: TextStyle(fontSize: 25),)
                      ),
                      Divider(height: 30,),
                      Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Text("${content}",style: TextStyle(fontSize: 20),)
                      ),
                      Divider(height: 30,),
                          ElevatedButton(
                            child: Text("see the full artical",style: TextStyle(fontSize: 15),),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: (){
                              onPressed();
                            },
                          ),
                        ],
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment:  Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Source : ${sourceName}"),
                    Text("Auther : ${author}"),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
