import 'dart:async';
import 'dart:io';

String errorMessage(Object error) {
  if (error is SocketException) {
    return 'Sense connexió a internet.';
  }
  if (error is TimeoutException) {
    return 'Temps d\'espera esgotat.';
  }
  if (error is HttpException) {
    return 'Error del servidor.';
  }
  final text = error.toString();
  final match = RegExp(r'\((\d{3})\)').firstMatch(text);
  if (match != null) {
    final code = int.parse(match.group(1)!);
    if (code == 404) {
      return 'No s\'ha trobat el recurs ($code).';
    }
    if (code >= 400 && code < 500) {
      return 'Sol·licitud no vàlida ($code).';
    }
    if (code >= 500) {
      return 'Error del servidor ($code).';
    }
  }
  return 'Hi ha hagut un error. Torna-ho a provar.';
}