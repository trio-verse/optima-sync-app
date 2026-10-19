import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

extension MarketingErrorText on MarketingError {
  String text(BuildContext context) {
    return when(
      offline: () => 'No internet connection',
      sessionExpired: () => 'Your session has expired, please log in again',
      noOrganization: () => 'Please select an organization first',
      invalidData: () =>
          'The submitted data is invalid, please check it and try again',
      notFound: () => 'This item no longer exists',
      serverError: () => 'Something went wrong, please try again',
    );
  }
}
