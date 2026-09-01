import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final bool hideCompletedTasks;
  final bool hideUnavailableTasks;

  const AppSettings({
    this.hideCompletedTasks = true,
    this.hideUnavailableTasks = true,
  });

  AppSettings copyWith({bool? hideCompletedTasks, bool? hideUnavailableTasks}) {
    return AppSettings(
      hideCompletedTasks: hideCompletedTasks ?? this.hideCompletedTasks,
      hideUnavailableTasks: hideUnavailableTasks ?? this.hideUnavailableTasks,
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const _keyHideCompleted = 'hideCompletedTasks';
  static const _keyHideUnavailable = 'hideUnavailableTasks';
  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppSettings(
      hideCompletedTasks: prefs.getBool(_keyHideCompleted) ?? true,
      hideUnavailableTasks: prefs.getBool(_keyHideUnavailable) ?? true,
    );
  }

  Future<void> setHideCompletedTasks(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyHideCompleted, value);
    state = state.copyWith(hideCompletedTasks: value);
  }

  Future<void> setHideUnavailableTasks(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyHideUnavailable, value);
    state = state.copyWith(hideUnavailableTasks: value);
  }
}

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  () => AppSettingsNotifier(),
);

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class BackupSettings {
  final bool isAutoExportEnabled;
  final String? autoExportPath;
  final bool isAutoImportEnabled;
  final String? autoImportPath;

  const BackupSettings({
    this.isAutoExportEnabled = false,
    this.autoExportPath,
    this.isAutoImportEnabled = false,
    this.autoImportPath,
  });

  BackupSettings copyWith({
    bool? isAutoExportEnabled,
    String? autoExportPath,
    bool clearAutoExportPath = false,
    bool? isAutoImportEnabled,
    String? autoImportPath,
    bool clearAutoImportPath = false,
  }) {
    return BackupSettings(
      isAutoExportEnabled: isAutoExportEnabled ?? this.isAutoExportEnabled,
      autoExportPath: clearAutoExportPath
          ? null
          : (autoExportPath ?? this.autoExportPath),
      isAutoImportEnabled: isAutoImportEnabled ?? this.isAutoImportEnabled,
      autoImportPath: clearAutoImportPath
          ? null
          : (autoImportPath ?? this.autoImportPath),
    );
  }
}

class BackupSettingsNotifier extends Notifier<BackupSettings> {
  static const _keyEnabled = 'autoExportEnabled';
  static const _keyPath = 'autoExportPath';
  static const _keyAutoImportEnabled = 'autoImportEnabled';
  static const _keyAutoImportPath = 'autoImportPath';

  @override
  BackupSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return BackupSettings(
      isAutoExportEnabled: prefs.getBool(_keyEnabled) ?? false,
      autoExportPath: prefs.getString(_keyPath),
      isAutoImportEnabled: prefs.getBool(_keyAutoImportEnabled) ?? false,
      autoImportPath: prefs.getString(_keyAutoImportPath),
    );
  }

  Future<void> setAutoExportEnabled(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyEnabled, enabled);
    state = state.copyWith(isAutoExportEnabled: enabled);
  }

  Future<void> setAutoExportPath(String? path) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (path == null) {
      await prefs.remove(_keyPath);
      state = state.copyWith(clearAutoExportPath: true);
    } else {
      await prefs.setString(_keyPath, path);
      state = state.copyWith(autoExportPath: path);
    }
  }

  Future<void> setAutoImportEnabled(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyAutoImportEnabled, enabled);
    state = state.copyWith(isAutoImportEnabled: enabled);
  }

  Future<void> setAutoImportPath(String? path) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (path == null) {
      await prefs.remove(_keyAutoImportPath);
      state = state.copyWith(clearAutoImportPath: true);
    } else {
      await prefs.setString(_keyAutoImportPath, path);
      state = state.copyWith(autoImportPath: path);
    }
  }
}

final backupSettingsProvider =
    NotifierProvider<BackupSettingsNotifier, BackupSettings>(
      () => BackupSettingsNotifier(),
    );

class AutoImportRunNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markAsRun() {
    state = true;
  }
}

final autoImportRunProvider = NotifierProvider<AutoImportRunNotifier, bool>(
  () => AutoImportRunNotifier(),
);
