import 'package:covid19/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'counter.dart';
import 'networking.dart';

enum selectedRegion { country, global }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  selectedRegion region = selectedRegion.country;
  List<String> data = ['--', '--', '--', '--', '--'];

  Country selected = Country(
    asset: "assets/flags/np_flag.png",
    dialingCode: "977",
    isoCode: "NP",
    name: "Nepal",
    currency: "Nepalese rupee",
    currencyISO: "NPR",
  );

  void getNumbers() async {
    setState(() {
      data.clear();
      data = ['--', '--', '--', '--', '--'];
    });
    dynamic updatedData = await UpdateNumbers()
        .get(region == selectedRegion.global ? 'Global' : selected.isoCode);
    setState(() {
      data.clear();
      data = updatedData;
    });
  }

  @override
  void initState() {
    getNumbers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 250.0,
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
//              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.teal[100],
              ),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Text(
                      'COVID-19',
                      style: kMainTitleStyle,
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Image.asset(
                                'images/corona.png',
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Image.asset(
                                'images/stayhome.png',
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      MediaQuery.of(context).size.width > 250
                          ? 'Select country:'
                          : '',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(width: 1, color: Colors.teal[100]),
                  ),
                  child: CountryPicker(
                    showDialingCode: false,
                    showName: false,
                    showCurrency: false,
                    showCurrencyISO: false,
                    onChanged: (Country country) {
                      setState(() {
                        selected = country;
                        region == selectedRegion.country
                            ? getNumbers()
                            : region = selectedRegion.global;
                      });
                    },
                    selectedCountry: selected,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 30.0,
                  width: 30.0,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueGrey,
                    autofocus: true,
                    elevation: 2.0,
                    onPressed: getNumbers,
                    child: Icon(
                      Icons.refresh,
                      size: 25.0,
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: 500.0,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RegionSelect(
                    title: selected.name,
                    color: region == selectedRegion.country
                        ? Colors.teal
                        : Colors.teal[100],
                    onPress: () {
                      setState(() {
                        region = selectedRegion.country;
                        getNumbers();
                      });
                    },
                  ),
                  RegionSelect(
                    title: 'Global',
                    color: region == selectedRegion.global
                        ? Colors.teal
                        : Colors.teal[100],
                    onPress: () {
                      setState(() {
                        region = selectedRegion.global;
                        getNumbers();
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Confirmed Cases',
                    style: kTitleTextStyle,
                  ),
                  Text(
                    'Last Updated: ' + data[0],
                    style: kSmallTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 500.0,
                    child: Row(
                      children: <Widget>[
                        Counter(
                          number: data[1],
                          color: kInfectedColor,
                          title: 'Total Cases',
                        ),
                        Counter(
                          number: data[2],
                          color: kDeathColor,
                          title: 'Deaths',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 500.0,
                    child: Row(
                      children: <Widget>[
                        Counter(
                          number: data[3],
                          color: kActiveCasesColor,
                          title: 'Active Cases',
                        ),
                        Counter(
                          number: data[4],
                          color: kRecoverColor,
                          title: 'Recovered',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    '© 2020 Amit Parajuli. All rights reserved.',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegionSelect extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPress;

  RegionSelect({this.title, @required this.color, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            title,
            style: kSelectedTextStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
