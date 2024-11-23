///Custom exception class to handle various Firebase authentication related errors
class TPlatformException implements Exception{
  ///the error code associated with the exception
  final String code;

  ///Constructor that takes an error code.
  TPlatformException(this.code);

  //getter,setter
  ///Get the corresponding error message based on the error code.
  String get message {
    switch(code){
      case "INVALID-LOGIN-CREDENTIALS":
        return "Invalid login credentials. Please double check your information.";
      case "too-many-requests":
        return "Too many requests. Please try again later.";
      case "invalid-argument":
        return "Ivalid argument provided to the authenticated method.";
      case "invalid-password":
        return "The provided password is invalid.";
      case "invalid-phone-number":
        return "The provided phone number is invalid.";
      case "operation-not-allowed":
        return "The sign-in provider is disabled for your Firebase project.";
      case "session-cookie-expired":
        return "The Firebase session cookie has expired. Please sign in again.";
      case "uid-already-exists":
        return "The provided user ID is already in use by another user.";
      case "sign-in-failed":
        return "Sign in failed. Please try again.";
      case "netwrok-request-failed":
        return "Network request failed. Please check your internet connection.";
      case "internal-error":
        return "An internal error. Please try again later";

      default:
        return "An unexpected Firebase error occured. Please try again";

    }
  }

}