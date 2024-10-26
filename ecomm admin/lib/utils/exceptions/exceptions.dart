///Custom exception class to handle various Firebase authentication related errors
class TExceptions implements Exception{
  ///the error code associated with the exception
  final String code;

  ///Constructor that takes an error code.
  TExceptions(this.code);

  //getter,setter
  ///Get the corresponding error message based on the error code.
  String get message {
    switch(code){
      case "email-already-in-use":
        return "The email address is already registered. Please use a different email.";
      case "invalid-email":
        return "The email address provided is invalid. Please enter a valid email.";
      default:
        return "An unexpected Firebase error occured. Please try again";

    }
  }

}