import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/survey_item.dart';
import 'package:kobo/data/services/kobo_service.dart';

part 'form_content_state.dart';
part 'form_content_cubit.freezed.dart';

class FormContentCubit extends Cubit<FormContentState> {
  FormContentCubit(String uid) : super(FormContentState.initial()) {
    fetchContent(uid);
  }
  void safeEmit(FormContentState state) => !isClosed ? emit(state) : null;

  List<SurveyItem> data = [];

  void fetchContent(String uid) async {
    safeEmit(FormContentState.loading(msg: "Fetching content..."));
    data = await getIt<KoboService>().fetchFormContent(uid: uid);
    safeEmit(FormContentState.success(data));
  }
}
