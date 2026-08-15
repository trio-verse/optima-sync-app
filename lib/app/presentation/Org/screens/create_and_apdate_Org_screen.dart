import 'package:flutter/material.dart';

import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/app/presentation/Org/pages/create_org_form.dart';
import 'package:optima_sync_v2/app/presentation/Org/pages/upload_logo_widget.dart';

class CreateAndUpdateOrgScreen extends StatefulWidget {
  const CreateAndUpdateOrgScreen({
    super.key,
    this.oldvalue,
    this.embedded = false,
    this.onSaved,
  });

  final OrgEntity? oldvalue;
  final bool embedded;
  final ValueChanged<OrgEntity>? onSaved;

  @override
  State<CreateAndUpdateOrgScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CreateAndUpdateOrgScreen> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    if (widget.oldvalue != null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Update Organization"),
        ),
        body: CreateAndUpdateOrgForm(
          oldvalue: widget.oldvalue,
          callback: () {},
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create Organisation"),
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CreateAndUpdateOrgForm(
            oldvalue: null,
            callback: () {
              controller.animateToPage(
                1,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.decelerate,
              );
            },
          ),
          const UploadLogoWidget(),
        ],
      ),
    );
  }
}
