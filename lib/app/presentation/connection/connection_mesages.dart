import 'package:flutter/widgets.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';

extension ConnectionErrorText on ConnectionError {
  String text(BuildContext context) {
    return when(
      offline: () => 'No internet connection',
      sessionExpired: () => 'Your session has expired, please log in again',
      noOrganization: () => 'Please select an organization first',
      invalidData: () =>
          'The submitted data is invalid, please check it and try again',
      notFound: () => 'This connection no longer exists',
      serverError: () => 'Something went wrong, please try again',
      productRequired: () => 'Product is required',
    );
  }
}

extension ConnectionSuccessText on ConnectionSuccessType {
  String text(BuildContext context) {
    switch (this) {
      case ConnectionSuccessType.created:
        return 'Connection created successfully';
      case ConnectionSuccessType.updated:
        return 'Connection updated successfully';
      case ConnectionSuccessType.deleted:
        return 'Connection deleted successfully';
    }
  }
}
