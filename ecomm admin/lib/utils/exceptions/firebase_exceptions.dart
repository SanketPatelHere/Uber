///Custom exception class to handle various Firebase authentication related errors
class TFirebaseException implements Exception{
  ///the error code associated with the exception
  final String code;

  ///Constructor that takes an error code.
  TFirebaseException(this.code);

  //getter,setter
  ///Get the corresponding error message based on the error code.
  String get message {
    switch(code){
      case "unknown":
        return "An unknown firebase error occured. Please try again.";
      case "invalid-custom-token":
        return "The custom token format is invalid. Please check your custom domain.";
      case "custom-token-mismatch":
        return "The custom token corresponds to a different audience.";
      case "user-disabled":
        return "the user account has been disabled";
      case "user-not-found":
        return "No user found for the given email or UID";
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

      case "missing-action-code":
        return "The action code is missing. Please provide a valid action code.";
      case "user-token-expired":
        return "The user\'s token has expired, and authentication is required. Please sign in again";
      case "INVALID-LOGIN-CREDENTIALS":
        return "Invalid login credentials";
      case "expired-action-code":
        return "The action code has expired. Please request a new action code.";
      case "invalid-action-code":
        return "The action code is invalid. Please check the code and try again.";
      case "credential-already-in-use":
        return "The credential is already associated with a different user account.";

      default:
        return "An unexpected Firebase error occured. Please try again";

    }
  }

}