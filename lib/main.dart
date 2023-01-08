import 'package:amov_tp2/edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cantina ISEC',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Ementa ISEC'),
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName : (context) => MyHomePage(title: 'Cantina ISEC'),
        Edit.routeName : (context) => Edit(),
      },
    );
  }
}

enum WeekDay{
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY;

  String convert(WeekDay weekDay){
    switch (weekDay){
      case WeekDay.MONDAY:{
        return "Seguda-Feira";
      }
      case WeekDay.TUESDAY:{
        return "Terça-Feira";
      }
      case WeekDay.WEDNESDAY:{
        return "Quarta-Feira";
      }
      case WeekDay.THURSDAY:{
        return "Quinta-Feira";
      }
      case WeekDay.FRIDAY:{
        return "Sexta-Feira";
      }
    }
  }

  int getIndex(WeekDay weekDay) {
    switch (weekDay) {
      case WeekDay.MONDAY:
        {
          return 0;
        }
      case WeekDay.TUESDAY:
        {
          return 1;
        }
      case WeekDay.WEDNESDAY:
        {
          return 2;
        }
      case WeekDay.THURSDAY:
        {
          return 3;
        }
      case WeekDay.FRIDAY:
        {
          return 4;
        }
    }
  }
}

class Menu{
  String? img;
  WeekDay weekDay;
  String soup;
  String fish;
  String meat;
  String vegetarian;
  String desert;

  Menu.fromJson(Map<String, dynamic> json):
        img = json['img'],
        weekDay = WeekDay.values.byName(json['weekDay']),
        soup = json['soup'],
        fish = json['fish'],
        meat = json['meat'],
        vegetarian = json['vegetarian'],
        desert = json['desert'];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static const String routeName = '/';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
const String _urlMenu = 'http://172.27.208.1:8080/menu'; // TODO meter ip
class _MyHomePageState extends State<MyHomePage> {

  List<Menu> _menus = <Menu>[];

  //List<Menu>? _menus;
  bool _fetchingData = false; // false nao processa dados true processa

  @override
  void initState(){
    super.initState();
    _fetchMenu();
  }

  Future<void> _fetchMenu() async { // Obter info da base de dados
    try{
      List<Menu> aux = <Menu>[];
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse(_urlMenu));

      if(response.statusCode == HttpStatus.ok){
        final Map<String, dynamic> decodeData = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(response.body);
        setState((){
          _menus.clear();
          WeekDay.values.forEach((element) {
            aux.add(Menu.fromJson(decodeData[element.name.toString()]['original']));
          });

          DateTime date = DateTime.now();
          bool first = false;
          int cont = 0;
          if(date.weekday < 6){
            for(int i = 0; i < aux.length; i++){
              if(first){
                cont++;
                if(cont >= 5){
                  _menus.add(aux[cont-5]);
                }else{
                  _menus.add(aux[cont]);
                }

              }else{
                if(date.weekday == i+1){
                  cont = i;
                  i = 0;
                  _menus.add(aux[cont]);
                  first = true;
                }
              }

            }
          }else{
            _menus.addAll(aux);
          }
          _menus[0].img = 'bife.jpg';
        });

      }
    }catch(e){
      debugPrint('Something went wrong: $e');
    }finally{
      setState(() => _fetchingData = false);
    }
  }

  //usar gesturedetector para detetar toques em outro elementos
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(2), //TODO ver para que serve
              children: [
                const SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: _fetchMenu,
                  child: const Text('Fetch menu'),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Edit.routeName,
                    arguments: _menus[0],
                  ),
                  child: buildCard(_menus[0].weekDay),
                ),
                const SizedBox(height: 12,),
                buildCard(_menus[1].weekDay),
                const SizedBox(height: 12,),
                buildCard(_menus[2].weekDay),
                const SizedBox(height: 12,),
                buildCard(_menus[3].weekDay),
                const SizedBox(height: 12,),
                buildCard(_menus[4].weekDay),
                const SizedBox(height: 12,),
              ],
          ),
        )
    );
  }

  Widget buildCard(WeekDay weekDay) => Container(
    child: Card(
      color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min, //TODO ver isto
        children: <Widget>[
          Row(
            children: <Widget>[
              Transform.translate(
                offset: const Offset(0, 0),
                child: _menus[weekDay.getIndex(weekDay)].img != null?
                Image.asset('images/${_menus[weekDay.getIndex(weekDay)].img!}',
                  height: 100,
                  width: 150,
                  fit: BoxFit.fitWidth,
                )
                    : null,
              ),
              _menus[weekDay.getIndex(weekDay)].img != null?
                const SizedBox(width: 60,
                ): const SizedBox(width: 150),
              Text(weekDay.convert(weekDay), style: TextStyle(fontSize: 20),),
            ],
          ),
          const SizedBox(height: 20,),
          Text(
            'SOPA: ${_menus[weekDay.getIndex(weekDay)].soup}',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20,),
          Text(
            'CARNE: ${_menus[weekDay.getIndex(weekDay)].meat}',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20,),
          Text(
            'PEIXE: ${_menus[weekDay.getIndex(weekDay)].fish}',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20,),
          Text(
            'VEGETARIANO: ${_menus[weekDay.getIndex(weekDay)].vegetarian}',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20,),
          Text(
            'Sobremesa: ${_menus[weekDay.getIndex(weekDay)].desert}',
            style: const TextStyle(fontSize: 15),
          ),

        ],
      ),
    ),
  );
}



