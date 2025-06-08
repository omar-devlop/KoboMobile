import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/services/kobo_service.dart';

part 'form_content_state.dart';
part 'form_content_cubit.freezed.dart';

class FormContentCubit extends Cubit<FormContentState> {
  FormContentCubit(String uid, {String? versionUid})
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
    _survey = await getIt<KoboService>().fetchFormAsset(
      uid: uid,
      versionUid: versionUid,
    );
    if (_survey == null) {
      safeEmit(
        const FormContentState.error(error: "Survey data is not available"),
      );
    } else {
      safeEmit(FormContentState.success(_survey!));
    }
  }
}
