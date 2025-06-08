import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/services/kobo_service.dart';

part 'kobo_forms_state.dart';
part 'kobo_forms_cubit.freezed.dart';

class KoboformsCubit extends Cubit<KoboformsState> {
  KoboformsCubit() : super(const KoboformsState.initial()) {
    fetchForms();
  }
  void safeEmit(KoboformsState state) => !isClosed ? emit(state) : null;

  List<KoboForm> forms = [];
  void fetchForms() async {
    safeEmit(KoboformsState.loading(msg: 'fetchingForms'.tr()));
    try {
      forms = await getIt<KoboService>().fetchForms();
      safeEmit(KoboformsState.success(forms));
    } catch (e) {
      safeEmit(KoboformsState.error(error: e.toString()));
    }
  }
}
