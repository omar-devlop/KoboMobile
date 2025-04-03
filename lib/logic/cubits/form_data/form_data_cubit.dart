import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';
import 'package:kobo/data/modules/response_data.dart';
import 'package:kobo/core/services/kobo_service.dart';

part 'form_data_state.dart';
part 'form_data_cubit.freezed.dart';

class FormDataCubit extends Cubit<FormDataState> {
  FormDataCubit(String uid) : super(FormDataState.initial()) {
    fetchData(uid);
  }
  void safeEmit(FormDataState state) => !isClosed ? emit(state) : null;

  late ResponseData data;

  void fetchData(String uid) async {
    safeEmit(FormDataState.loading(data: data));
    data = await getIt<KoboService>().fetchFormData(uid: uid);
    safeEmit(FormDataState.success(data));
  }

  void fetchMoreData(String uid) async {
    safeEmit(FormDataState.loading(data: data));
    ResponseData newData = await getIt<KoboService>().fetchFormData(
      uid: uid,
      additionalQuery: {'start': data.results.length, 'limit': Constants.limit},
    );
    data.results.addAll(newData.results);

    safeEmit(FormDataState.success(data));
  }
}
