import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:wbc_connect_app/core/api/api_consts.dart';

class EncryptionClientData {
  // Fixed initialization vector (IV) in Uint8List format
  final List<int> initializationVector = [
    83,
    71,
    26,
    58,
    54,
    35,
    22,
    11,
    83,
    71,
    26,
    58,
    54,
    35,
    22,
    11
  ];

  // Encryption key
  final String encKey = iiflEncKey;

  // Encrypt the given text
  String encryptText(String text) {
    try {
      // Create a Uint8List from the IV
      final iv = Uint8List.fromList(initializationVector);

      // Derive key using PBKDF2 (AES-256 key = 32 bytes + IV = 16 bytes)
      final keyGen = pbkdf2(
        utf8.encode(encKey) as Uint8List,
        iv,
        1000,
        48, // AES-256 Key (32 bytes) + IV (16 bytes)
      );

      // Split into AES key (32 bytes) and IV (16 bytes)
      final aesKey = keyGen.sublist(16); // First 32 bytes for AES key
      final aesIV = keyGen.sublist(0, 16); // First 16 bytes for IV

      // Initialize AES encryption with CBC mode and PKCS7 padding
      final key = encrypt.Key(Uint8List.fromList(aesKey));
      final ivSpec = encrypt.IV(Uint8List.fromList(aesIV));
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      // Encrypt the text
      final encrypted = encrypter.encrypt(text, iv: ivSpec);

      print("-----------------------${encrypted.base64}");

      // Return Base64 encrypted value
      return encrypted.base64;
    } catch (error) {
      print("$error - error in encrypt");
      return "";
    }
  }

  // PBKDF2 key derivation function
  Uint8List pbkdf2(
      Uint8List password, Uint8List salt, int iterations, int keyLength) {
    final hmac = Hmac(sha1, password); // HMAC-SHA1
    final key = Uint8List(keyLength);
    int blockCount = (keyLength / hmac.convert(salt).bytes.length).ceil();
    int derivedKeyIndex = 0;

    for (int i = 1; i <= blockCount; i++) {
      final t = hmac.convert(salt + _intToBytes(i)).bytes;
      List<int> u = t;

      for (int j = 1; j < iterations; j++) {
        u = hmac.convert(u).bytes;
        for (int k = 0; k < t.length; k++) {
          t[k] ^= u[k]; // XOR operation
        }
      }

      for (int l = 0; l < t.length && derivedKeyIndex < keyLength; l++) {
        key[derivedKeyIndex++] = t[l]; // Append to key
      }
    }

    return key;
  }

  // Convert an integer to a byte list (4 bytes)
  List<int> _intToBytes(int value) {
    return [
      (value >> 24) & 0xff,
      (value >> 16) & 0xff,
      (value >> 8) & 0xff,
      value & 0xff
    ];
  }
}
