

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssociateMethods
{
      showSnackBarMsg(String msg, BuildContext context)
      {
        var snackBar = SnackBar(content:Text(msg));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
}