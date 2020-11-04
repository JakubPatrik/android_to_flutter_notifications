import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'bloc.dart';

class BlocProvider<T extends Bloc> extends SingleChildStatelessWidget {
  final Widget child;

  final bool lazy;

  final Dispose<T> _dispose;

  final Create<T> _create;

  BlocProvider({
    Key key,
    @required T Function(BuildContext context) create,
    Widget child,
    bool lazy,
  }) : this._(
          key: key,
          create: create,
          dispose: (_, bloc) => bloc?.close(),
          child: child,
          lazy: lazy,
        );

  BlocProvider.value({
    Key key,
    @required T value,
    Widget child,
  }) : this._(
          key: key,
          create: (_) => value,
          child: child,
        );

  BlocProvider._({
    Key key,
    @required Create<T> create,
    Dispose<T> dispose,
    this.child,
    this.lazy,
  })  : _create = create,
        _dispose = dispose,
        super(
          key: key,
          child: child,
        );

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return InheritedProvider<T>(
      create: _create,
      dispose: _dispose,
      child: child,
      lazy: lazy,
    );
  }

  static T of<T extends Bloc>(BuildContext context) {
    return Provider.of<T>(
      context,
      listen: false,
    );
  }
}
