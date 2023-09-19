
import '../network_connectivity_repository.dart';

class ConnectionStream {
  ConnectionStream({required this.networkConnectivityRepository});

  final NetworkConnectivityRepository networkConnectivityRepository; // coverage:ignore-line

  Stream<NetworkConnectivityStatus> call() {
    networkConnectivityRepository.initialise();
    return networkConnectivityRepository.connectivityStream; // coverage:ignore-line
  }
}
