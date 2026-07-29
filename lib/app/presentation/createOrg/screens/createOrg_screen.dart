import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/createOrg/bloc/create_org_bloc.dart';
import 'package:optima_sync_v2/app/presentation/createOrg/bloc/create_org_event.dart';
import 'package:optima_sync_v2/app/presentation/createOrg/bloc/create_org_state.dart';

class CreateOrgScreen extends StatefulWidget {
  const CreateOrgScreen({super.key});

  @override
  State<CreateOrgScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CreateOrgScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  List<String> countryCode = [
    "🇦🇪 +971",
    "🇸🇦 +966",
    "🇱🇧 +961",
    "🇯🇴 +962",
    "🇸🇾 +963",
  ];
  String selectedCode = "🇯🇴 +962";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Create Organisation')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: BlocListener<CreateOrgBloc, CreateOrgState>(
            listener: (context, state) {
              if (state is CreateOrgSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Organization created successfully"),
                  ),
                );
              }

              if (state is CreateOrgFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Form(
              key: formKey,
              child: Column(
                spacing: 15,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<CreateOrgBloc>().add(PickImageEvent());
                    },
                    child: BlocBuilder<CreateOrgBloc, CreateOrgState>(
                      builder: (context, state) {
                        if (state is CreateOrgImageSelected) {
                          return CircleAvatar(
                            radius: 80,
                            // backgroundImage: FileImage(File(state.imagePath)),
                            backgroundImage: kIsWeb
                                ? NetworkImage(state.imagePath)
                                : FileImage(File(state.imagePath))
                                      as ImageProvider,
                          );
                        }
                        return CircleAvatar(
                          radius: 80,
                          // backgroundImage: NetworkImage(""),
                          child: Icon(Icons.add_a_photo, size: 40),
                        );
                      },
                    ),
                  ),

                  Row(
                    spacing: 2,
                    children: [Icon(Icons.info_outline), Text("IDENTITY")],
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return "Name must be at least 2 letters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Organisation Name'),
                      hint: Text('Optima Sync'),
                      suffixIcon: Icon(Icons.person_2_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }

                      if (!value.trim().endsWith("@gmail.com")) {
                        return "Enter a valid Gmail address";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Organisation Email'),
                      hint: Text('john.doe@gmail.com'),
                      suffixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),
                  Row(
                    spacing: 15,
                    children: [Icon(Icons.info_outline), Text("PERSENCE")],
                  ),
                  Center(
                    child: Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 100,
                          child: DropdownButton<String>(
                            value: selectedCode,

                            items: countryCode
                                .map(
                                  (code) => DropdownMenuItem<String>(
                                    child: Text(code),
                                    value: code,
                                  ),
                                )
                                .toList(),
                            onChanged: (code) {
                              setState(() {
                                selectedCode = code!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone number is required";
                              }

                              if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                                return "Phone must contain 9 digits";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text('Phone Number'),
                              hint: Text('999 999 999'),
                              suffixIcon: Icon(Icons.phone_android_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: addressController,
                    validator: (value) {
                      if (value == null || value.length < 2) {
                        return "Address must be at least 2 letters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Address'),
                      hint: Text('City , Country'),
                      suffixIcon: Icon(Icons.location_city_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.trim().length < 10) {
                        return "Description must be at least 10 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('description'),
                      hint: Text(
                        'Tell us more about your buissniss fields, branches, or operations...',
                      ),
                      suffixIcon: Icon(Icons.note_sharp),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),

                  BlocBuilder<CreateOrgBloc, CreateOrgState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is CreateOrgLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  final countryCode = selectedCode
                                      .split(" ")
                                      .last;

                                  context.read<CreateOrgBloc>().add(
                                    CreateOrgSubmitted(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      phone:
                                          "${selectedCode.split(" ").last}${phoneController.text.trim()}",
                                      address: addressController.text.trim(),
                                      description: descriptionController.text
                                          .trim(),
                                    ),
                                  );
                                }
                              },
                        child: state is CreateOrgLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Create & Get Started"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
