import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';

class EditCityForm extends StatefulWidget {
  final CityEntity city;

  const EditCityForm({super.key, required this.city});

  @override
  State<EditCityForm> createState() => _EditCityFormState();
}

class _EditCityFormState extends State<EditCityForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController colorController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.city.name);

    colorController = TextEditingController(text: widget.city.color);
  }

  @override
  void dispose() {
    nameController.dispose();
    colorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<CityBloc>().add(
        UpdateCitySubmitted(
          id: widget.city.id!,
          name: nameController.text.trim(),
          color: colorController.text.trim(),
        ),
      );
    }
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
      child: BlocListener<CityBloc, CityState>(
        listener: (context, state) {
          if (state is CitySuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<CityBloc, CityState>(
          builder: (context, state) {
            final isSubmitting = state is CityLoading;

            final errorMessage = state is CityFailure ? state.message : null;

            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit City",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    enabled: !isSubmitting,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "City name cannot be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("City Name"),
                      suffixIcon: const Icon(Icons.location_city_outlined),
                      errorText: errorMessage,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: colorController,
                    enabled: !isSubmitting,
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "City color cannot be empty";
                      }

                      final colorRegex = RegExp(r'^#[0-9A-Fa-f]{6}$');

                      if (!colorRegex.hasMatch(value.trim())) {
                        return "Enter a valid color like #FF5733";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text("City Color"),
                      hintText: "#FF5733",
                      prefixIcon: Icon(Icons.color_lens_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      child: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Save"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
