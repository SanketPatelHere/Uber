

import 'package:aaa/models/AddressModel.dart';
import 'package:flutter/cupertino.dart';

/*
ChangeNotifier = context to listen to the ChangeNotifier directly
provides change notification to its listeners
With ChangeNotifier, you have to manually notify listeners when data changes.
However, ValueNotifier automatically triggers a UI update as soon as a new value is assigned
 */

class AppInfo extends ChangeNotifier{
    AddressModel? pickUpLocation;
    AddressModel? dropOffLocation;

    void updatePickUpLocation(AddressModel pickUpModel){
      pickUpLocation = pickUpModel;
      notifyListeners();
    }

    void updateDropOffLocation(AddressModel dropOffModel){
      dropOffLocation = dropOffModel;
      notifyListeners(); //for change direct in ui, when lat,long change
    }
}