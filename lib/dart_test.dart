import 'dart:convert';
import 'dart:typed_data';

void main() {
  Uint8List int32bytes(int value) => Uint8List(4)..buffer.asInt32List()[0] = value;
// Uint8List.fromList(elements)

  Uint8List int32BigEndianBytes(int value) =>
      Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);
  // getChar(0, split, value.split(''), 0, 3);
  print(int32bytes(-2900));
  ByteData byteData = ByteData(4);
  // byteData.setInt32(0, 12345678); // an example byte data
  // int intValue = byteData.getInt32(0);

  byteData.setFloat32(0, 12.3455);
  double doubleValue = byteData.getFloat32(0);

  print(doubleValue);

  String message = 'Hello, world!'; // an example string
  List<int> byteDataString = utf8.encode(message);
  print(byteDataString);
   
  String messageDecoded = utf8.decode(byteDataString);
  print(messageDecoded);
}

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
