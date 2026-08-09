import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/presentation/Org/pages/create_org_form.dart';
import 'package:optima_sync_v2/app/presentation/Org/pages/upload_logo_widget.dart';

class CreateOrgScreen extends StatefulWidget {
  const CreateOrgScreen({
    super.key,
    this.oldvalue,
    this.embedded = false,
    this.onSaved,
  });

  final OrgEntity? oldvalue;
  final bool embedded;
  final ValueChanged<OrgEntity>? onSaved;
  @override
  State<CreateOrgScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CreateOrgScreen> {
  bool isPhotoStep = false;

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Create Organisation')),

      // body: isPhotoStep
      //     ? _uploadLogoWidget()
      //     : CreateOrgForm(
      //         callback: () => setState(() {
      //           isPhotoStep = true;
      //         }),
      //       ),
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          CreateOrgForm(
            callback: () {
              controller.animateToPage(
                1,
                duration: Duration(milliseconds: 1500),
                curve: Curves.decelerate,
              );
            },
          ),
          UploadLogoWidget(),
        ],
      ),
    );
  }
}
