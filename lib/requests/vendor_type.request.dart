import 'package:glover/constants/api.dart';
import 'package:glover/models/api_response.dart';
import 'package:glover/models/vendor_type.dart';
import 'package:glover/services/http.service.dart';
import 'package:glover/services/location.service.dart';

class VendorTypeRequest extends HttpService {
  //
  Future<List<VendorType>> index() async {
    final params = {
      "latitude": LocationService.getFetchByLocationLat(),
      "longitude": LocationService.getFetchByLocationLng(),
    };
    print("params: $params");
    final apiResult = await get(
      Api.vendorTypes,
      queryParameters: params,
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List)
          .map((e) => VendorType.fromJson(e))
          .toList();
    }

    throw apiResponse.message!;
  }
}
