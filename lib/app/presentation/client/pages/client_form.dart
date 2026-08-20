import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_state.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';

class ClientForm extends StatefulWidget {
  final String title;
  final String submitLabel;
  final ClientEntity? initial;
  final void Function(ClientEntity client) onSubmit;

  const ClientForm({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.initial,
  });

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController addressController;
  late final TextEditingController whatsappController;
  late final TextEditingController facebookController;
  late final TextEditingController instagramController;
  late final TextEditingController websiteController;
  late final TextEditingController notesController;

  late String clientType;
  int? industryId;
  int? cityId;

  static final _phoneRegex = RegExp(r'^\+?[0-9\s\-()]{7,20}$');
  static final _urlRegex = RegExp(
    r'^(https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w\-._~:/?#[\]@!$&()*+,;=%]*)?$',
  );

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;

    nameController = TextEditingController(text: initial?.name ?? '');
    phoneController = TextEditingController(text: initial?.phone ?? '');
    emailController = TextEditingController(text: initial?.email ?? '');
    addressController = TextEditingController(text: initial?.address ?? '');
    whatsappController = TextEditingController(text: initial?.whatsapp ?? '');
    facebookController = TextEditingController(text: initial?.facebook ?? '');
    instagramController = TextEditingController(text: initial?.instagram ?? '');
    websiteController = TextEditingController(text: initial?.website ?? '');
    notesController = TextEditingController(text: initial?.notes ?? '');

    clientType = initial?.clientType ?? kClientTypes.first;
    industryId = initial != null && initial.industryId != 0
        ? initial.industryId
        : null;
    cityId = initial != null && initial.cityId != 0 ? initial.cityId : null;

    context.read<IndustryBloc>().add(LoadIndustries());
    context.read<CityBloc>().add(LoadCities());
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    websiteController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String? _optional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _submit() {
    if (industryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select an industry')));
      return;
    }

    if (cityId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select a city')));
      return;
    }

    if (!formKey.currentState!.validate()) return;

    widget.onSubmit(
      ClientEntity(
        id: widget.initial?.id,
        name: nameController.text.trim(),
        clientType: clientType,
        industryId: industryId!,
        cityId: cityId!,
        phone: phoneController.text.trim(),
        email: _optional(emailController),
        address: _optional(addressController),
        whatsapp: _optional(whatsappController),
        facebook: _optional(facebookController),
        instagram: _optional(instagramController),
        website: _optional(websiteController),
        notes: _optional(notesController),
      ),
    );
  }

  InputDecoration _decoration(String label, {String? hint, Widget? icon}) {
    return InputDecoration(
      label: Text(label),
      hintText: hint,
      prefixIcon: icon,
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientSuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ClientBloc, ClientState>(
          builder: (context, clientState) {
            final isSubmitting = clientState is ClientSubmitting;

            final errorMessage = clientState is ClientFailure
                ? clientState.message
                : null;

            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (errorMessage != null) ...[
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                    ],

                    TextFormField(
                      controller: nameController,
                      autofocus: true,
                      enabled: !isSubmitting,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Client name cannot be empty";
                        }

                        if (value.trim().length > 255) {
                          return "Name must not be greater than 255 characters";
                        }

                        return null;
                      },
                      decoration: _decoration(
                        "Client Name",
                        icon: const Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: clientType,
                      decoration: _decoration("Client Type"),
                      items: kClientTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type[0].toUpperCase() + type.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: isSubmitting
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() => clientType = value);
                              }
                            },
                    ),

                    const SizedBox(height: 15),

                    BlocBuilder<IndustryBloc, IndustryState>(
                      builder: (context, industryState) {
                        final industries = industryState is IndustrySuccess
                            ? industryState.industries
                            : const <IndustryEntity>[];

                        final safeIndustryId =
                            industries.any(
                              (i) =>
                                  i.id != null &&
                                  int.tryParse(i.id!) == industryId,
                            )
                            ? industryId
                            : null;

                        return DropdownButtonFormField<int>(
                          value: safeIndustryId,
                          decoration: _decoration("Industry"),
                          hint: Text(
                            industryState is IndustryLoading
                                ? "Loading industries..."
                                : "Select an industry",
                          ),
                          items: industries
                              .where((i) => i.id != null)
                              .map(
                                (industry) => DropdownMenuItem(
                                  value: int.parse(industry.id!),
                                  child: Text(industry.name),
                                ),
                              )
                              .toList(),
                          onChanged: isSubmitting
                              ? null
                              : (value) => setState(() => industryId = value),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    BlocBuilder<CityBloc, CityState>(
                      builder: (context, cityState) {
                        final cities = cityState is CitySuccess
                            ? cityState.cities
                            : const <CityEntity>[];

                        final safeCityId =
                            cities.any(
                              (c) =>
                                  c.id != null && int.tryParse(c.id!) == cityId,
                            )
                            ? cityId
                            : null;

                        return DropdownButtonFormField<int>(
                          value: safeCityId,
                          decoration: _decoration("City"),
                          hint: Text(
                            cityState is CityLoading
                                ? "Loading cities..."
                                : "Select a city",
                          ),
                          items: cities
                              .where((c) => c.id != null)
                              .map(
                                (city) => DropdownMenuItem(
                                  value: int.parse(city.id!),
                                  child: Text(city.name),
                                ),
                              )
                              .toList(),
                          onChanged: isSubmitting
                              ? null
                              : (value) => setState(() => cityId = value),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: phoneController,
                      enabled: !isSubmitting,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Phone cannot be empty";
                        }

                        if (!_phoneRegex.hasMatch(value.trim())) {
                          return "Enter a valid phone number";
                        }

                        return null;
                      },
                      decoration: _decoration(
                        "Phone",
                        icon: const Icon(Icons.phone_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: emailController,
                      enabled: !isSubmitting,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }

                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return "Enter a valid email";
                        }

                        return null;
                      },
                      decoration: _decoration(
                        "Email (optional)",
                        icon: const Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: addressController,
                      enabled: !isSubmitting,
                      decoration: _decoration(
                        "Address (optional)",
                        icon: const Icon(Icons.location_on_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: whatsappController,
                      enabled: !isSubmitting,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }

                        if (value.trim().length > 50) {
                          return "Must not be greater than 50 characters";
                        }

                        return null;
                      },
                      decoration: _decoration(
                        "WhatsApp (optional)",
                        icon: const Icon(Icons.chat_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: facebookController,
                      enabled: !isSubmitting,
                      validator: (value) => _urlValidator(value),
                      decoration: _decoration(
                        "Facebook (optional)",
                        icon: const Icon(Icons.facebook_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: instagramController,
                      enabled: !isSubmitting,
                      validator: (value) => _urlValidator(value),
                      decoration: _decoration(
                        "Instagram (optional)",
                        icon: const Icon(Icons.camera_alt_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: websiteController,
                      enabled: !isSubmitting,
                      validator: (value) => _urlValidator(value),
                      decoration: _decoration(
                        "Website (optional)",
                        icon: const Icon(Icons.public_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: notesController,
                      enabled: !isSubmitting,
                      maxLines: 3,
                      decoration: _decoration("Notes (optional)"),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _submit,
                        child: isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(widget.submitLabel),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _urlValidator(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    if (value.trim().length > 255) {
      return "Must not be greater than 255 characters";
    }

    if (!_urlRegex.hasMatch(value.trim())) {
      return "Enter a valid URL";
    }

    return null;
  }
}
