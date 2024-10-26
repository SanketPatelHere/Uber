///Custom exception class to handle various Firebase authentication related errors
class TFirebaseAuthException implements Exception{
  ///the error code associated with the exception
  final String code;

  ///Constructor that takes an error code.
  TFirebaseAuthException(this.code);

  //getter,setter
  ///Get the corresponding error message based on the error code.
  String get message {
    switch(code){
      case "invalid-email":
        return "The email address provided is invalid. Please enter a valid email.";
      case "email-already-in-use":
        return "The email address is already registered. Please use a different email.";
      case "wrong-password":
        return "Incorrect password. Please check your password and try again.";
      case "weak-password":
        return "The password is too weak. Please choose a stronger password.";
      case "invalid-credential":
        return "The supplied credentail is malformed or expired";
      case "invalid-verification-code":
        return "Invalid verification code. please enter a valid code.";
      case "invalid-verification-id":
        return "Invalid verification ID. please request a new verification code.";
      case "provider-already-linked":
        return "The account is already linked with other provider.";
      case "requires-recent-login":
        return "This operation is sensitive and require recent authentication. Please log in again";
      case "operation-not-allowed":
        return "The operation is not allowed. Please contact support for assistance";
      case "captcha-checked-failed":
        return "The reCaptcha response is invalid. Please try again.";
      case "app-not-authorized":
        return "The app is not authorized to use firebase authentication with the provided key.";
      case "keychain-error":
        return "A keychain error occured. Please check the keychain and try again";
      case "internal-error":
        return "An internal authentication error occured. Please try again later";


      default:
        return "An unexpected Firebase error occured. Please try again";

    }
  }

}