import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CursorData {
  late String name;
  late Uint8List buffer;
  late double hotX;
  late double hotY;
  late int width;
  late int height;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'buffer': buffer,
      'hotX': hotX,
      'hotY': hotY,
      'width': width,
      'height': height
    };
  }
}

/// The cursor manager
class CursorManager {
  static const channel = SystemChannels.mouseCursor;
  static const createCursorKey = "createCustomCursor";
  static const setCursorMethod = "setCustomCursor";
  static const deleteCursorMethod = "deleteCustomCursor";

  CursorManager._();
  static CursorManager instance = CursorManager._();

  /// [Note]
  /// The documentation from `engine/shell/platform/cursor_handler.cc`.
  ///
  /// // This method allows creating a custom cursor with rawBGRA buffer, returns a
  /// string to identify the cursor.
  ///
  /// static constexpr char kCreateCustomCursorMethod[] =
  ///     "createCustomCursor/windows";
  ///
  /// // A string, the custom cursor's name.
  ///
  /// static constexpr char kCustomCursorNameKey[] = "name";
  ///
  /// // A list of bytes, the custom cursor's rawBGRA buffer.
  ///
  /// static constexpr char kCustomCursorBufferKey[] = "buffer";
  ///
  /// // A double, the x coordinate of the custom cursor's hotspot, starting from
  /// left.
  ///
  /// static constexpr char kCustomCursorHotXKey[] = "hotX";
  ///
  /// // A double, the y coordinate of the custom cursor's hotspot, starting from top.
  ///
  /// static constexpr char kCustomCursorHotYKey[] = "hotY";
  ///
  /// // An int value for the width of the custom cursor.
  ///
  /// static constexpr char kCustomCursorWidthKey[] = "width";
  ///
  /// // An int value for the height of the custom cursor.
  ///
  /// static constexpr char kCustomCursorHeightKey[] = "height";
  ///
  /// // This method allows setting a custom cursor with a unique int64_t key of the
  /// custom cursor.
  ///
  /// static constexpr char kSetCustomCursorMethod[] = "setCustomCursor/windows";
  ///
  /// This method allows deleting a custom cursor with a string key.
  ///
  /// static constexpr char kDeleteCustomCursorMethod[] =
  ///     "deleteCustomCursor/windows";
  Future<String> registerCursor(CursorData data) async {
    if (kIsWeb) {
      ///TODO:: Will add code for web
      return data.name;
    }
    final cursorName = await _getMethodChannel()
        .invokeMethod<String>(_getMethod(createCursorKey), data.toJson());
    assert(cursorName == data.name);
    return cursorName!;
  }

  Future<void> deleteCursor(String name) async {
    if (kIsWeb) {
      ///TODO:: Will add code for web
      return;
    }
    await _getMethodChannel()
        .invokeMethod(_getMethod(deleteCursorMethod), {"name": name});
  }

  Future<void> setSystemCursor(String name) async {
    if (kIsWeb) {
      ///TODO:: Will add code for web
      return;
    }
    await _getMethodChannel()
        .invokeMethod(_getMethod(setCursorMethod), {"name": name});
  }

  MethodChannel _getMethodChannel() {
    if (Platform.isWindows) {
      return SystemChannels.mouseCursor;
    } else {
      return const MethodChannel('flutter_custom_cursor');
    }
  }

  String _getMethod(String method) {
    if (Platform.isWindows) {
      return "$method/windows";
    } else {
      return method;
    }
  }
}
