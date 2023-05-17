import 'dart:convert';
import 'dart:math';

import 'package:lzma/lzma.dart';

void main() {
//   Uint8List int32bytes(int value) => Uint8List(4)..buffer.asInt32List()[0] = value;
// // Uint8List.fromList(elements)

//   Uint8List int32BigEndianBytes(int value) =>
//       Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);
//   // getChar(0, split, value.split(''), 0, 3);
//   print(int32bytes(-2900));
//   ByteData byteData = ByteData(4);
//   // byteData.setInt32(0, 12345678); // an example byte data
//   // int intValue = byteData.getInt32(0);

//   byteData.setFloat32(0, 12.3455);
//   double doubleValue = byteData.getFloat32(0);

//   print(doubleValue);

//   String message = 'Hello, world!'; // an example string
//   List<int> byteDataString = utf8.encode(message);
//   print(byteDataString);

//   String messageDecoded = utf8.decode(byteDataString);
//   print(messageDecoded);
  var string =
      "Sure! Quantum computing is a fascinating field that uses the principles of quantum mechanics to perform calculations. In traditional computers, we use bits, which can represent either a 0 or a 1. But in quantum computers, we use quantum bits, or qubits, which can represent both 0 and 1 at the same time.";
  var data = utf8.encode(string);
  print("${data.length} uncompressed");
  final compressed = lzma.encode(data);
  print("${compressed.length} compressed");
  print(base64.encode(compressed));
  final decompressed = lzma.decode(compressed);
  var result = utf8.decode(decompressed);
  print(string == result);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String generateRandomString(int length) => String.fromCharCodes(
    Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
// getChar(int len, List<String> string, List<String> pattern, int startFrm, int max) {
//   if (max == len) {
//     print(string);
//     return;
//   }

//   List<String> tempList = [];

//   for (int i = startFrm; i < string.length; i++) {
//     for (var inner in pattern) {
//       tempList.add(string[i] + inner);
//     }
//   }
//   startFrm = string.length;
//   string.addAll(tempList);
//   getChar(len + 1, string, pattern, startFrm, max);
// }
