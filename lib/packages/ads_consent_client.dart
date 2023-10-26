// Provides classes and functions for asynchronous programming.
import 'dart:async';
// This package is used for integrating Google Mobile Ads SDK into the app.
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Represents a custom exception type for handling failures related to ads consent.
abstract class AdsConsentFailure implements Exception {
  const AdsConsentFailure(this.error);

  final Object error;
}

// represents a specific type of consent failure related to requesting consent.
class RequestConsentFailure extends AdsConsentFailure {
  const RequestConsentFailure(super.error);
}

typedef ConsentFormProvider = void Function(
  OnConsentFormLoadSuccessListener successListener,
  OnConsentFormLoadFailureListener failureListener,
);

// This class provides methods for requesting and handling consent for ads from Google.
// The AdsConsentClient class has the following properties:
// _adsConsentInformation: A reference to the ConsentInformation class, which provides methods for
// getting and setting consent information.
// _adsConsentFormProvider: A reference to the ConsentFormProvider function, which is used to load
// the consent form.
class AdsConsentClient {
  AdsConsentClient({
    ConsentInformation? adsConsentInformation,
    ConsentFormProvider? adsConsentFormProvider,
  })  : _adsConsentInformation =
            adsConsentInformation ?? ConsentInformation.instance,
        _adsConsentFormProvider =
            adsConsentFormProvider ?? ConsentForm.loadConsentForm;

  final ConsentInformation _adsConsentInformation;
  final ConsentFormProvider _adsConsentFormProvider;


// This method requests consent from the user. If the user has already granted consent,
// the method will return true immediately. Otherwise, the method will show the consent form and
// return true when the user has granted consent.
  Future<bool> requestConsent() async {
//  It uses a Completer<bool> to asynchronously complete the consent request.
    final adsConsentDeterminedCompleter = Completer<bool>();

// calls _adsConsentInformation.requestConsentInfoUpdate() to update the consent information.
    _adsConsentInformation.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        try {
          if (await _adsConsentInformation.isConsentFormAvailable()) {
            adsConsentDeterminedCompleter.complete(await _loadConsentForm());
          } else {
            final status = await _adsConsentInformation.getConsentStatus();
            adsConsentDeterminedCompleter.complete(status.isDetermined);
          }
        } on FormError catch (error, stackTrace) {
          _onRequestConsentError(error,
              completer: adsConsentDeterminedCompleter, stackTrace: stackTrace);
        }
      },
      (error) => _onRequestConsentError(error,
          completer: adsConsentDeterminedCompleter),
    );
    return adsConsentDeterminedCompleter.future;
  }

// This method is responsible for loading and displaying the consent form if required.
  Future<bool> _loadConsentForm() async {
// The method first creates a Completer to track the completion of the operation.
    final completer = Completer<bool>();
    // It calls the _adsConsentFormProvider to load the consent form and handle the showing of
    // the form if it's required.
    _adsConsentFormProvider((consentForm) async {
      final status = await _adsConsentInformation.getConsentStatus();
      if (status.isRequired) {
        consentForm.show((formError) async {
          if (formError != null) {
            completer.completeError(formError, StackTrace.current);
          } else {
            final updatedStatus =
                await _adsConsentInformation.getConsentStatus();
            completer.complete(updatedStatus.isDetermined);
          }
        });
      } else {
        completer.complete(status.isDetermined);
      }
    }, (error) => completer.completeError(error, StackTrace.current));
    return completer.future;
  }

// This method is a utility to handle errors that occur during the consent request process.
  void _onRequestConsentError(
    FormError error, {
    required Completer<bool> completer,
    StackTrace? stackTrace,
  }) {
    return completer.completeError(
        RequestConsentFailure(error), stackTrace ?? StackTrace.current);
  }
}


// The extension on ConsentStatus adds two methods to the ConsentStatus class:
// isDetermined: This method returns true if the consent status is obtained or notRequired.
// isRequired: This method returns true if the consent status is required.
extension on ConsentStatus {
  bool get isDetermined =>
      this == ConsentStatus.obtained || this == ConsentStatus.notRequired;

  bool get isRequired => this == ConsentStatus.required;
}
