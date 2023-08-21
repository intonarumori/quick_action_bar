import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_action_bar/quick_action_bar.dart';
import 'package:quick_action_bar/src/quick_action_list.dart';

void presentQuickActionBar<Action extends QuickAction>({
  required BuildContext context,
  required QuickActionListDataSource<Action> dataSource,
  required void Function(BuildContext context, Action action) onActionSelected,
}) {
  showDialog<String>(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        alignment: Alignment.topCenter,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        insetPadding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
        child: QuickActionBar<Action>(
          dataSource: dataSource,
          onSelect: (action) {
            onActionSelected(context, action);
          },
        ),
      );
    },
  );
}

void dismissQuickActionBar(BuildContext context) {
  Navigator.of(context).pop();
}

class QuickActionBar<Action extends QuickAction> extends StatefulWidget {
  final QuickActionListDataSource<Action> dataSource;
  final void Function(Action action) onSelect;
  final QuickActionBarStyle? style;

  const QuickActionBar({
    super.key,
    required this.dataSource,
    required this.onSelect,
    this.style,
  });

  @override
  State<QuickActionBar<Action>> createState() => _QuickActionBarState<Action>();
}

class _QuickActionBarState<T extends QuickAction> extends State<QuickActionBar<T>> {
  final _controller = TextEditingController();
  final _rawFocusNode = FocusNode(onKey: (FocusNode node, RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  });
  final _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      _filterList();
    });
    _filterList();
  }

  @override
  void dispose() {
    super.dispose();
    _rawFocusNode.dispose();
    _textFocusNode.dispose();
  }

  void _filterList() {
    final query = _controller.text;
    widget.dataSource.setQuery(query);
  }

  void _selectCurrent() {
    final action = widget.dataSource.currentAction;
    if (action != null && action.isEnabled) {
      widget.onSelect.call(action);
    } else {
      _textFocusNode.requestFocus();
    }
  }

  void _advanceSelection(int offset) {
    widget.dataSource.advanceSelection(offset);
  }

  void _handleKey(RawKeyEvent key) {
    if (key is RawKeyDownEvent) {
      switch (key.logicalKey) {
        case LogicalKeyboardKey.arrowDown:
          _advanceSelection(1);
          break;
        case LogicalKeyboardKey.arrowUp:
          _advanceSelection(-1);

          break;
        case LogicalKeyboardKey.enter:
          _selectCurrent();
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawKeyboardListener(
              focusNode: _rawFocusNode,
              key: UniqueKey(),
              onKey: _handleKey,
              child: TextField(
                key: UniqueKey(),
                focusNode: _textFocusNode,
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 12, bottom: 8, top: 8, right: 12),
                  hintText: widget.dataSource.placeholder,
                ),
              ),
            ),
            Flexible(
              child: QuickActionList(
                dataSource: widget.dataSource,
                onSelect: (_) => _selectCurrent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
