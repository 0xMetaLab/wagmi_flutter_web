part of '../wagmi.js.dart';

/// Generic JSError
extension type JSError._(JSObject _) implements JSObject {}

/// Generic indexed DB/Javascript error.
extension JSErrorExt on JSError {
  /// Get the error message
  external String? get message;

  /// Get the error message
  external String? get name;

  external JSArray<JSString>? get metaMessages;
  external JSString? get shortMessage;
  external JSString? get version;
  external JSError? get cause;
  external JSString? get docsPath;

  WagmiError get toDart => WagmiError(
        message: message,
        name: WagmiErrors.values.firstWhere((value) => value.name == name),
        metaMessages: metaMessages?.toDart
            .map(
              (message) => message.toDart,
            )
            .toList(),
        shortMessage: shortMessage?.toDart,
        version: version?.toDart,
        cause: cause?.toDart,
        docsPath: docsPath?.toDart,
        details: toMap(),
      );
}
