import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/domain/usecases/craete_org_usecases.dart';
import 'create_org_event.dart';
import 'create_org_state.dart';

class CreateOrgBloc extends Bloc<CreateOrgEvent, CreateOrgState> {
  final OrgUsecases usecases;

  XFile? selectedImage;
  CreateOrgBloc({required this.usecases}) : super(CreateOrgInitial()) {
    on<PickImageEvent>(_pickImage);

    on<CreateOrgSubmitted>(_createOrg);
  }

  Future<void> _pickImage(
    PickImageEvent event,
    Emitter<CreateOrgState> emit,
  ) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    selectedImage = image;

    emit(CreateOrgImageSelected(imagePath: image.path));
  }

  Future<void> _createOrg(
    CreateOrgSubmitted event,
    Emitter<CreateOrgState> emit,
  ) async {
    emit(CreateOrgLoading());

    try {
      final orgId = await usecases.createOrg(
        name: event.name,
        email: event.email,
        phone: event.phone,
        address: event.address,
        description: event.description,
      );
      print("Organization created: $orgId");

      if (selectedImage != null) {
        await usecases.uploadLogo(organizationId: orgId, image: selectedImage!);
      }
      emit(CreateOrgSuccess());
    } catch (e) {
      emit(CreateOrgFailure(message: e.toString()));
    }
  }
}
