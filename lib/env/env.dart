// env/env.dart

import 'package:envify/envify.dart';

part 'env.g.dart';

@Envify()
abstract class Env {
  static const appSecretKey = _Env.appSecretKey;
  static const jwtSecret = _Env.jwtSecret;
}
