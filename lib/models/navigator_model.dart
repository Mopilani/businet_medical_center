import 'package:businet_medical_center/views/home_page.dart';
import 'package:businet_medical_center/views/mangment_views/bills/bills_control.dart';
import 'package:businet_medical_center/views/mangment_views/bills/bills_view.dart';
import 'package:businet_medical_center/views/mangment_views/stocks_views/stocks_control.dart';
import 'package:businet_medical_center/views/mangment_views/stocks_views/stocks_view.dart';
import 'package:businet_medical_center/views/mangment_views/suppliers_views/suppliers_control.dart';
import 'package:businet_medical_center/views/mangment_views/suppliers_views/suppliers_view.dart';
import 'package:businet_medical_center/views/settings/costumers_views/costumer_control.dart';
import 'package:businet_medical_center/views/settings/costumers_views/costumers_view.dart';
import 'package:businet_medical_center/views/settings/payment_methods_views/payment_method_control.dart';
import 'package:businet_medical_center/views/settings/payment_methods_views/payment_methods_view.dart';
import 'package:businet_medical_center/views/users_views/users_control.dart';
import 'package:businet_medical_center/views/users_views/users_view.dart';
import 'package:businet_medical_center/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';

import '../views/settings/center_settings.dart';
import 'system_config.dart';
import 'user_model.dart';

Map<String, SystemRouteModel> systemRoutes = {
  'WelcomeScreen': SystemRouteModel(
      'KDEWelcomeScreenYaMKNA', 0, 'WelcomeScreen',
      runtimeType0: WelcomeScreen),
  'HomePage': SystemRouteModel('KDEHomePageYaMKNA', 0, 'HomePage',
      runtimeType0: HomePage),
  'UsersControle': SystemRouteModel(
      'KDEUsersControleYaMKNA', 0, 'UsersControle',
      runtimeType0: UsersControle),
  'UsersView': SystemRouteModel('KDEUsersViewYaMKNA', 0, 'UsersView',
      runtimeType0: UsersView),
  'SuppliersView': SystemRouteModel(
      'KDESuppliersViewYaMKNA', 0, 'SuppliersView',
      runtimeType0: SuppliersView),
  'SuppliersControle': SystemRouteModel(
      'KDESuppliersControleYaMKNA', 0, 'SuppliersControle',
      runtimeType0: SuppliersControle),
  'BillsView': SystemRouteModel('KDEBillsViewYaMKNA', 0, 'BillsView',
      runtimeType0: BillsView),
  'BillsControle': SystemRouteModel(
      'KDEBillsControleYaMKNA', 0, 'BillsControle',
      runtimeType0: BillsControle),
  'StocksView': SystemRouteModel('KDEStocksViewYaMKNA', 0, 'StocksView',
      runtimeType0: StocksView),
  'StocksControle': SystemRouteModel(
      'KDEStocksControleYaMKNA', 0, 'StocksControle',
      runtimeType0: StocksControle),
  'PaymentMethodsView': SystemRouteModel(
      'KDEStocksControleYaMKNA', 0, 'PaymentMethodsView',
      runtimeType0: PaymentMethodsView),
  'PaymentMethodControle': SystemRouteModel(
      'KDEStocksControleYaMKNA', 0, 'PaymentMethodControle',
      runtimeType0: PaymentMethodControle),
  'CostumersView': SystemRouteModel(
      'KDEStocksControleYaMKNA', 0, 'CostumersView',
      runtimeType0: CostumersView),
  'CostumerControle': SystemRouteModel(
      'KDECostumerControleYaMKNA', 0, 'CostumerControle',
      runtimeType0: CostumerControle),
  'CenterSettings': SystemRouteModel(
      'KDECostumerControleYaMKNA', 0, 'CenterSettings',
      runtimeType0: CenterSettings),
};

class SysNav {
  SysNav() {
    // systemRoutes.addAll({});
  }

  static SystemRouteModel? look(Type type) {
    return systemRoutes[type];
  }

