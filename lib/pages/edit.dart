
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/data.dart';


class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  static const String routeName = '/edit';

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late final  EditArguments arguments = ModalRoute.of(context)!.settings.arguments as EditArguments;
  late final Menu _menu = arguments.menu;
  late final Menu _menuUpdated = arguments.menuUpdated;

  TextEditingController soupController = TextEditingController();
  TextEditingController meatController = TextEditingController();
  TextEditingController fishController = TextEditingController();
  TextEditingController vegetarianController = TextEditingController();
  TextEditingController desertController = TextEditingController();

  Future<void> _postMenu() async { // Obter info da base de dados
    dynamic img = null, soup = _menu.soup, meat = _menu.meat, fish = _menu.fish,
        vegetarian = _menu.vegetarian, desert = _menu.desert;

    if(_menuUpdated.weekDay != WeekDay.NOTHING){
      img = null;
      soup = _menuUpdated.soup;
      meat = _menuUpdated.meat;
      fish = _menuUpdated.fish;
      vegetarian = _menuUpdated.vegetarian;
      desert = _menuUpdated.desert;
    }

    if(soupController.text != '' && soupController.text != ' '){
      soup = soupController.text;
    }

    if(meatController.text != '' && meatController.text != ' '){
      meat  = meatController.text;
    }

    if(fishController.text != '' && fishController.text != ' '){
      fish = fishController.text;
    }

    if(vegetarianController.text != '' && vegetarianController.text != ' '){
      vegetarian = vegetarianController.text;
    }

    if(desertController.text != '' && desertController.text != ' '){
      desert = desertController.text;
    }

    http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:8080/menu'),
      body: jsonEncode(
          {
            "img": img,
            "weekDay": _menu.weekDay.name.toString(),
            "soup": soup,
            "fish": fish,
            "meat": meat,
            "vegetarian": vegetarian,
            "desert": desert
          }
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Edit'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCard(),
              ElevatedButton(
                  onPressed: () => {
                    _postMenu(),
                    Navigator.of(context).pop(),
                  },
                  child: const Text('Submeter')
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard() => Container(
    child: Column(
      mainAxisSize: MainAxisSize.min, //TODO ver isto
      children: <Widget>[
        Row(
          children: <Widget>[
            Transform.translate(
              offset: const Offset(0, 0),
              child: _menu.img != null?
              Image.asset('images/${_menu.img!}',
                height: 100,
                width: 150,
                fit: BoxFit.fitWidth,
              )
                  : null,
            ),
            _menu.img != null?
            const SizedBox(width: 60,
            ): const SizedBox(width: 150),
            Text(_menu.weekDay.convert(_menu.weekDay), style: TextStyle(fontSize: 20),),
          ],
        ),
        const SizedBox(height: 20,),
        const Text(
          'SOPA:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        _menu.soup == _menuUpdated.soup || _menuUpdated.weekDay == WeekDay.NOTHING?
            original("SOPA") : updated("SOPA"),
        TextField(
          controller: soupController,
          decoration:
          const InputDecoration(border: InputBorder.none,
            icon: Icon(Icons.soup_kitchen),
            hintText: 'Insira para alterar a sopa'),
        ),
        const Text(
          'CARNE:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        _menu.meat == _menuUpdated.meat || _menuUpdated.weekDay == WeekDay.NOTHING?
          original("CARNE") : updated("CARNE"),
        TextField(
          controller: meatController,
          decoration:
          const InputDecoration(border: InputBorder.none,
              icon: Icon(Icons.set_meal),
              hintText: 'Insira para alterar a carne'),
        ),
        const SizedBox(height: 20,),
        const Text(
          'PEIXE:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        _menu.fish == _menuUpdated.fish || _menuUpdated.weekDay == WeekDay.NOTHING?
        original("PEIXE") : updated("PEIXE"),
        TextField(
          controller: fishController,
          decoration:
          const InputDecoration(border: InputBorder.none,
              icon: Icon(Icons.water),
              hintText: 'Insira para alterar a peixe'),
        ),
        const SizedBox(height: 20,),
        const Text(
          'VEGETARIANO:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        _menu.vegetarian == _menuUpdated.vegetarian || _menuUpdated.weekDay == WeekDay.NOTHING?
        original("VEGETARIANO") : updated("VEGETARIANO"),
        TextField(
          controller: vegetarianController,
          decoration:
          const InputDecoration(border: InputBorder.none,
              icon: Icon(Icons.energy_savings_leaf),
              hintText: 'Insira para alterar a vegetariano'),
        ),
        const SizedBox(height: 20,),
        const Text(
          'SOBREMESA:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),
        _menu.desert == _menuUpdated.desert || _menuUpdated.weekDay == WeekDay.NOTHING?
        original("SOBREMESA") : updated("SOBREMESA"),
        TextField(
          controller: desertController,
          decoration:
          const InputDecoration(border: InputBorder.none,
              icon: Icon(Icons.cookie),
              hintText: 'Insira para alterar a sobremesa'),
        ),

      ],
    ),
  );

  String readMeal(String meal, Menu aux){
    switch (meal){
      case "SOPA":{
        return aux.soup;
      }
      case "CARNE":{
        return aux.meat;
      }
      case "PEIXE":{
        return aux.fish;
      }
      case "VEGETARIANO":{
        return aux.vegetarian;
      }
      case "SOBREMESA":{
        return aux.desert;
      }
    }
    return "";
  }

  Widget original(String meal) => Column(
      children: [
        const Text('Informacao Original', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
        Text(
          readMeal(meal, _menu),
          style: const TextStyle(fontSize: 15),
        ),
      ],
  );
  Widget updated(String meal) => Column(

    children: [

      const Text('Informacao Original', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
      Text(
        readMeal(meal, _menu),
        style: const TextStyle(fontSize: 15),
      ),

      const SizedBox(height: 10,),

      const Text('Informacao Atualizada', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
      Text(
        '${readMeal(meal, _menuUpdated)}',
        style: const TextStyle(fontSize: 15),
      )
    ],
  );
}
