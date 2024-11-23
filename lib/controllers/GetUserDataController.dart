
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserDataController extends GetxController {
    final TAG = "Myy GetUserDataController ";

    ///static GetUserDataController get instance => Get.find();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    /*
    QuerySnapshot - contains one more QueryDocumentSnapshot
    QueryDocumentSnapshot
     */
    Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async{
      final QuerySnapshot userData = await _firestore.collection("Users").where("uId", isEqualTo: uId).get();
      return userData.docs;
    }


}