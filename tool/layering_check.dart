import 'dart:io';

/// Simple layering check to enforce clean architecture imports.
/// Rules:
/// - domain/ must not import application/, infrastructure/, presentation/
/// - application/ must not import infrastructure/, presentation/
/// - infrastructure/ must not import presentation/
/// - presentation/ can import application/ and domain/, but avoid infrastructure/
///
/// Run: dart run tool/layering_check.dart
void main(List<String> args) {
  final root = Directory('lib');
  if (!root.existsSync()) {
    stderr.writeln('lib/ directory not found. Run from project root.');
    exit(2);
  }

  final violations = <String>[];
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;

    final relPath = entity.path.replaceAll('\\', '/');
    // Composition root exceptions: DI and app bootstrap can wire any layer
    final isCompositionRoot = relPath.startsWith('lib/core/utils/di/') ||
        relPath == 'lib/main.dart' ||
        relPath == 'lib/kobo_app.dart';
    if (isCompositionRoot) continue;
    final content = entity.readAsStringSync();

    bool inDomain = relPath.startsWith('lib/domain/');
    bool inApplication = relPath.startsWith('lib/application/');
    bool inInfrastructure = relPath.startsWith('lib/infrastructure/');
    bool inPresentation = relPath.startsWith('lib/presentation/') || relPath.startsWith('lib/features/') || relPath.startsWith('lib/core/');

    List<RegExp> forbiddenImports = [];
    if (inDomain) {
      forbiddenImports.add(RegExp(r"package:kobo/(application|infrastructure|features|presentation)/"));
    } else if (inApplication) {
      forbiddenImports.add(RegExp(r"package:kobo/(infrastructure|features|presentation)/"));
    } else if (inInfrastructure) {
      forbiddenImports.add(RegExp(r"package:kobo/(features|presentation)/"));
    } else if (inPresentation) {
      // Prefer avoiding infra in presentation
      forbiddenImports.add(RegExp(r"package:kobo/infrastructure/"));
    }

    final lines = content.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (!line.trimLeft().startsWith('import')) continue;
      for (final rule in forbiddenImports) {
        if (rule.hasMatch(line)) {
          violations.add('${relPath}:${i + 1}: forbidden import -> ${line.trim()}');
        }
      }
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln('Layering violations found:');
    for (final v in violations) {
      stderr.writeln(' - $v');
    }
    exit(1);
  } else {
    stdout.writeln('No layering violations detected.');
  }
}


