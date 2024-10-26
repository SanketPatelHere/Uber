import 'package:logger/logger.dart';

//class TLocalStorage {
class TLoggerHelper {
  static final TAG = "Myy TLoggerHelper ";

    static final Logger _logger = Logger(
      printer: PrettyPrinter(),
      //customize the log levels based on your needs
      level: Level.debug,
    );


    static void debug(String message){
      _logger.d(message);
    }

    static void info(String message){
      //_logger.i(message);
      _logger.i("Myy $message");

      /*if(kReleaseMode){
        //for hide all log in only release mode
        print('${TAG} release mode');
      } else {
        //for show all log in only debug mode
        print('${TAG} debug mode');
        _logger.i("Myy $message");
      }*/

    }

    static void warning(String message){
      _logger.w(message);
    }

    static void error(String message, [dynamic error]){
      _logger.e(message, error: error, stackTrace: StackTrace.current);
    }
}