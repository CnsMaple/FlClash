import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/scaffold.dart';
import 'package:flutter/material.dart';

import 'side_sheet.dart';

@immutable
class SheetProps {
  final double maxWidth;
  final double maxHeight;
  final bool isScrollControlled;
  final bool useSafeArea;
  final bool blur;

  const SheetProps({
    this.maxWidth = 300,
    this.maxHeight = 400,
    this.useSafeArea = true,
    this.isScrollControlled = false,
    this.blur = true,
  });
}

@immutable
class ExtendProps {
  final double maxWidth;
  final bool useSafeArea;
  final bool blur;

  const ExtendProps({
    this.maxWidth = 300,
    this.useSafeArea = true,
    this.blur = true,
  });
}

Future<T?> showSheet<T>({
  required BuildContext context,
  required Widget body,
  required String title,
  Widget? action,
  SheetProps props = const SheetProps(),
}) {
  final isMobile = globalState.appState.viewMode == ViewMode.mobile;
  return switch (isMobile) {
    true => showModalBottomSheet<T>(
        context: context,
        isScrollControlled: props.isScrollControlled,
        constraints: BoxConstraints(
          maxHeight: props.maxHeight,
        ),
        builder: (_) {
          return body;
        },
        showDragHandle: true,
        useSafeArea: props.useSafeArea,
      ),
    false => showModalSideSheet<T>(
        useSafeArea: props.useSafeArea,
        isScrollControlled: props.isScrollControlled,
        context: context,
        constraints: BoxConstraints(
          maxWidth: props.maxWidth,
        ),
        filter: props.blur ? filter : null,
        builder: (context) {
          return CommonScaffold(
            automaticallyImplyLeading: action == null ? false : true,
            centerTitle: false,
            body: body,
            title: title,
            actions: [action ?? CloseButton()],
          );
        },
      ),
  };
}

Future<T?> showExtend<T>(
  BuildContext context, {
  required Widget body,
  ExtendProps props = const ExtendProps(),
  required String title,
  Widget? action,
}) {
  final isMobile = globalState.appState.viewMode == ViewMode.mobile;
  return switch (isMobile) {
    true => BaseNavigator.push(
        context,
        CommonScaffold(
          body: body,
          title: title,
          actions: [
            if (action != null) action,
          ],
        ),
      ),
    false => showModalSideSheet<T>(
        useSafeArea: props.useSafeArea,
        context: context,
        constraints: BoxConstraints(
          maxWidth: props.maxWidth,
        ),
        filter: props.blur ? filter : null,
        builder: (context) {
          return CommonScaffold(
            automaticallyImplyLeading: action == null ? false : true,
            centerTitle: false,
            body: body,
            title: title,
            actions: [action ?? CloseButton()],
          );
        },
      ),
  };
}
