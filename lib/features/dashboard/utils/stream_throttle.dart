import 'dart:async';

extension StreamThrottle<T> on Stream<T> {
  Stream<T> throttle(Duration duration) {
    Timer? timer;
    StreamController<T>? controller;
    T? lastValue;
    bool hasValue = false;

    void emitValue() {
      if (hasValue && controller != null && !controller.isClosed) {
        controller.add(lastValue as T);
        hasValue = false;
      }
    }

    controller = StreamController<T>(
      onListen: () {
        listen(
          (data) {
            lastValue = data;
            hasValue = true;

            if (timer == null || !timer!.isActive) {
              emitValue();
              timer = Timer(duration, () {
                if (hasValue) emitValue();
              });
            }
          },
          onError: controller!.addError,
          onDone: controller.close,
        );
      },
      onCancel: () {
        timer?.cancel();
        controller?.close();
      },
    );

    return controller.stream;
  }
}
