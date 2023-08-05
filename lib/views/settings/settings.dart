import 'package:businet_medical_center/models/settings_item.dart';
import 'package:businet_medical_center/views/mangment_views/bills/bills_control.dart';
import 'package:businet_medical_center/views/mangment_views/bills/bills_view.dart';
import 'package:businet_medical_center/views/mangment_views/stocks_views/stocks_view.dart';
import 'package:businet_medical_center/views/mangment_views/suppliers_views/suppliers_view.dart';
import 'package:businet_medical_center/views/settings/general_settings.dart';
import 'package:businet_medical_center/views/settings/language_settings.dart';
import 'package:businet_medical_center/views/settings/settings_item_widget.dart';
import 'package:businet_medical_center/views/users_views/users_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_view.dart';
import 'account_settings.dart';
import 'center_settings.dart';
import 'costumers_views/costumers_view.dart';
import 'help.dart';
import 'notifications.dart';
import 'payment_methods_views/payment_methods_view.dart';
import 'tech_support.dart';
import 'theme_settings_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: const [
          SettingsAppBar(),
          SettingsBody(),
          Text(
            'Businet 0.1.5',
            style: TextStyle(
              color: Colors.black12,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('اعدادات المستخدم'),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    controller: ScrollController(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: settingsItems.length,
                    itemBuilder: (context, index) => SettingsItemWidget(
                      item: settingsItems[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('ادوات المشرف'),
                Expanded(
                  child: GridView.builder(
                    controller: ScrollController(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: adminstratorSettings.length,
                    itemBuilder: (context, index) => SettingsItemWidgetX(
                      item: adminstratorSettings[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
    );
  }
}

List<SettingsItem> adminstratorSettings = [
  SettingsItem(
    icon: Icons.settings_applications,
    route: const CenterSettings(),
    subtitle: '',
    title: 'اعدادات المركز'.tr,
  ),
  SettingsItem(
    icon: Icons.settings_applications,
    route: const UsersView(),
    subtitle: 'عرض المستخمين',
    title: 'المستخدمين'.tr,
  ),
  SettingsItem(
    icon: Icons.settings_applications,
    route: const BillsControle(),
    subtitle: '',
    title: 'فاتورة جديدة'.tr,
  ),
  SettingsItem(
    icon: Icons.settings_applications,
    route: const BillsView(),
    subtitle: '',
    title: 'عرض الفواتير'.tr,
  ),
  SettingsItem(
    icon: Icons.settings_applications,
    route: const SuppliersView(),
    subtitle: '',
    title: 'عرض الموردين'.tr,
  ),
  SettingsItem(
    icon: Icons.settings_applications,
    route: const StocksView(),
    subtitle: '',
    title: 'عرض المخزن'.tr,
  ),
  SettingsItem(
    icon: Icons.settings_applications,
    route: const PaymentMethodsView(),
    subtitle: '',
    title: 'عرض طرق الدفع'.tr,
  ),
  SettingsItem(
    icon: Icons.settings_applications,
    route: const CostumersView(),
    subtitle: '',
    title: 'عرض العملاء'.tr,
  ),
];

List<SettingsItem> settingsItems = [
  SettingsItem(
    icon: Icons.settings_applications,
    route: const GeneralSettings(),
    subtitle: 'General Settings',
    title: 'general'.tr,
  ),
  SettingsItem(
    icon: Icons.language,
    route: const LanguageSettings(),
    subtitle: 'App Language',
    title: 'language'.tr,
  ),
  SettingsItem(
    icon: Icons.notifications,
    route: const NotificationsSettings(),
    subtitle: 'App Notifications',
    title: 'notifications'.tr,
  ),
  SettingsItem(
    icon: Icons.person,
    route: const AccountSettings(),
    subtitle: 'Your App Account Settings',
    title: 'account_settings'.tr,
  ),
  SettingsItem(
    icon: Icons.help,
    route: const Help(),
    subtitle: 'Help for more simplified app',
    title: 'help'.tr,
  ),
  SettingsItem(
    icon: Icons.support,
    route: const TechSupport(),
    subtitle: 'Technical Support With IT Team',
    title: 'tech_support'.tr,
  ),
  SettingsItem(
    icon: Icons.workspace_premium_rounded,
    route: const AboutView(),
    subtitle: 'عن التطبيق',
    title: 'عن التطبيق'.tr,
  ),
  SettingsItem(
    icon: Icons.format_paint_rounded,
    route: const ThemeSettingsView(),
    subtitle: 'Themes',
    title: 'Themes',
  ),
];
