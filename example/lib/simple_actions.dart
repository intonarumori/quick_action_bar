import 'package:quick_action_bar/quick_action_bar.dart';

class SimpleAction extends QuickAction {
  String identifier;

  @override
  String title;
  @override
  bool isEnabled;

  SimpleAction(this.identifier, this.title, this.isEnabled);
}

class SimpleActionsDataSource extends QuickActionListDataSource<SimpleAction> {
  @override
  String placeholder = 'Type to search actions.';
  @override
  int selectedIndex = 0;

  @override
  String? message;

  @override
  List<SimpleAction> actions = [];
  final List<SimpleAction> _actions;

  String _query = '';

  SimpleActionsDataSource({required List<SimpleAction> actions}) : _actions = actions {
    setQuery('');
  }

  @override
  void setQuery(String query) {
    if (_query == query) return;
    _query = query;
    _updateList();
  }

  @override
  bool get hasQuery => _query != '';

  void _updateList() {
    if (_query == '') {
      actions = [];
    } else {
      actions = _actions
          .where((element) => element.title.toLowerCase().startsWith(_query.toLowerCase()))
          .toList()
        ..sort((a, b) => a.title.compareTo(b.title));
      selectedIndex = 0;
    }
    message = _query.isNotEmpty && actions.isEmpty ? 'No actions found.' : null;
    notifyListeners();
  }

  @override
  void advanceSelection(int offset) {
    if (actions.isEmpty) return;
    final newIndex = (selectedIndex + offset).clamp(0, actions.length - 1);
    if (selectedIndex != newIndex) {
      selectedIndex = newIndex;
      notifyListeners();
    }
  }

  @override
  SimpleAction? get currentAction => actions.isEmpty ? null : actions[selectedIndex];
}
