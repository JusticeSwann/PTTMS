import 'package:location/location.dart';
import 'package:pttms/data/sources/location_service.dart';

class GetLiveLocationUseCase {
  final LocationService locationService;
  
  GetLiveLocationUseCase(this.locationService);

  Stream<LocationData> execute(){
    return locationService.getLocationStream();
  }
}