import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/DrawerPages/home.dart';
import 'package:workspace/Models/medlist.dart';
import 'package:workspace/Models/suggestion.dart';
import 'package:workspace/Models/sumlist.dart';
import 'package:workspace/services/expenditureservice.dart';
import 'package:workspace/services/intakeservice.dart';
import 'package:workspace/services/medservice.dart';

MedService ms = new MedService();
IntakeService it = new IntakeService();
ExpenditureService es = new ExpenditureService();

class SuggestionPage extends StatefulWidget {
  @override
  SuggestionPageState createState() {
    return new SuggestionPageState();
  }
}

class SuggestionPageState extends State<SuggestionPage> {
  List<Suggestion> statlist = [];
  //List<Suggestion> suggestionlist = [];
  List<Color> colors = [
    Colors.teal.shade600,
    Colors.teal.shade400,
  ];
  List<SumList> s1 = [];
  int nbr = 0;
  int nbrchecked = 0;
  int nbrActive = 0;
  double caloriesburned = 0.0;
  double weight, height;
  int age;
  double bmr;
  double calories = 0.0;
  String sugg1 = "";
  String sugg2 = "";

  double getBMR(double weights, double heights, int ages) {
    return 66.5 + (weights * 13.75) + (heights * 5) + (ages * 6.775);
  }

  MedList get value => null;
  @override
  void initState() {
    FutureCountIntakes();
    FutureChecked();
    FutureActive();
    FutureCaloriesBurned();
    super.initState();
  }

  void FutureCountIntakes() {
    it.CountIntakes(Home.currentUser.id).then((value) {
      setState(() {
        nbr = value;
      });
    });
  }

  void updateMeds(int index) {
    setState(() {
      sugg1 = "Médicaments pris : $nbrchecked/$nbr Intakes";
      if ((nbrchecked / nbr) < 0.2) {
        sugg2 =
            "Vous n'avez pas pris vos médicaments, Est-ce que vous avez oublier de les achetés ?";
      } else if ((nbrchecked / nbr) < 0.7) {
        sugg2 =
            "Vous aves oublier de prendre qulques médicaments Activez la fonction Alarm (routine ) pour vous rappeler";
      } else if (nbrchecked / nbr == 1) {
        sugg2 = "Parfait : vous avez pris tout vos médicaments";
      }
    });
  }

  void updateCalories(int index) {
    setState(() {
      sugg1 = "Calories brulées : $calories Kcal";

      if (calories < 1000) {
        sugg2 =
            "Calories brulées $calories: consomez seulment les aliments faible en calories";
      } else if (calories < 2500) {
        sugg2 =
            "Calories : brulées $calories évitez les aliments riches en calories ";
      } else if (calories < 100000) {
        sugg2 = "Calories : $calories vous pouvez consomer les aliments riches";
      }
    });
  }

  void updateActive(int index) {
    setState(() {
      sugg1 = "Jours actifs : $nbrActive/14 Jours";

      if (nbrActive < 2) {
        sugg2 = "Mode de vie sédentaire, Pensez à fair du sport ou à marcher";
      } else if (nbrActive < 5) {
        sugg2 = "Mode de vie légèrement actif $nbrActive/14 Jours";
      } else if (nbrActive < 10) {
        sugg2 = "Style de vie actif : $nbrActive/14 Jours actifs";
      } else {
        sugg2 =
            "Vous êtes très actif : $nbrActive/14 Jours actifs, chapeau bas !";
      }
    });
  }

  void FutureChecked() {
    it.CountCheckedIntakes(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        nbrchecked = value;
        Suggestion s = new Suggestion(
            "Médicaments pris : ", "$value/$nbr Intakes", "meds");
        statlist.add(s);

        if ((value / nbr) < 0.2) {
          Suggestion s2 = new Suggestion(
              "Vous n'avez pas pris vos ",
              "médicaments, Est-ce que vous avezoublier de les achetés ?",
              "meds");
          //suggestionlist.add(s2);
        } else if ((value / nbr) < 0.7) {
          Suggestion s2 = new Suggestion(
              "Vous aves oublier de prendre qulques",
              "médicaments Activez la fonction Alarm( routine ) pour vous rappeler",
              "meds");
          //suggestionlist.add(s2);
        } else if (value / nbr == 1) {
          Suggestion s2 = new Suggestion(
              "Parfait : vous avez ", "pris tout vos médicaments", "meds");
          //suggestionlist.add(s2);
        }
      });
    });
  }

  void FutureActive() {
    es.ActiveDays(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        nbrActive = value;
        //double bmr = getBMR(61, 1.78, 22); //missing
        Suggestion s =
            new Suggestion("Jours actifs : ", "$value/14 Jours", "activity");
        statlist.add(s);
        if (value < 2) {
          Suggestion s2 = new Suggestion("Mode de vie sédentaire ",
              "Pensez à fair du sport ou à marcher", "activity");
          //suggestionlist.add(s2);
        } else if (value > 5) {
          Suggestion s2 = new Suggestion(
              "Mode de vie légèrement actif ", "$value/14 Jours", "activity");
          //suggestionlist.add(s2);
        } else if (value < 10) {
          Suggestion s2 = new Suggestion(
              "Style de vie actif : ", "$value/14 Jours actifs", "activity");
          //suggestionlist.add(s2);
        }
        {
          Suggestion s2 = new Suggestion("Vous êtes très actif : ",
              "$value/14 Jours actifs, chapeau bas !", "activity");
          //suggestionlist.add(s2);
        }
      });
    });
  }

  void FutureList() {
    es.stats(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        statlist.addAll(value);
      });
    });
  }


