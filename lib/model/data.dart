class Menu{
  String? img;
  WeekDay weekDay;
  String soup;
  String meat;
  String fish;
  String vegetarian;
  String desert;


  Menu(this.img, this.weekDay, this.soup, this.meat, this.fish, this.vegetarian,
      this.desert);

  Menu.fromJson(Map<String, dynamic> json):
        img = json['img'],
        weekDay = WeekDay.values.byName(json['weekDay']),
        soup = json['soup'],
        meat = json['meat'],
        fish = json['fish'],
        vegetarian = json['vegetarian'],
        desert = json['desert'];
}


enum WeekDay{
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  NOTHING;

  static WeekDay getWeekbyIndex(int index){
    switch(index){
      case 0 : return WeekDay.MONDAY;
      case 1 : return WeekDay.TUESDAY;
      case 2 : return WeekDay.WEDNESDAY;
      case 3 : return WeekDay.THURSDAY;
      case 4 : return WeekDay.FRIDAY;
    }
    return WeekDay.NOTHING;
  }

  static int getIndexOnArray(List<Menu> aux, WeekDay weekDay){
    int i = 0;
    for(i = 0; i < aux.length; i++){
      if(aux[i].weekDay.name == weekDay.name){
        return i;
      }
    }
    return -1;
  }

  String convert(WeekDay weekDay){
    switch (weekDay){
      case WeekDay.MONDAY:{
        return "Segunda-Feira";
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
      case WeekDay.NOTHING:{
        return "Error";
      }
    }
  }

}


class EditArguments{
  final Menu menu;
  final Menu menuUpdated;

  EditArguments(this.menu, this.menuUpdated);
}