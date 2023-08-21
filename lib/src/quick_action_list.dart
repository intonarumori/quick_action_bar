import 'package:flutter/material.dart';
import 'package:quick_action_bar/quick_action_bar.dart';

class QuickActionList extends StatefulWidget {
  final QuickActionListDataSource dataSource;
  final void Function(int index) onSelect;
  final QuickActionBarStyle? style;

  const QuickActionList({
    super.key,
    required this.dataSource,
    required this.onSelect,
    this.style,
  });

  @override
  State<QuickActionList> createState() => _QuickActionListState();
}

class _QuickActionListState extends State<QuickActionList> {
  @override
  void initState() {
    super.initState();
    widget.dataSource.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final style =
        widget.style ?? Theme.of(context).extension<QuickActionBarStyle>() ?? QuickActionBarStyle();

    if (widget.dataSource.actions.isEmpty) {
      if (widget.dataSource.message != null) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.dataSource.message!,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        );
      } else {
        return const SizedBox();
      }
    } else {
      return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final action = widget.dataSource.actions[index];
          final selected = index == widget.dataSource.selectedIndex;

          return Theme(
            data: ThemeData(
              textTheme: Theme.of(context).textTheme,
              disabledColor: style.disabledTextColor,
            ),
            child: ListTileTheme(
              selectedColor: style.textColor,
              textColor: style.textColor,
              child: ListTile(
                selected: selected,
                enabled: action.isEnabled,
                selectedTileColor: style.selectionBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                title: Text(action.title),
                onTap: () => widget.onSelect(index),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: widget.dataSource.actions.length,
      );
    }
  }
}
