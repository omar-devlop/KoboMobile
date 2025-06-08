part of 'attachments_cubit.dart';

@freezed
class AttachmentsState with _$AttachmentsState {
  const factory AttachmentsState.loading({required String msg}) = Loading;
  const factory AttachmentsState.success(
    KoboFormRepository survey, {
    bool? isLoadingMore,
  }) = Success;
  const factory AttachmentsState.error({required String error}) = Error;
}
