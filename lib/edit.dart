import 'package:amov_tp2/main.dart';
import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  static const String routeName = '/edit';

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late final Menu _menu = ModalRoute.of(context)!.settings.arguments as Menu;
  TextEditingController soupController = TextEditingController();
  TextEditingController meatController = TextEditingController();
  TextEditingController fishController = TextEditingController();
  TextEditingController vegetarianController = TextEditingController();
  TextEditingController desertController = TextEditingController();


  void setMenu(){
    if(soupController.text != '' && soupController.text != ' '){
      _menu.soup = soupController.text;
    }

    if(meatController.text != '' && meatController.text != ' '){
      _menu.meat = meatController.text;
    }

    if(fishController.text != '' && fishController.text != ' '){
      _menu.fish = fishController.text;
    }

    if(vegetarianController.text != '' && vegetarianController.text != ' '){
      _menu.vegetarian = vegetarianController.text;
    }

    if(desertController.text != '' && desertController.text != ' '){
      _menu.desert = desertController.text;
    }
    //TODO em vez de guardar localmente realizar um metodo post
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
              const Text('Informacao Original', style: TextStyle(fontSize: 20),),
              buildCard(),
              ElevatedButton(
                  onPressed: () => {
                    setMenu(),
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
        Text(
          'SOPA: ${_menu.soup}',
          style: const TextStyle(fontSize: 15),
        ),
        TextField(
          controller: soupController,
          decoration:
          const InputDecoration(border: InputBorder.none,
            icon: Icon(Icons.soup_kitchen),
            hintText: 'Insira para alterar a sopa'),
        ),
        const SizedBox(height: 20,),
        Text(
          'CARNE: ${_menu.meat}',
          style: const TextStyle(fontSize: 15),
        ),
        TextField(
          controller: meatController,
          decoration:
          const InputDecoration(border: InputBorder.none,
              icon: Icon(Icons.set_meal),
              hintText: 'Insira para alterar a carne'),
        ),
        const SizedBox(height: 20,),
        Text(
          'PEIXE: ${_menu.fish}',
          style: const TextStyle(fontSize: 15),
        ),
        TextField(
          controller: fishController,
          decoration:
          const InputDecoration(border: InputBorder.none,
              icon: Icon(Icons.water),
              hintText: 'Insira para alterar a peixe'),
        ),
        const SizedBox(height: 20,),
        Text(
          'VEGETARIANO: ${_menu.vegetarian}',
          style: const TextStyle(fontSize: 15),
        ),
        TextField(
          controller: vegetarianController,
          decoration:
          const InputDecoration(border: InputBorder.none,
              icon: Icon(Icons.energy_savings_leaf),
              hintText: 'Insira para alterar a vegetariano'),
        ),
        const SizedBox(height: 20,),
        Text(
          'Sobremesa: ${_menu.desert}',
          style: const TextStyle(fontSize: 15),
        ),
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

}
