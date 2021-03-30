import 'package:workspace/deviceModule/classes/cote.dart';

class Pied {
  String id;
  Cote cote;
  double temperature;
  int dimention;
  double rougeur;
  String etat;

  get getId => this.id;

  set setId(id) => this.id = id;

  get getCote => this.cote;

  set setCote(cote) => this.cote = cote;

  get getTemperature => this.temperature;

  set setTemperature(temperature) => this.temperature = temperature;

  get getDimention => this.dimention;

  set setDimention(dimention) => this.dimention = dimention;

  get getRougeur => this.rougeur;

  set setRougeur(rougeur) => this.rougeur = rougeur;

  get getEtat => this.etat;

  set setEtat(etat) => this.etat = etat;

  String toString() =>
      "   id=$id, cote=$cote, temperature=$temperature, dimention=$dimention, rougeur=$rougeur, etat=$rougeur";
}
