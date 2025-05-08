import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:groq_sdk/models/groq_llm_model.dart';

import '../../../../../../../controllers/Generated/Assets/assets.dart';
import '../../../../../../../controllers/Pages/Layout/Controllers/Layout Pages Controllers/Settings/Controller/settings_controller.dart';
import '../../../../../../components/Text/custom_text.dart';
import '../Widgets/settings_dropdown_item_widget.dart';
import '../Widgets/settings_item_widget.dart';
import '../Widgets/settings_slider_item_widget.dart';
import '../Widgets/settings_switch_item_widget.dart';
import '../Widgets/settins_section_header_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    widget.settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Settings',
          fontSize: 48.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Account Section
              SettingsSectionHeader(iconAsset: Assets.user, title: 'Account'),

              SettingsItem(
                iconAsset: Assets.username,
                label: "Change Username",
                onTap: () => widget.settingsController.onUsernameTap(context),
              ),

              SizedBox(height: 16.h),

              SettingsItem(
                iconAsset: Assets.password,
                label: "Change Password",
                onTap: () => widget.settingsController.onPasswordTap(context),
              ),

              SizedBox(height: 32.h),

              // AI Settings Section
              SettingsSectionHeader(
                iconAsset: Assets.logoOutlined,
                title: 'AI Settings',
              ),

              SettingsDropdownItem(
                iconAsset: Assets.model,
                label: "Model",
                initialSelection: widget.settingsController.selectedModel,
                dropdownEntries: const [
                  DropdownMenuEntry(
                    value: GroqModels.llama3_70b,
                    label: 'MKB-70',
                  ),
                  DropdownMenuEntry(
                    value: GroqModels.llama3_8b,
                    label: 'MKB-8',
                  ),
                  DropdownMenuEntry(
                    value: GroqModels.gemma2_9b,
                    label: 'MKB-9',
                  ),
                ],
                onSelected:
                    (value) => widget.settingsController.onModelSelected(value),
              ),

              SizedBox(height: 16.h),

              StatefulBuilder(
                builder: (context, setTemperatureState) {
                  widget.settingsController.setTemperatureState =
                      setTemperatureState;
                  return SettingsSliderItem(
                    iconAsset: Assets.temperature,
                    label: "Temperature",
                    value: widget.settingsController.temperature,
                    onchanged: (value) => widget.settingsController.onTemperatureChanged(value),
                    onChangeEnd:
                        (value) => widget.settingsController
                            .onTemperatureChangedEnd(value),
                  );
                },
              ),

              SizedBox(height: 32.h),

              // Preferences Section
              SettingsSectionHeader(
                iconAsset: Assets.preferences,
                title: 'Preferences',
              ),

              StatefulBuilder(
                builder: (context, setLightModeState) {
                  widget.settingsController.setLightModeState =
                      setLightModeState;
                  return SettingsSwitchItem(
                    iconAsset: widget.settingsController.brightnessIcon!,
                    label: widget.settingsController.brightnessLabel!,
                    value: !widget.settingsController.isDarkMode,
                    onChanged:
                        (value) =>
                            widget.settingsController.onLightModeChanged(!value),
                  );
                },
              ),

              SizedBox(height: 16.h),

              SettingsDropdownItem(
                iconAsset: Assets.language,
                label: "Language",
                initialSelection: widget.settingsController.getLanguageValue(context),
                dropdownEntries: [
                  DropdownMenuEntry(value: 'en', label: 'English'.tr()),
                  DropdownMenuEntry(value: 'ar', label: 'Arabic'.tr()),
                ],
                onSelected:
                    (value) => widget.settingsController.onLanguageSelected(
                      context,
                      value,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
