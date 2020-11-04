import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<E, S> extends Stream<S> implements EventSink<E> {
  StreamSubscription _streamSubscription;
  final BehaviorSubject<S> _stateSubject = BehaviorSubject<S>();
  final BehaviorSubject<E> _eventSubject = BehaviorSubject<E>();

  S _state;

  S get state => _state;

  @override
  bool get isBroadcast => _stateSubject.isBroadcast;

  Bloc() {
    _streamSubscription = _eventSubject.asyncExpand(mapEventToState).listen(
      (state) {
        _stateSubject.add(state);
        _state = state;
      },
    );
  }

  Stream<S> mapEventToState(E event) async* {}

  @override
  void add(E event) {
    if (_eventSubject.isClosed) {
      return;
    }
    _eventSubject.add(event);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {}

  @override
  @mustCallSuper
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await _eventSubject.close();
    await _stateSubject.close();
  }

  @override
  StreamSubscription<S> listen(
    void Function(S event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    return _stateSubject.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
