import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/application/usecases/forms/get_form_asset_legacy.dart';

part 'form_content_state.dart';
part 'form_content_cubit.freezed.dart';

class FormContentCubit extends Cubit<FormContentState> {
  final GetFormAssetLegacy _getFormAsset;
  FormContentCubit(String uid, this._getFormAsset, {String? versionUid})
    : super(const FormContentState.loading(msg: '')) {
    setUid(uid);
    _fetchAsset(versionUid: versionUid);
  }
  late String uid;
  KoboFormRepository? _survey;

  void safeEmit(FormContentState state) => !isClosed ? emit(state) : null;

  void setUid(String uid) => this.uid = uid;

  Future<void> _fetchAsset({String? versionUid}) async {
    safeEmit(FormContentState.loading(msg: tr("fetchingSurvey")));
    _survey = await _getFormAsset(uid: uid, versionUid: versionUid);
    if (_survey == null) {
      safeEmit(
        const FormContentState.error(error: "Survey data is not available"),
      );
    } else {
      safeEmit(FormContentState.success(_survey!));
    }
  }
}
