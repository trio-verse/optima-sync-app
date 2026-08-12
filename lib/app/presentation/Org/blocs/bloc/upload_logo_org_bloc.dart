import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';

import 'upload_logo_org_event.dart';
import 'upload_logo_org_state.dart';

class UploadLogoOrgBloc extends Bloc<UploadOrgLogoEvent, UploadOrgLogoState> {
  final OrgUsecases uploadLogoUseCase;

  UploadLogoOrgBloc({required this.uploadLogoUseCase})
    : super(UploadOrgLogoInitial()) {
    on<PickAndUploadLogoEvent>(_pickAndUpload);
  }

  Future<void> _pickAndUpload(
    PickAndUploadLogoEvent event,
    Emitter<UploadOrgLogoState> emit,
  ) async {
    emit(UploadOrgLogoLoading());

    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      emit(UploadOrgLogoInitial());
      return;
    }

    try {
      await uploadLogoUseCase.uploadLogo(
        organizationId: event.organizationId,
        image: image,
      );

      emit(UploadOrgLogoSuccess(imageUrl: ''));
    } catch (e) {
      emit(UploadOrgLogoFailure(message: e.toString()));
    }
  }
}
