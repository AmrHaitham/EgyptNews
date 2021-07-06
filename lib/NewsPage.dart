import 'package:egy_news/ArticalCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class Newspage extends StatefulWidget {

  @override
  _NewspageState createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  ScrollController _scrollController =ScrollController();
  List apiKeyList= [
    "ae05f624320f45d2a015738218714e17",//amro88981@gmail.com
    "950f0078c9994ca085d0e7d206613e49",//amr@pro.com
    "ef2c6522f13b4cea98c7f541d6178d18",//amr2@pro.com
    "5eea5538f38743828df19e938e5a0cff",//amr3@pro.com
    "32371d236b834443a34a27b847894e56",//amr4@pro.com
  ];
  int _pageSize = 10;
  double maxScroll;
  double currentScroll;
  bool onMore = false;
  var responseTester;
  var jsonDataTester;
  String chosenApi;
  bool arabicArticals = false;
  bool englishArticals = false;
  bool allArticals = true;
  bool connected = true;
  cheakConnection()async{
    connected= await InternetConnectionChecker().hasConnection;
  }
  void apiKeyTester() async{
    for(var api in apiKeyList){
      responseTester = await http.get(Uri.parse("https://newsapi.org/v2/everything?q=none&pageSize=0&apiKey=${api}"));
      jsonDataTester = jsonDecode(responseTester.body);
      if(jsonDataTester['status']=="ok"){
        setState(() {
          chosenApi= api;
        });
        break;
      }
    }
  }

  Future<List<Artical>> getArticals(String api) async{
    print("used api is : ${api}");
     var response = await http.get(Uri.parse("https://newsapi.org/v2/everything?q=Egypt&pageSize=100&apiKey=${api}&language=en"));
     var jsonData = jsonDecode(response.body);
     var response2= await http.get(Uri.parse("https://newsapi.org/v2/everything?q=مصر&pageSize=100&apiKey=${api}&language=ar"));
     var jsonData2 = jsonDecode(response2.body);
     List<Artical> articals = [];
     List<Artical> articals2 = [];
     if(jsonData['status']=="ok"){
       for (var e in jsonData["articles"]) {
         if(e["urlToImage"]== null){
           e["urlToImage"] = "https://yt3.ggpht.com/ytc/AAUvwnjCXKY3XSL101I-LJPU6Gi2s9ueFk2YaLcjxbLZsX=s900-c-k-c0x00ffffff-no-rj";
         }
           Artical artical = Artical(e["title"], e["description"], e["urlToImage"],e["author"],e["url"],e["source"]["name"],e["publishedAt"]);
           articals.add(artical);
           articals.sort((a,b){
            return b.publishedAt.compareTo(a.publishedAt);
           });
       }
       for (var e in jsonData2["articles"]) {
         if(e["urlToImage"]== null){
           e["urlToImage"] == "https://yt3.ggpht.com/ytc/AAUvwnjCXKY3XSL1I-LJPU6Gi2s9ueFk2YaLcjxbLZsX=s900-c-k-c0x00ffffff-no-rj";
         }
           Artical artical = Artical(e["title"], e["description"], e["urlToImage"],e["author"],e["url"],e["source"]["name"],e["publishedAt"]);
           articals2.add(artical);
           articals2.sort((a,b){
              return b.publishedAt.compareTo(a.publishedAt);
            });
       }
     }else{
         print("error api key");
       }
     if(englishArticals == true){
       return articals;
     }
     else if(arabicArticals == true){
       return articals2;
     }
     else if(allArticals == true){
      List<Artical> allArticals = articals;
      allArticals.addAll(articals2);
      allArticals.sort((a,b){
        return b.publishedAt.compareTo(a.publishedAt);
      });
      return allArticals;
    }
  }
  SnackBar _snackBarError =
  SnackBar(content: Text(("Could not open artical")));

  openArtical(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(_snackBarError);
    }
  }
  Future refreshArticals()async{
    setState(() {
      getArticals(chosenApi);
    });
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToTop());
    }
  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setState(() {
      cheakConnection();
    });
    apiKeyTester();
    _scrollController.addListener(() {
      maxScroll = _scrollController.position.maxScrollExtent;
      currentScroll = _scrollController.position.pixels;
      if(currentScroll==maxScroll){
        setState(() {
          if(_pageSize<100){
            onMore = true;
            _pageSize+=10;
            print("page size is :${_pageSize}");
            getArticals(chosenApi);
            onMore = false;
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse("0xffd3daec")),
      appBar:AppBar(
        elevation: 40,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Egypt"),
            Text("News",style: TextStyle(color: Colors.blue),),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(onTap: (){setState(() {});}, child: Icon(Icons.refresh),),
          )
        ],
      ),
      body: connected ? Stack(
        children: [
          Row(
            children: [
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: allArticals ? Colors.white : Colors.transparent,
                      border:
                      Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("All",style: TextStyle(fontSize: 13),)),
                onTap: (){
                  setState(() {
                    allArticals = true;
                    englishArticals = false;
                    arabicArticals = false;
                    _scrollToTop();
                  });
                },
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: englishArticals ? Colors.white : Colors.transparent,
                      border:
                      Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("English articles",style: TextStyle(fontSize: 13),)),
                onTap: (){
                  setState(() {
                    englishArticals = true;
                    arabicArticals = false;
                    allArticals = false;
                    _scrollToTop();
                  });
                },
              ),
              GestureDetector(
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: arabicArticals ? Colors.white : Colors.transparent,
                      border:
                      Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Arabic articles",style: TextStyle(fontSize: 13))),
                onTap: (){
                  setState(() {
                    arabicArticals = true;
                    englishArticals = false;
                    allArticals = false;
                    _scrollToTop();
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height* 0.07),
            child: RefreshIndicator(
                onRefresh: refreshArticals,
                child: FutureBuilder(
                  future: getArticals(chosenApi),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasError){
                      print(snapshot.error);
                      return Center(
                        child :Text("not connected to the internet")
                      );
                    }
                    else if(snapshot.hasData){
                         return Scrollbar(
                          isAlwaysShown: false,
                          thickness: 10,
                          showTrackOnHover: true,
                          radius: Radius.circular(10),
                          controller: _scrollController,
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: _pageSize,
                              itemBuilder: (BuildContext context , int index){
                                if(onMore == true){
                                  return Center(child: CircularProgressIndicator(),);
                                }
                                else return ArticalCard(
                                  urlToImage: snapshot.data[index].urlToImage,
                                  title: snapshot.data[index].title,
                                  content: snapshot.data[index].content,
                                  author: snapshot.data[index].author,
                                  sourceName: snapshot.data[index].sourceName,
                                  time: snapshot.data[index].publishedAt,
                                  onPressed: (){
                                    openArtical(snapshot.data[index].url);
                                  },
                                );
                              },
                            ),
                      );
                    }
                    else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                },
                ),
              ),
          ),
        ],
      ):Center(child: Text("not connected to the internet"),)
    );
  }
}

class Artical{
  final String title;
  final String content;
  final String urlToImage;
  final String author;
  final String url;
  final String sourceName;
  final String publishedAt;
  Artical(this.title, this.content, this.urlToImage,this.author, this.url, this.sourceName, this.publishedAt);
}