  static UserModel registerRoutesForUser(
      UserModel user, List<Type> routesTypes) {
    for (var type in routesTypes) {
      if (systemRoutes[type.toString()] == null) {
        throw 'Unregistered System Route';
      }
      user.accessLevelModel!.allowedLevels.addAll(
        systemRoutes[type.toString()]!.toMap(),
      );
    }
    return user;
  }

  static Future<T?> push<T>(BuildContext context, Widget routeWidget) async {
    var route = systemRoutes[routeWidget.runtimeType.toString()];
    if (route == null) {
      throw Exception(
        'Unexpected routeWidget runtime type'
        ' ${routeWidget.runtimeType.toString()} \n'
        'The route has not been registered',
      );
    }
    route.routeWidget = routeWidget;
    // print(UserModel.stored!.toMap());
    // print(routeWidget.runtimeType);
    // print(allowedLevels.containsKey('SalesPage'));
    // print('444 =========== $allowedLevels');
    // print('444 =========== ${allowedLevels[routeWidget.runtimeType.toString()]}');
    Map<String, dynamic> allowedLevels =
        UserModel.stored!.accessLevelModel!.allowedLevels;
    var systemRouteData = allowedLevels[routeWidget.runtimeType.toString()];
    if (systemRouteData == null) {
      // toast('Route No Found For You');
      toast('Perm Denied Er:1');
      return null;
    }
    SystemRouteModel level = SystemRouteModel.fromMap(systemRouteData);
    if (level.neededAccessToken == route.neededAccessToken) {
      return await Navigator.push<T>(
        context,
        SystemConfig().pageRoute == 'CupertinoPageRoute'
            ? CupertinoPageRoute(
                builder: (context) => route.routeWidget!,
              )
            : MaterialPageRoute(
                builder: (context) => route.routeWidget!,
              ),
      );
    } else {
      toast('Perm Denied');
    }
    return null;
  }

  static void pop<T>(BuildContext context, [T? result]) {
    return Navigator.pop<T>(context, result);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget routeWidget, {
    TO? result,
  }) async {
    var route = systemRoutes[routeWidget.runtimeType.toString()];
    if (route == null) {
      throw Exception(
        'Unexpected routeWidget runtime type'
        ' ${routeWidget.runtimeType.toString()} \n'
        'The route has not been registered',
      );
    }
    route.routeWidget = routeWidget;
    Map<String, dynamic> allowedLevels =
        UserModel.stored!.accessLevelModel!.allowedLevels;
    var systemRouteData = allowedLevels[routeWidget.runtimeType.toString()];
    if (systemRouteData == null) {
      toast('Perm Denied Er:1');
      return null;
    }
    SystemRouteModel level = SystemRouteModel.fromMap(systemRouteData);
    if (level.neededAccessToken == route.neededAccessToken) {
      return await Navigator.pushReplacement<T, TO>(
        context,
        SystemConfig().pageRoute == 'CupertinoPageRoute'
            ? CupertinoPageRoute(
                builder: (context) => route.routeWidget!,
              )
            : MaterialPageRoute(
                builder: (context) => route.routeWidget!,
              ),
      );
    } else {
      toast('Perm Denied');
    }
    return null;
  }

