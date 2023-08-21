import 'package:flutter/material.dart';

abstract class QuickAction {
  String get title;
  bool get isEnabled;
}

abstract class QuickActionListDataSource<T extends QuickAction> extends ChangeNotifier {
  String get placeholder;
  List<T> get actions;
  int get selectedIndex;
  T? get currentAction;
  bool get hasQuery;

  String? get message;

  void setQuery(String query);
  void advanceSelection(int offset);
}
