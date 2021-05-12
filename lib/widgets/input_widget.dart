import 'package:flutter/material.dart';
import 'package:flutter_mqtt_exam/models/models.dart';
import 'package:provider/provider.dart';

class InputWidget extends StatelessWidget {
  InputWidget({
    Key? key,
    required this.formKey,
    this.inputTypes,
    this.focusNodes,
    this.textController,
    this.titles,
  }) : super(key: key);

  final List<String>? titles;

  final GlobalKey<FormState> formKey;

  final List<TextInputType>? inputTypes;

  final List<FocusNode>? focusNodes;

  final List<TextEditingController>? textController;

  bool visibility = true;

  Widget buildInput(BuildContext context, String title, int index) {
    final input = Provider.of<InputModel>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        obscureText: inputTypes![index] == TextInputType.visiblePassword
            ? input.visibility
            : false,
        validator: (input) => input!.isEmpty ? 'Can not be null' : null,
        controller: textController![index],
        keyboardType: inputTypes![index],
        autofocus: true,
        focusNode: focusNodes![index],
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(
            inputTypes![index] == TextInputType.visiblePassword
                ? Icons.lock
                : Icons.person,
            color: Colors.red,
          ),
          suffixIcon: inputTypes![index] == TextInputType.visiblePassword
              ? IconButton(
                  icon: Icon(
                    input.visibility ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => input.setVisibility(),
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * .8,
      child: Form(
        key: formKey,
        child: Column(
          children: titles!
              .map(
                  (title) => buildInput(context, title, titles!.indexOf(title)))
              .toList(),
        ),
      ),
    );
  }
}
