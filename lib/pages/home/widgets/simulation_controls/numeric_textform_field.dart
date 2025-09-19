import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumericTextFormField extends ConsumerWidget {
  NumericTextFormField({
    required this.initialValue,
    required this.onFieldSubmitted,

    super.key,
  }) : fieldController = TextEditingController(text: initialValue.toString());

  final num initialValue;
  final void Function(String) onFieldSubmitted;
  final TextEditingController fieldController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            final value = num.tryParse(fieldController.text);

            if (value == null) return;
            onFieldSubmitted((value - 1).toString());
          },
          icon: Icon(Icons.remove),
          iconSize: 18,
        ),
        SizedBox(
          height: 60,
          width: 90,
          child: TextFormField(
            controller: fieldController,
            textAlign: TextAlign.center,
            onEditingComplete: () {},
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              // isCollapsed: true, // supprime la hauteur/padding par défaut
              contentPadding: EdgeInsets.zero,
            ),
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
        IconButton(
          onPressed: () {
            final value = num.tryParse(fieldController.text);

            if (value == null) return;
            onFieldSubmitted((value + 1).toString());
          },
          icon: Icon(Icons.add),
          iconSize: 18,
        ),
      ],
    );
  }
}