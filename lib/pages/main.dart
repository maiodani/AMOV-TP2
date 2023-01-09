import 'package:amov_tp2/pages/edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../model/data.dart';


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



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static const String routeName = '/';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
const String _urlMenu = 'http://10.0.2.2:8080/menu';
class _MyHomePageState extends State<MyHomePage> {

  List<Menu> _menus = <Menu>[];
  List<Menu> _menusUpdate = <Menu>[];

  //List<Menu>? _menus;
  bool _fetchingData = false; // false nao processa dados true processa

  @override
  void initState(){
    super.initState();
    _fetchMenu();
  }

  void reorderMeals(List<Menu> aux, List<Menu> fill){
    DateTime date = DateTime.now();
    bool first = false;
    int cont = 0;
    if(date.weekday < 6){
      for(int i = 0; i < aux.length; i++){
        if(first){
          cont++;
          if(cont >= 5){
            fill.add(aux[cont-5]);
          }else{
            fill.add(aux[cont]);
          }

        }else{
          if(date.weekday == i+1){
            cont = i;
            i = 0;
            fill.add(aux[cont]);
            first = true;
          }
        }
      }
    }else{
      fill.addAll(aux);
    }
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
          _menusUpdate.clear();
          WeekDay.values.forEach((element) {
            if(element != WeekDay.NOTHING) {
              aux.add(Menu.fromJson(decodeData[element.name.toString()]['original']));
            }
          });
          reorderMeals(aux, _menus);
          aux.clear();
          WeekDay.values.forEach((element) {
            if(element != WeekDay.NOTHING) {
              if (decodeData[element.name.toString()]['update'] != null) {
                aux.add(Menu.fromJson(
                    decodeData[element.name.toString()]['update']));
              }
            }
          });
          reorderMeals(aux, _menusUpdate);
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

        body: SingleChildScrollView(
          child: Column(
            children:<Widget>[
              ElevatedButton(
                onPressed: _fetchMenu,
                child: const Text('Fetch menu'),
              ),

              ListView.builder(
                padding: const EdgeInsets.all(2),
                itemCount: _menus.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext ctxt, int index){
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Edit.routeName,
                            arguments: EditArguments(
                              _menus[index],
                              WeekDay.getIndexOnArray(_menusUpdate, _menus[index].weekDay) != -1?
                              _menusUpdate[WeekDay.getIndexOnArray(_menusUpdate, _menus[index].weekDay)] : Menu("",WeekDay.NOTHING, "", "", "", "", ""),
                            ),
                          );
                          _fetchMenu;
                        },
                        child: buildCard(_menus[index]),
                      ),
                      const SizedBox(height: 12,),
                    ],
                  );
                },
              ),
            ],
          ),
        ),


    );
  }

  Widget buildCard(Menu menu) => Container(
    child: Card(
      color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Transform.translate(
                offset: const Offset(0, 0),
                child: menu.img != null?
                Image.asset('images/${menu.img!}',
                  height: 100,
                  width: 150,
                  fit: BoxFit.fitWidth,
                )
                    : null,
              ),
              menu.img != null?
                const SizedBox(width: 60,
                ): const SizedBox(width: 150),
              Text(menu.weekDay.convert(menu.weekDay), style: TextStyle(fontSize: 20),),
            ],
          ),
          const SizedBox(height: 20,),
          WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay) != -1?
          (menu.soup != _menusUpdate[WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay)].soup?
            textMealsUnderline("SOPA", menu.weekDay) : textMealsNormal("SOPA", menu.weekDay))
              : textMealsNormal("SOPA", menu.weekDay),

          const SizedBox(height: 20,),

          WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay) != -1?
          (menu.meat != _menusUpdate[WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay)].meat?
          textMealsUnderline("CARNE", menu.weekDay) : textMealsNormal("CARNE", menu.weekDay))
              : textMealsNormal("CARNE", menu.weekDay),

          const SizedBox(height: 20,),

          WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay) != -1?
          (menu.fish != _menusUpdate[WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay)].fish?
          textMealsUnderline("PEIXE", menu.weekDay) : textMealsNormal("PEIXE", menu.weekDay))
            : textMealsNormal("PEIXE", menu.weekDay),

          const SizedBox(height: 20,),

          WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay)!= -1?
          (menu.vegetarian != _menusUpdate[WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay)].vegetarian?
          textMealsUnderline("VEGETARIANO", menu.weekDay) : textMealsNormal("VEGETARIANO", menu.weekDay))
            : textMealsNormal("VEGETARIANO", menu.weekDay),

          const SizedBox(height: 20,),

          WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay) != -1?
            (menu.desert != _menusUpdate[WeekDay.getIndexOnArray(_menusUpdate, menu.weekDay)].desert?
          textMealsUnderline("SOBREMESA", menu.weekDay) : textMealsNormal("SOBREMESA", menu.weekDay))
            : textMealsNormal("SOBREMESA", menu.weekDay),


        ],
      ),
    ),
  );


  String readMeal(String meal, List<Menu> aux, WeekDay weekDay){
    switch (meal){
      case "SOPA":{
        return aux[WeekDay.getIndexOnArray(aux, weekDay)].soup;
      }
      case "CARNE":{
        return aux[WeekDay.getIndexOnArray(aux, weekDay)].meat;
      }
      case "PEIXE":{
        return aux[WeekDay.getIndexOnArray(aux, weekDay)].fish;
      }
      case "VEGETARIANO":{
        return aux[WeekDay.getIndexOnArray(aux, weekDay)].vegetarian;
      }
      case "SOBREMESA":{
        return aux[WeekDay.getIndexOnArray(aux, weekDay)].desert;
      }
    }
    return "";
  }

  Widget textMealsNormal(String meal, WeekDay weekDay) => Text(
    '$meal: ${readMeal(meal, _menus, weekDay)}',
    style: const TextStyle(fontSize: 15),
  );
  Widget textMealsUnderline(String meal, WeekDay weekDay) => Text(
      '$meal: ${readMeal(meal, _menusUpdate, weekDay)}',
      style: const TextStyle(
        fontSize: 15,
        decoration: TextDecoration.underline,
      ),
  );
}



