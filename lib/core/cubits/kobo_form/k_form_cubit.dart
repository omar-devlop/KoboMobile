import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/services/pdf_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/application/usecases/forms/get_form_asset_legacy.dart';

part 'k_form_state.dart';
part 'k_form_cubit.freezed.dart';

class KFormCubit extends Cubit<KFormState> {
  final GetFormAssetLegacy _getFormAsset;
  KFormCubit(String uid, this._getFormAsset) : super(const KFormState.initial()) {
    setUid(uid);
    fetchData();
  }

  late String uid;
  KoboFormRepository? survey;
  void safeEmit(KFormState state) => !isClosed ? emit(state) : null;
  void setUid(String uid) => this.uid = uid;

  void fetchData() async {
    safeEmit(KFormState.loading(msg: tr("fetchingSurvey")));

    survey = await _fetchAsset();

    if (survey != null) {
      safeEmit(KFormState.success(survey!));
    } else {
      safeEmit(const KFormState.error(error: "Survey data is not available"));
    }
  }

  Future<bool> export({Map<String, dynamic>? additionalQuery}) async {
    if (survey == null) return false;
    // await survey!.fetchWholeData();

    await survey!.fetchData(additionalQuery: additionalQuery, limit: -1);

    final pdfBytes = await getIt<PdfService>().createSubmissionsTablePdfFile(
      submissions: survey!.responseData.results,
      formName: survey!.form.name,
    );
    if (pdfBytes != false) {
      await getIt<PdfService>().savePdfFile('submissions_report', pdfBytes);
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> _fetchAsset() async =>
      await _getFormAsset(uid: uid);
}
