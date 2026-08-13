import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/create%20org%20bloc/org_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/create%20org%20bloc/org_event.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/create%20org%20bloc/org_state.dart';

class CreateOrgForm extends StatefulWidget {
  const CreateOrgForm({super.key, required this.callback, this.oldvalue});
  final VoidCallback callback;
  final OrgEntity? oldvalue;
  @override
  State<CreateOrgForm> createState() => _CreateOrgFormState();
}

class _CreateOrgFormState extends State<CreateOrgForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final addressController = TextEditingController();

  final descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();

    final oldOrg = widget.oldvalue;

    if (oldOrg != null) {
      nameController.text = oldOrg.name;
      emailController.text = oldOrg.email;
      phoneController.text = oldOrg.phone;
      addressController.text = oldOrg.address;
      descriptionController.text = oldOrg.description;
    }
  }

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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: BlocListener<CreateOrgBloc, CreateOrgState>(
          listener: (context, state) {
            if (state is CreateOrgFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<CreateOrgBloc, CreateOrgState>(
            builder: (context, state) {
              if (state is CreateOrgSuccess) {
                widget.callback();
              }
              return Form(
                key: formKey,
                child: Column(
                  spacing: 15,
                  children: [
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
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Email is required";
                      //   }

                      //   if (!value.trim().endsWith("@gmail.com")) {
                      //     return "Enter a valid Gmail address";
                      //   }

                      //   return null;
                      // },
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
                                    final org = OrgEntity(
                                      id: widget.oldvalue?.id,
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      address: addressController.text.trim(),
                                      description: descriptionController.text
                                          .trim(),
                                    );

                                    print(org.toJson());

                                    context.read<CreateOrgBloc>().add(
                                      CreateOrgSubmitted(org: org),
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
                              : Text(
                                  widget.oldvalue == null
                                      ? "Create & Get Started"
                                      : "Update",
                                ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
