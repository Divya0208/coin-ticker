import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String currentCurrency = 'USD';
  String exchangeRateBTC = "0.0";
  String exchangeRateETH = "0.0";
  String exchangeRateLTC = "0.0";

  void getData() async {

    exchangeRateBTC = "0.0";
    exchangeRateETH = "0.0";
    exchangeRateLTC = "0.0";

    String urlBTC = 'https://rest.coinapi.io/v1/exchangerate/BTC/$currentCurrency';
    String urlETH = 'https://rest.coinapi.io/v1/exchangerate/ETH/$currentCurrency';
    String urlLTC = 'https://rest.coinapi.io/v1/exchangerate/LTC/$currentCurrency';
    
    http.Response responseBTC = await http.get(urlBTC, headers: {'X-CoinAPI-Key': apiKey});
    if (responseBTC.statusCode == 200) {
      var dataBody = responseBTC.body;
      var data = jsonDecode(dataBody);
      
      setState(() {
        exchangeRateBTC = data['rate'].toStringAsFixed(2);
      });
    } else {
      print(responseBTC.statusCode);
    }

    http.Response responseETH = await http.get(urlETH, headers: {'X-CoinAPI-Key': apiKey});
    if (responseETH.statusCode == 200) {
      var dataBody = responseETH.body;
      var data = jsonDecode(dataBody);
      setState(() {
        exchangeRateETH = data['rate'].toStringAsFixed(2);
      });
    } else {
      print(responseETH.statusCode);
    }      

    http.Response responseLTC = await http.get(urlLTC, headers: {'X-CoinAPI-Key': apiKey});
    if (responseLTC.statusCode == 200) {
      var dataBody = responseLTC.body;
      var data = jsonDecode(dataBody);
      setState(() {
        exchangeRateLTC = data['rate'].toStringAsFixed(2);
      });
    } else {
      print(responseLTC.statusCode);
    }  
  }

  DropdownButton getDropdownButoon(){
    List<DropdownMenuItem> dropdownItems = [];

    for(String currency in currenciesList){
      dropdownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));      
    }

    return DropdownButton(
      value: currentCurrency,
      items: dropdownItems, 
      onChanged: (value){
        setState(() {
          currentCurrency = value;
          getData();
        });     
      });
  }
 
  CupertinoPicker getCupertinoPicker(){
    List<Text> pickerItems = [];

    for(String currency in currenciesList){
      pickerItems.add(Text(
        currency
      ));      
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0, 
      onSelectedItemChanged: (value){
        currentCurrency = currenciesList[value];
        getData();
      }, 
      children: pickerItems
      );
  
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $exchangeRateBTC $currentCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = $exchangeRateETH $currentCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 LTC = $exchangeRateLTC $currentCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getCupertinoPicker() : getDropdownButoon(),
          ),
        ],
      ),
    );
  }
}