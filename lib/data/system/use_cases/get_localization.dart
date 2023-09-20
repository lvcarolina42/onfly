import 'package:geolocator/geolocator.dart';
import 'package:onfly/data/system/localization_repository.dart';

class GetLocalization {
  GetLocalization({required this.localizationRepository});

  final LocalizationRepository localizationRepository;

  Future<Position?> call() => localizationRepository.getPosition();
}
