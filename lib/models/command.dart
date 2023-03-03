import 'package:flutter/material.dart';

typedef CommandRun = void Function(BuildContext context, String commandStr);

class Command {
  final String name;
  final RegExp regExp;
  final String description;
  final String tip;
  final String example;
  final CommandRun? run;

  Command(this.name, this.regExp, this.description, this.example, this.tip,
      {this.run});
}
