import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static String theMovieDbTokenKey = dotenv.env['THE_MOVIEDB_TOKEN_KEY'] ?? 'No hay api key';


}