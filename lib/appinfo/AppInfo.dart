

import 'package:aaa/models/AddressModel.dart';
import 'package:flutter/cupertino.dart';

/*
ChangeNotifier = context to listen to the ChangeNotifier directly
provides change notification to its listeners
With ChangeNotifier, you have to manually notify listeners when data changes.
However, ValueNotifier automatically triggers a UI update as soon as a new value is assigned
 */


/*
Provider = a package and design pattern that helps manage an app's state
a widely used state management solution in Flutter applications.
It simplifies the process of managing and sharing state across different parts of the widget tree.

Provider = 	The most basic form of provider. It takes a value and exposes it, whatever the value is.
ListenableProvider 	A specific provider for Listenable object. ListenableProvider will listen to the object and ask widgets which depend on it to rebuild whenever the listener is called.
ChangeNotifierProvider 	A specification of ListenableProvider for ChangeNotifier. It will automatically call ChangeNotifier.dispose when needed.
ValueListenableProvider 	Listen to a ValueListenable and only expose ValueListenable.value.
StreamProvider 	Listen to a Stream and expose the latest value emitted.
FutureProvider 	Takes a Future and updates dependents when the future completes.
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