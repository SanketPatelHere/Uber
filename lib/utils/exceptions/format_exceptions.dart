///Custom exception class to handle various Firebase authentication related errors
class TFormatException implements Exception{
  ///the associate error message
  final String message;

  ///Default constructor with a generic error message
  const TFormatException([this.message="An unexpected format error occured. Please check your input."]);

  //getter,setter
  ///create a format exception from a specific error message.
  factory TFormatException.fromMessage(String message){
    return TFormatException(message);
  }

  ///Get the corresponding error message
  String get formattedMessage => message;

  ///create a format exception from a specific error code.
  factory TFormatException.fromCode(String code){
    switch (code) {
      case "invalid-email-format":
        return const TFormatException("The email address format is invalid. Please enter a valid email.");
      case "invalid-phone-number-format":
        return const TFormatException("The provided phone number is invalid. Please enter a valid email.");
      case "invalid-data-format":
        return const TFormatException("The provided data format is invalid. Please enter a valid data.");
      case "invalid-url-format":
        return const TFormatException("The provided url format is invalid. Please enter a valid url.");
      case "invalid-credit-card-format":
        return const TFormatException("The credit card format is invalid. Please enter a valid credit card number.");
      case "invalid-numeric-format":
        return const TFormatException("The input should be valid numeric format.");
      default:
        //return const TFormatException("An unexpected Firebase error occured. Please try again");
        return const TFormatException();
    }
  }

}