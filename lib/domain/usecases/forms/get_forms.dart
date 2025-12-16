import 'package:kobo/core/shared/models/kobo_form.dart';
import 'package:kobo/domain/repositories/forms_repository.dart';

class GetForms {
  final FormsRepository _repository;
  GetForms(this._repository);

  Future<List<KoboForm>> call() {
    return _repository.getForms();
  }
}


