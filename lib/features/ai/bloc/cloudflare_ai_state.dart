part of 'cloudflare_ai_cubit.dart';

@freezed
class CloudflareAiState with _$CloudflareAiState {
  const factory CloudflareAiState.loading() = Loading;
  const factory CloudflareAiState.success(List<String> response) = Success;
  const factory CloudflareAiState.error({required String error}) = Error;
}