  // static mainDrawerNavigator(
  //   PageController scrollCont,
  //   PageController sideBarScrollCont,
  //   DrawerItem item,
  //   DrawerItemWidget itemWidget,
  // ) {
  //   bool typeNameFound = false;
  //   SystemRouteModel? route;
  //   for (var value in systemRoutes.values) {
  //     if (drawerItems[item.index].widgetRuntimeType.toString() ==
  //         value.runtimeTypeName) {
  //       typeNameFound = true;
  //       route = value;
  //     }
  //   }
  //   if (!typeNameFound) {
  //     throw (Exception(
  //       'Unexpected routeWidget runtime type'
  //       ' ${drawerItems[item.index].title.runtimeType.toString()} \n'
  //       'The route has not been registered',
  //     ));
  //   }
  //   Map<String, dynamic> allowedLevels =
  //       UserModel.stored!.accessLevelModel!.allowedLevels;
  //   var systemRouteData =
  //       allowedLevels[drawerItems[item.index].widgetRuntimeType.toString()];
  //   if (systemRouteData == null) {
  //     toast('Perm Denied Er:1');
  //     return null;
  //   }
  //   SystemRouteModel level = SystemRouteModel.fromMap(systemRouteData);
  //   if (level.neededAccessToken == route!.neededAccessToken) {
  //     if (SystemConfig().animations) {
  //       scrollCont.animateToPage(
  //         item.index,
  //         duration: const Duration(milliseconds: 200),
  //         curve: Curves.easeIn,
  //       );
  //       sideBarScrollCont.animateToPage(
  //         item.index,
  //         duration: const Duration(milliseconds: 200),
  //         curve: Curves.easeIn,
  //       );
  //     } else {
  //       scrollCont.jumpToPage(
  //         item.index,
  //       );
  //       sideBarScrollCont.jumpToPage(
  //         item.index,
  //       );
  //     }
  //     currentIndex = item.index;
  //     currentSideBarIndex = item.index;
  //     DrawerItemsUpdater().add([
  //       item.index,
  //     ]);
  //   }
  // }

  static Future<T?> pushAndRemoveUntil<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget routeWidget, {
    TO? result,
    bool eznNeeded = true,
  }) async {
    var route = systemRoutes[routeWidget.runtimeType.toString()];
    if (route == null) {
      throw Exception(
        'Unexpected routeWidget runtime type'
        ' ${routeWidget.runtimeType.toString()} \n'
        'The route has not been registered',
      );
    }
    route.routeWidget = routeWidget;
    if (!eznNeeded) {
      return await Navigator.pushAndRemoveUntil<T>(
        context,
        SystemConfig().pageRoute == 'CupertinoPageRoute'
            ? CupertinoPageRoute(
                builder: (context) => route.routeWidget!,
              )
            : MaterialPageRoute(
                builder: (context) => route.routeWidget!,
              ),
        (route) => false,
      );
    }
    Map<String, dynamic> allowedLevels =
        UserModel.stored!.accessLevelModel!.allowedLevels;
    var systemRouteData = allowedLevels[routeWidget.runtimeType.toString()];
    if (systemRouteData == null) {
      toast('Perm Denied Er:1');
      return null;
    }
    SystemRouteModel level = SystemRouteModel.fromMap(systemRouteData);
    if (level.neededAccessToken == route.neededAccessToken) {
      return await Navigator.pushAndRemoveUntil<T>(
        context,
        SystemConfig().pageRoute == 'CupertinoPageRoute'
            ? CupertinoPageRoute(
                builder: (context) => route.routeWidget!,
              )
            : MaterialPageRoute(
                builder: (context) => route.routeWidget!,
              ),
        (route) => false,
      );
    } else {
      toast('Perm Denied');
    }
    return null;
  }
}

class SystemRouteModel {
  SystemRouteModel(
    this.neededAccessToken,
    this.neededAccessLevelNumber,
    this.runtimeTypeName, {
    this.routeWidget,
    required this.runtimeType0,
  });
  late String neededAccessToken;
  late int neededAccessLevelNumber;
  late Widget? routeWidget;
  late String runtimeTypeName;

  late Type? runtimeType0;

  Map<String, dynamic> toMap() => {
        runtimeTypeName: {
          'neededAccessToken': neededAccessToken,
          'neededAccessLevelNumber': neededAccessLevelNumber,
          'runtimeTypeName': runtimeTypeName,
          // 'runtimeType': runtimeType,
        }
      };

  static fromMap(Map<String, dynamic> data) => SystemRouteModel(
        data['neededAccessToken'],
        data['neededAccessLevelNumber'],
        data['runtimeTypeName'],
        runtimeType0: null,
      );
}
