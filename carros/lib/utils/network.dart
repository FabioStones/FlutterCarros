import 'package:connectivity/connectivity.dart';

Future<bool> isNetworkOn() async {
  return !(await Connectivity().checkConnectivity() == ConnectivityResult.none);
}
