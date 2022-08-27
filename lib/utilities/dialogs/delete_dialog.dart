import 'package:flutter/material.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
BuildContext context,
){
  return showGenericDialog<bool>(context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionsBuilder: ()=> {
      'Cancel': false,
      'YEs' : true,
    },
  ).then((value) => value ?? false ,);
  
  // );
}