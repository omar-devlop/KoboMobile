import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobo/core/services/cloudflare_service.dart';
import 'package:kobo/core/utils/di/dependency_injection.dart';

part 'cloudflare_ai_state.dart';
part 'cloudflare_ai_cubit.freezed.dart';

class CloudflareAiCubit extends Cubit<CloudflareAiState> {
  CloudflareAiCubit(String prompt) : super(const CloudflareAiState.loading()) {
    generateAI(prompt);
  }
  void safeEmit(CloudflareAiState state) => !isClosed ? emit(state) : null;

  Future<void> generateAI(String prompt) async {
    safeEmit(const CloudflareAiState.loading());
    String? data = await getIt<CloudflareService>().generateAIResponse(prompt);
    List<String> newSuggestions = [];

    if (data != null) {
      newSuggestions.addAll(
        data
            .trim()
            .split('\n')
            .whereType<String>()
            .map((line) => line.replaceFirst(RegExp(r'^-\s*'), '').trim()),
      );

      safeEmit(CloudflareAiState.success(newSuggestions));
      return;
    } else {
      safeEmit(const CloudflareAiState.error(error: "ERROR"));
    }
  }
}
