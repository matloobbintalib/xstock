import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xstock/config/routes/nav_router.dart';
import 'package:xstock/core/di/service_locator.dart';
import 'package:xstock/modules/authentication/pages/login_page.dart';
import 'package:xstock/modules/authentication/repository/user_account_repository.dart';
import 'package:xstock/ui/dialogs/dialogs.dart';
import 'package:xstock/ui/widgets/on_click.dart';
import 'package:xstock/ui/widgets/toast_loader.dart';
import 'package:xstock/utils/display/display_utils.dart';


/// Signature for [CustomSlidableAction.onPressed].
typedef SlidableActionCallback = void Function(BuildContext context);

const int _kFlex = 1;
const Color _kBackgroundColor = Colors.white;
const bool _kAutoClose = true;

/// Represents an action of an [ActionPane].
class CustomSlidableAction extends StatelessWidget {
  /// Creates a [CustomSlidableAction].
  ///
  /// The [flex], [backgroundColor], [autoClose] and [child] arguments must not
  /// be null.
  ///
  /// The [flex] argument must also be greater than 0.
  CustomSlidableAction({
    Key? key,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    required this.onPressed,
    required this.child,
  })  : assert(flex > 0),
        super(key: key);

  UserAccountRepository userAccountRepository = sl<UserAccountRepository>();

  /// {@template slidable.actions.flex}
  /// The flex factor to use for this child.
  ///
  /// The amount of space the child's can occupy in the main axis is
  /// determined by dividing the free space according to the flex factors of the
  /// other [CustomSlidableAction]s.
  /// {@endtemplate}
  final int flex;

  /// {@template slidable.actions.backgroundColor}
  /// The background color of this action.
  ///
  /// Defaults to [Colors.white].
  /// {@endtemplate}
  final Color backgroundColor;

  /// {@template slidable.actions.foregroundColor}
  /// The foreground color of this action.
  ///
  /// Defaults to [Colors.black] if [background]'s brightness is
  /// [Brightness.light], or to [Colors.white] if [background]'s brightness is
  /// [Brightness.dark].
  /// {@endtemplate}
  final Color? foregroundColor;

  /// {@template slidable.actions.autoClose}
  /// Whether the enclosing [Slidable] will be closed after [onPressed]
  /// occurred.
  /// {@endtemplate}
  final bool autoClose;

  /// {@template slidable.actions.onPressed}
  /// Called when the action is tapped or otherwise activated.
  ///
  /// If this callback is null, then the action will be disabled.
  /// {@endtemplate}
  final SlidableActionCallback? onPressed;

  /// {@template slidable.actions.borderRadius}
  /// The borderRadius of this action
  ///
  /// Defaults to [BorderRadius.zero].
  /// {@endtemplate}
  final BorderRadius borderRadius;

  /// {@template slidable.actions.padding}
  /// The padding of the OutlinedButton
  /// {@endtemplate}
  final EdgeInsets? padding;

  /// Typically the action's icon or label.
  final Widget child;

  Future<void> deleteUser(id, BuildContext context) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: id)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      return users.doc(querySnapshot.docs.first.id).delete().then((value) async {
        await FirebaseAuth.instance.signOut().then((value)async {
          await userAccountRepository.logout();
          ToastLoader.remove();
          DisplayUtils.showToast(context, 'User deleted successfully');
          NavRouter.pushAndRemoveUntil(
              context, LoginPage());
        }).onError((error, stackTrace) {
          ToastLoader.remove();
          DisplayUtils.showToast(context, error.toString());
        });
      }).catchError((error) {
        DisplayUtils.showErrorToast(context, 'Failed to Delete User');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnClick(
      onTap: () async {
        bool isLogged = await Dialogs.showDeleteAccountConfirmationDialog(context);
        if(isLogged){
          ToastLoader.show();
          deleteUser(userAccountRepository.getUserFromDb().user_id, context);
        }
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color:Colors.red,
          borderRadius: BorderRadius.circular(16)
        ),
        padding: EdgeInsets.all(18),
        child: child,
      ),
    );
  }

  void _handleTap(BuildContext context) {
    onPressed?.call(context);
    if (autoClose) {
      Slidable.of(context)?.close();
    }
  }
}

/// An action for [Slidable] which can show an icon, a label, or both.
class SlidableActionTest extends StatelessWidget {
  /// Creates a [SlidableActionTest].
  ///
  /// The [flex], [backgroundColor], [autoClose] and [spacing] arguments
  /// must not be null.
  ///
  /// You must set either an [icon] or a [label].
  ///
  /// The [flex] argument must also be greater than 0.
  const SlidableActionTest({
    Key? key,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    required this.onPressed,
    this.icon,
    this.spacing = 4,
    this.label,
    this.borderRadius = BorderRadius.zero,
    this.padding,
  })  : assert(flex > 0),
        assert(icon != null || label != null),
        super(key: key);

  /// {@macro slidable.actions.flex}
  final int flex;

  /// {@macro slidable.actions.backgroundColor}
  final Color backgroundColor;

  /// {@macro slidable.actions.foregroundColor}
  final Color? foregroundColor;

  /// {@macro slidable.actions.autoClose}
  final bool autoClose;

  /// {@macro slidable.actions.onPressed}
  final SlidableActionCallback? onPressed;

  /// An icon to display above the [label].
  final String? icon;

  /// The space between [icon] and [label] if both set.
  ///
  /// Defaults to 4.
  final double spacing;

  /// A label to display below the [icon].
  final String? label;

  /// Padding of the OutlinedButton
  final BorderRadius borderRadius;

  /// Padding of the OutlinedButton
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomSlidableAction(
        borderRadius: borderRadius,
        padding: padding,
        onPressed: onPressed,
        autoClose: autoClose,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        flex: flex,
        child: SvgPicture.asset(icon.toString(),height: 20,width: 20,),
      ),
    );
  }
}
