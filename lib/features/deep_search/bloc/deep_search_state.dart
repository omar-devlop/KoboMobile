part of 'deep_search_cubit.dart';

@freezed
class DeepSearchState with _$DeepSearchState {
  const factory DeepSearchState.initial() = Initial;
  const factory DeepSearchState.loading(String msg) = Loading;
  const factory DeepSearchState.success({
    required List<KoboForm> forms,
    required Map<String, List<dynamic>> searchResults,
    required bool isSearching,
    KoboForm? searchingForm,
  }) = Success;
  const factory DeepSearchState.error(String error) = Error;
}
