import 'package:flutter_test/flutter_test.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/domain/entities/submission_stats.dart';
import 'package:kobo/domain/repositories/forms_repository.dart';
import 'package:kobo/domain/usecases/forms/get_forms.dart';

class FakeFormsRepository implements FormsRepository {
  final List<KoboForm> _forms;
  FakeFormsRepository(this._forms);

  @override
  Future<List<KoboForm>> getForms() async => _forms;

  @override
  Future<KoboForm?> getFormAsset({
    required String uid,
    String? versionUid,
  }) async => null;

  @override
  Future<List<SurveyItem>> getFormContent({required String uid}) async => [];

  @override
  Future<SubmissionStats> getDailySubmissionCounts({
    required String uid,
    int? days,
  }) async => throw UnimplementedError();
}

void main() {
  group('GetForms', () {
    test('returns empty list when repository returns empty', () async {
      final usecase = GetForms(FakeFormsRepository([]));
      final result = await usecase();
      expect(result, isEmpty);
    });

    test('returns forms when repository returns data', () async {
      final forms = [
        KoboForm.fromJson({'uid': '1', 'name': 'Form 1'}),
      ];
      final usecase = GetForms(FakeFormsRepository(forms));
      final result = await usecase();
      expect(result, hasLength(1));
      expect(result.first.name, 'Form 1');
    });
  });
}
