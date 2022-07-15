import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';

class WindowScaffold extends StatelessWidget {
  const WindowScaffold({Key? key, this.body, this.background}) : super(key: key);

  final Widget? body;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: background ?? Container()),
        Positioned.fill(
          child: Column(
            children: [
              WindowTitleBarBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: _CustomMoveWindow()),
                    Row(
                      children: [
                        MinimizeWindowButton(),
                        MaximizeWindowButton(),
                        CloseWindowButton(),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: body ?? Container()),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomMoveWindow extends StatelessWidget {
  const _CustomMoveWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) => appWindow.startDragging(),
    );
  }
}
