import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kobo/core/helpers/extensions/general_ext.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

/// A utility class for downloading files to the device's Downloads/appName folder
/// and opening them with the appropriate application. If the file already exists,
/// it skips the download and simply opens the existing file.
class DownloadManager {
  final Dio _dio;
  late final Future<Directory> _appDownloadDirectory;

  /// Creates a [DownloadManager] with an optional custom [Dio] client.
  DownloadManager(this._dio) {
    _appDownloadDirectory = _initAppDownloadDirectory();
  }

  /// Opens the file located at [path] using the default application.
  Future<ResultType> openFile(String? path) async {
    if (path == null) {
      return ResultType.error;
    }

    final result = await OpenFilex.open(path);
    return result.type;
  }

  /// Checks if a file exists in the download directory.
  ///
  /// Returns the full path if it exists, or null otherwise.
  Future<String?> fileExists(String filename) async {
    final appDir = await _appDownloadDirectory;
    final savePath = '${appDir.path}/$filename';
    final file = File(savePath);

    if (await file.exists()) {
      return savePath;
    }
    return null;
  }

  /// Ensures the file exists in Downloads/appName. Downloads it if missing.
  ///
  /// [url] - the file URL
  /// [filename] - desired filename
  /// [onProgress] - optional progress callback
  /// [forceDownload] - if true, always re-download
  ///
  Future<String?> getOrDownloadFile(
    String url,
    String filename, {
    void Function(int received, int total)? onProgress,
    bool forceDownload = false,
    bool saveInUserDownloadFolder = false,
  }) async {
    // Try existing file
    if (!forceDownload) {
      final existing = await fileExists(filename);
      if (existing != null) {
        return existing;
      }
    }

    // Ensure directory exists
    final appDir =
        saveInUserDownloadFolder
            ? await _getUserDownloadDirectory()
            : await _appDownloadDirectory;
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }

    String finalFilename = filename;
    final savePathBase = '${appDir.path}/';
    String savePath = '$savePathBase$finalFilename';

    if (saveInUserDownloadFolder) {
      int counter = 1;
      final name = filename.replaceFirst(RegExp(r'\.[^\.]+$'), '');
      final extension =
          filename.contains('.') ? '.${filename.split('.').last}' : '';

      while (await File(savePath).exists()) {
        finalFilename = '$name ($counter)$extension';
        savePath = '$savePathBase$finalFilename';
        counter++;
      }
    }

    try {
      // Download
      await _dio.download(
        url.withoutFormatJson,
        savePath,
        onReceiveProgress: onProgress,
      );
      return savePath;
    } catch (e) {
      // You might want to log or rethrow
      return null;
    }
  }

  /// Retrieves the platform-specific Downloads directory.
  Future<Directory> _getDownloadsDirectory() async {
    // For Android: external storage downloads
    if (Platform.isAndroid) {
      final dirs = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      if (dirs != null && dirs.isNotEmpty) {
        return dirs.first;
      }
      // Fallback: use primary external storage root
      return Directory('/storage/emulated/0/Download');
    }
    // For iOS/macOS/Desktop
    final dir = await getDownloadsDirectory();
    if (dir != null) return dir;
    // Fallback to temp
    return await getTemporaryDirectory();
  }

  /// Initializes the Downloads directory.
  Future<Directory> _initAppDownloadDirectory() async {
    return await _getDownloadsDirectory();
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid &&
        (await Permission.manageExternalStorage.status).isDenied) {
      bool granted = await Permission.manageExternalStorage.request().isGranted;
      if (!granted) {
        await openAppSettings();
      } else {
        return granted;
      }
    }
    return await Permission.manageExternalStorage.request().isGranted;
  }

  Future<Directory> _getUserDownloadDirectory() async {
    if (await _requestStoragePermission()) {
      if (Platform.isAndroid) {
        final dir = Directory('/storage/emulated/0/Download');
        if (await dir.exists()) {
          return dir;
        }
      }
    }
    return _appDownloadDirectory;
  }

  /// Clears all files in the Downloads/appName directory and recreates the folder.
  ///
  /// Returns `true` if successful or if the directory did not exist.
  Future<bool> clearDownloadFolder() async {
    final appDir = await _appDownloadDirectory;
    if (await appDir.exists()) {
      try {
        // Delete the directory and all its contents
        await appDir.delete(recursive: true);
        // Recreate an empty directory
        await appDir.create(recursive: true);
      } catch (e) {
        debugPrint('DownloadManager : ERROR -> ${e.toString()}');

        return false;
      }
    }

    debugPrint('DownloadManager : all data has been deleted');
    return true;
  }
}
