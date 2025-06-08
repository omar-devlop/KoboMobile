import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/helpers/extensions/question_type_ext.dart';
import 'package:kobo/core/services/kobo_form_repository.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/survey_item.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

part 'attachments_state.dart';
part 'attachments_cubit.freezed.dart';

class AttachmentsCubit extends Cubit<AttachmentsState> {
  AttachmentsCubit(String uid)
    : super(const AttachmentsState.loading(msg: '')) {
    setUid(uid);
    initCubit();
  }
  late String uid;
  KoboFormRepository? survey;
  List<SurveyItem> mediaQuestions = [];

  void safeEmit(AttachmentsState state) => !isClosed ? emit(state) : null;

  void setUid(String uid) => this.uid = uid;

  initCubit() async {
    await fetchSurvey();
    fetchData();
  }

  Future<void> fetchSurvey() async {
    safeEmit(AttachmentsState.loading(msg: tr("fetchingSurvey")));
    survey = await _fetchAsset();
  }

  void fetchData({Map<String, dynamic>? additionalQuery}) async {
    if (survey == null) {
      safeEmit(
        const AttachmentsState.error(error: "Survey data is not available"),
      );
    } else {
      safeEmit(AttachmentsState.loading(msg: tr("fetchingData")));
      await survey!.fetchData(additionalQuery: additionalQuery);

      safeEmit(AttachmentsState.success(survey!));
    }
  }

  Future<bool> fetchMoreData() async {
    if (survey == null) return false;
    debugPrint("Fetch More Data [AttachmentsCubit] ...");

    safeEmit(AttachmentsState.success(survey!, isLoadingMore: true));
    await survey!.fetchMoreData();

    safeEmit(AttachmentsState.success(survey!));

    return true;
  }

  Future<KoboFormRepository?> _fetchAsset() async =>
      await getIt<KoboService>().fetchFormAsset(uid: uid);

  List<SurveyItem> getMediaQuestions() {
    if (survey == null) return [];

    final mediaQuestions =
        survey!.questions.where((element) => element.type.isMedia).toList();

    return mediaQuestions;
  }
}
