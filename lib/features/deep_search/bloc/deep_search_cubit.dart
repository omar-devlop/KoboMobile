import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/kobo_service.dart';
import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/core/shared/models/response_data.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

part 'deep_search_state.dart';
part 'deep_search_cubit.freezed.dart';

class DeepSearchCubit extends Cubit<DeepSearchState> {
  DeepSearchCubit() : super(const DeepSearchState.initial());

  void safeEmit(DeepSearchState state) => !isClosed ? emit(state) : null;
  List<KoboForm> _forms = [];
  Map<String, List<dynamic>> _searchResults = {};

  void deepSearch(String searchQuery) async {
    await _fetchForms();
    for (KoboForm form in _forms) {
      safeEmit(
        DeepSearchState.success(
          forms: _forms,
          searchResults: _searchResults,
          isSearching: true,
          searchingForm: form,
        ),
      );
      ResponseData? responseData = await _searchInForm(form, searchQuery);
      if (responseData != null) {
        _searchResults[form.uid] = responseData.results;
        safeEmit(
          DeepSearchState.success(
            forms: _forms,
            searchResults: _searchResults,
            isSearching: true,
            searchingForm: form,
          ),
        );
      }
      if (responseData == null || responseData.results.isEmpty) {
        _searchResults.remove(form.uid);
        safeEmit(
          DeepSearchState.success(
            forms: _forms,
            searchResults: _searchResults,
            isSearching: true,
          ),
        );
      }
    }

    safeEmit(
      DeepSearchState.success(
        forms: _forms,
        searchResults: _searchResults,
        isSearching: false,
      ),
    );
  }

  Future<ResponseData?> _searchInForm(KoboForm form, String searchQuery) async {
    try {
      ResponseData responseData = await getIt<KoboService>().fetchFormData(
        uid: form.uid,
        additionalQuery: {
          'limit': null,
          'query':
              '{"meta/instanceName": {"\$regex": ".*$searchQuery.*","\$options": "i"}}',
        },
      );
      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _fetchForms() async {
    safeEmit(DeepSearchState.loading('fetchingForms'.tr()));
    try {
      _forms = await getIt<KoboService>().fetchForms();
      _searchResults = {};
      for (KoboForm form in _forms) {
        _searchResults[form.uid] = [];
      }
      safeEmit(
        DeepSearchState.success(
          forms: _forms,
          searchResults: _searchResults,
          isSearching: true,
        ),
      );
      return true;
    } catch (e) {
      safeEmit(DeepSearchState.error(e.toString()));
      return false;
    }
  }
}
