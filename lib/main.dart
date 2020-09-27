import 'dart:ui';

import 'widgets/counter.dart';
import 'networking.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constant.dart';
import 'package:getflutter/getflutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'info_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: InfoScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  String slctedState = 'Rajasthan';
  String district = 'Ajmer';
  double offset = 0;
  int active = 0;
  int deaths = 0;
  int recovered = 0;
  int confirmed = 0;
  String slctdDistrict = 'Ajmer';
  bool showSpinner = false;
  bool dataExist = true;

  @override
  void initState() {
    // TODO: implement initState
    getCityData(state: slctedState, district: district);
    super.initState();
    controller.addListener(onScroll);
  }

  void getCityData({state, district}) async {
    setState(() {
      showSpinner = true;
    });
    var ajmerData = await NetworkHelper(
            'https://api.covid19india.org/state_district_wise.json')
        .getData();
    setState(() {
      try {
        dataExist = true;
        active = ajmerData['$state']['districtData']['$district']['active'];
        deaths = ajmerData['$state']['districtData']['$district']['deceased'];
        recovered =
            ajmerData['$state']['districtData']['$district']['recovered'];
        confirmed =
            ajmerData['$state']['districtData']['$district']['confirmed'];
        showSpinner = false;
      } catch (e) {
        showSpinner = false;
        dataExist = false;
        active = 0;
        deaths = 0;
        recovered = 0;
        confirmed = 0;
      }
    });
    return;
  }

  void getCityName() async {
    // var cityName = await NetworkHelper(
    //     'https://api.covid19india.org/state_district_wise.json')
    //     .getData();

    return;
  }

  dynamic getCity(slctdstate) {
//    for (int i = 0; i < kStatesList.length; i += 1) {
//      for (int j = 0; j < kStatesList[i].length; j += 1) {
//        if (slctdstate == kStatesList[i]) {
    return kDistrictsList[(slctdstate)];
  }
//      }
//    }
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          controller: controller,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                MyHeader(
                  image: "assets/icons/Drcorona.svg",
                  textTop: "All you need",
                  textBottom: "is stay at home.",
                  offset: offset,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                      SizedBox(width: 20),
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                          value: slctedState,
                          items: kStatesList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              slctedState = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10),
                      SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                      Expanded(
                        child: GFSearchBar(
                          searchBoxInputDecoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: InputBorder.none,
                            hintText: "Enter Your City Name",
                          ),
                          searchList: getCity(slctedState),
                          searchQueryBuilder: (query, list) {
                            return list
                                .where((item) => item
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();
                          },
                          overlaySearchListItemBuilder: (item) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          },
                          onItemSelected: (item) {
                            setState(() {
                              slctdDistrict = item;
                              showSpinner = true;
                              getCityData(
                                  state: slctedState, district: slctdDistrict);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        dataExist
                            ? "Case Update in $slctdDistrict"
                            : "Sorry!  Data Not Available for $slctdDistrict",
                        style: kTitleTextstyle.copyWith(
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 30,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Counter(
                              color: kInfectedColor,
                              number: active,
                              title: "Active",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Counter(
                              color: kDeathColor,
                              number: deaths,
                              title: "Deaths",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Counter(
                              color: kRecovercolor,
                              number: recovered,
                              title: "Recovered",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Counter(
                              color: kTotalcolor,
                              number: confirmed,
                              title: "Total Cases",
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.home),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Back to HomeScreen',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