void FutureCaloriesBurned() {
    es.sumOne(Home.currentUser.id).then((value) {
      //change me
      setState(() {
        s1.addAll(value);
        if (value.length == 0) {
          SumList y = new SumList();
          y.sum = 0;
          s1.add(y);
        }
        double x = 0;
        calories = 0;
        double n = 0;
        if (s1 != null) {
          x = s1[0].sum;
          n = num.parse(x.toStringAsFixed(2));
        }

        calories = n;
        Suggestion s =
            new Suggestion("Calories brulées : ", "$n Kcal", "calories");
        statlist.add(s);
        if (n == 0) {
          Suggestion s2 = new Suggestion("Calories brulées $n: ",
              "consomez seulment les aliments faible en calories", "calories");
        }
        if (n < 1000) {
          Suggestion s2 = new Suggestion("Calories brulées $n: ",
              "consomez seulment les aliments faible en calories", "calories");
        } else if (n < 2500) {
          Suggestion s2 = new Suggestion("Calories : brulées $n",
              "évitez les aliments riches en calories ", "calories");
        } else if (n < 100000) {
          Suggestion s2 = new Suggestion("Calories : $n ",
              "vous pouvez consomer les aliments riches", "calories");
        }
      });
    });
  }

  Color overflowColors(int index) {
    int x = index % 2;
    return colors[x];
  }

  String overflowSuggestionname(int index) {
    int x = index % 3;
    return statlist[x].name;
  }

  String overflowSuggestiondesc(int index) {
    int x = index % 3;
    return statlist[x].desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggestions'),
      ),
      body: Column(
        children: <Widget>[
          Divider(),
          Text("Statistiques"),
          Divider(),
          FutureBuilder(
              future: es.stats(Home.currentUser.id), //change me
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return new Text("Data is not fetched");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return new CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return new Text("fetch error");
                  } else {
                    return _buildCarousel(context, 1);
                  }
                } else
                  return Text("!");
              }),
          Divider(),
          Text("Suggestions"),
          Divider(),
          //Text(sugg1),
          Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(sugg1),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [],
                                          )),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: RichText(
                                    text: TextSpan(
                                      text: sugg2,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Roboto',
                                          color: Colors.teal),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'Roboto',
                                                color: Colors.teal)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ))),
          SizedBox(height: 20),
          Divider(),
          /*FutureBuilder(
              future: es.stats(Home.currentUser.id), //change me
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return new Text("Data is not fetched");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return new CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return new Text("fetch error");
                  } else {
                    return _buildCarousel2(context, 1);
                  }
                } else
                  return Text("!");
              }),*/
        ],
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //Text('Carousel $carouselIndex'),
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, carouselIndex, itemIndex);
            },
          ),
        )
      ],
    );
  }

  void tapped(int index) {
    var x = index % 3;

    if (statlist[x].type == "meds") {
      updateMeds(x);
    } else if (statlist[x].type == "activity") {
      updateActive(x);
    } else if (statlist[x].type == "calories") {
      updateCalories(x);
    }
  }

  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () {
          tapped(itemIndex);
        },
        child: Container(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: AvatarGlow(
                          glowColor: Colors.white,
                          endRadius: 30.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Material(
                              // Replace this child with your own
                              elevation: 8.0,
                              shape: CircleBorder(),
                              child: Icon(Icons.touch_app)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        overflowSuggestionname(itemIndex),
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Roboto',
                            color: Colors.white),
                      ),
                    ],
                  ),

                  //Spacer(),

                  Spacer(),
                  Text(
                    overflowSuggestiondesc(itemIndex),
                    style: new TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Roboto',
                        color: Colors.white),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
            color: overflowColors(itemIndex),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ),
    );
  }

  /*Widget _buildCarousel2(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //Text('Carousel $carouselIndex'),
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem2(context, carouselIndex, itemIndex);
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItem2(
      BuildContext context, int carouselIndex, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        //width: 195,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Spacer(),
                Text(
                  //suggestionlist[itemIndex].name,
                  overflowSuggestionname2(itemIndex),
                  style: new TextStyle(
                      fontSize: 10.0,
                      fontFamily: 'Roboto',
                      color: Colors.white),
                ),
                Spacer(),
                Text(
                  overflowSuggestiondesc2(itemIndex),
                  style: new TextStyle(
                      fontSize: 10.0,
                      fontFamily: 'Roboto',
                      color: Colors.white),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: overflowColors(itemIndex),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }*/
}
