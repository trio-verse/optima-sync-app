import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/upload_logo_org/upload_logo_org_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/upload_logo_org/upload_logo_org_event.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/upload_logo_org/upload_logo_org_state.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/cerate_and_update_org_bloc/create_and_update_org_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/cerate_and_update_org_bloc/create_and_update_org_event.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/cerate_and_update_org_bloc/create_and_update_org_state.dart';

class CreateAndUpdateOrgForm extends StatefulWidget {
  const CreateAndUpdateOrgForm({
    super.key,
    required this.callback,
    this.oldvalue,
  });

  final VoidCallback callback;
  final OrgEntity? oldvalue;

  @override
  State<CreateAndUpdateOrgForm> createState() => _CreateAndUpdateOrgFormState();
}

class _CreateAndUpdateOrgFormState extends State<CreateAndUpdateOrgForm> {
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
        child: BlocListener<CreateAndUpdateOrgBloc, CreateAndUpdateOrgState>(
          listener: (context, state) {
            if (state is CreateAndUpdateOrgSuccess) {
              if (widget.oldvalue == null) {
                widget.callback();
              } else {
                Navigator.pop(context);
              }
            }

            if (state is CreateAndUpdateOrgFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<CreateAndUpdateOrgBloc, CreateAndUpdateOrgState>(
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  spacing: 15,
                  children: [
                    if (widget.oldvalue != null)
                      BlocBuilder<UploadLogoOrgBloc, UploadOrgLogoState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: state is UploadOrgLogoLoading
                                ? null
                                : () {
                                    context.read<UploadLogoOrgBloc>().add(
                                      PickAndUploadLogoEvent(
                                        organizationId: widget.oldvalue!.id!,
                                      ),
                                    );
                                  },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: widget.oldvalue!.logo != null
                                  ? NetworkImage(widget.oldvalue!.logo!)
                                  : null,
                              child: state is UploadOrgLogoLoading
                                  ? const CircularProgressIndicator()
                                  : widget.oldvalue!.logo == null
                                  ? const Icon(Icons.business, size: 50)
                                  : null,
                            ),
                          );
                        },
                      ),

                    Row(
                      spacing: 2,
                      children: const [
                        Icon(Icons.info_outline),
                        Text("IDENTITY"),
                      ],
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return "Name must be at least 2 letters";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
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
                      decoration: const InputDecoration(
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
                      children: const [
                        Icon(Icons.info_outline),
                        Text("PERSENCE"),
                      ],
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
                                      value: code,
                                      child: Text(code),
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
                              decoration: const InputDecoration(
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
                      decoration: const InputDecoration(
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
                      decoration: const InputDecoration(
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

                    BlocBuilder<
                      CreateAndUpdateOrgBloc,
                      CreateAndUpdateOrgState
                    >(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is CreateAndUpdateOrgLoading
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

                                    // print(org.toJson());

                                    context.read<CreateAndUpdateOrgBloc>().add(
                                      CreateAndUpdateOrgSubmitted(org: org),
                                    );
                                  }
                                },
                          child: state is CreateAndUpdateOrgLoading
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
