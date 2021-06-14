import 'package:flutter/material.dart';

class WidgetInputDialog extends StatefulWidget {
  final Function saveName;
  final TextEditingController nameController;
  final String name;
  final Color iconColorDeep;
  final Color placeHolderBorderColor;
  final Color placeHolderBgColor;

  WidgetInputDialog(
    this.nameController,
    this.name,
    this.iconColorDeep,
    this.placeHolderBorderColor,
    this.placeHolderBgColor,
    this.saveName,
  );

  @override
  _WidgetInputDialogState createState() => _WidgetInputDialogState();
}

class _WidgetInputDialogState extends State<WidgetInputDialog> {
  final _formKey = new GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.nameController.text = widget.name;
    widget.nameController.selection =
        TextSelection.collapsed(offset: widget.name.length);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      content: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    maxLength: 8,
                    controller: widget.nameController,
                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8),
                        ),
                        borderSide: BorderSide(color: widget.iconColorDeep),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8),
                        ),
                        borderSide:
                            BorderSide(color: widget.placeHolderBorderColor),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.2,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8),
                        ),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8),
                        ),
                        borderSide: BorderSide(color: Colors.red),
                      ),

                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  MaterialButton(
                    elevation: 0.0,
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: widget.iconColorDeep,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    color: widget.placeHolderBgColor,
                    onPressed: () => {
                      if (_formKey.currentState.validate())
                        {
                          widget.saveName(widget.nameController.text),
                          Navigator.pop(context)
                        }
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(
                        8,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String commonValidation(String value) {
    var required = requiredValidator(value);
    if (required != null) {
      return required;
    }
    return null;
  }

  String requiredValidator(value) {
    if (value.isEmpty) {
      return "This field is required";
    }
    return null;
  }
}
