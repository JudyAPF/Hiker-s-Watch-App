import 'package:flores_hikers_watch_app/screens/weather.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;
  Placemark? place;
  String postalCode = '',
      street = '',
      subLocality = '',
      locality = '',
      subAdministrativeArea = '',
      country = '';

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<bool> checkServicePermission() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location service is disabled. Please enable it in the settings.'),
        ),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission is denied. Please accept the location permission of the app to continue.'),
          ),
        );
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission is permanently denied. Please change in the settings to continue.'),
          ),
        );
        return false;
      }
    }
    return true;
  }

  void getCurrentLocation() async {
    if (!await checkServicePermission()) {
      return;
    }

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _getAddressFromLatLng(position!);
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {});
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        setState(() {
          postalCode = '${place.postalCode}';
          street = '${place.street}';
          subLocality = '${place.subLocality}';
          locality = '${place.locality}';
          subAdministrativeArea = '${place.subAdministrativeArea}';
          country = '${place.country}';
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F5),
        title: const Text(
          'Hiker\'s Watch',
        ),
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Gap(25),
              Container(
                width: 350,
                height: 500,
                padding: const EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(35.0),
                      const Center(
                        child: Text(
                          'My Location',
                          style: TextStyle(
                            color: Color(0xFF080A0C),
                            fontSize: 38,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0.03,
                          ),
                        ),
                      ),
                      const Gap(50.0),
                      Row(
                        children: [
                          const Text(
                            'Latitude: ',
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '${position?.latitude ?? ""}',
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      const Gap(5.0),
                      Row(
                        children: [
                          const Text(
                            'Longitude: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '${position?.longitude ?? ""}',
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          )),
                        ],
                      ),
                      const Gap(5.0),
                      Row(
                        children: [
                          const Text(
                            'Altitude: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '${position?.altitude ?? ""}',
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          )),
                        ],
                      ),
                      const Gap(5.0),
                      Row(
                        children: [
                          const Text(
                            'Accuracy: ',
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '${position?.accuracy ?? ""}',
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      const Gap(10.0),
                      const Center(
                        child: Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      postalCode.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  'Postal Code: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  postalCode,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                )),
                              ],
                            )
                          : Container(),
                      const Gap(5.0),
                      street.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  'Street: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  street,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                )),
                              ],
                            )
                          : Container(),
                      const Gap(5.0),
                      subLocality.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  'Sub Locality: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  subLocality,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                )),
                              ],
                            )
                          : Container(),
                      const Gap(5.0),
                      locality.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  'City/Municipality: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  locality,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                )),
                              ],
                            )
                          : Container(),
                      const Gap(5.0),
                      subAdministrativeArea.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  'Province: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  subAdministrativeArea,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                )),
                              ],
                            )
                          : Container(),
                      const Gap(5.0),
                      country.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  'Country: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  country,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                )),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              const Gap(20.0),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WeatherScreen(
                      latitude: position?.latitude ?? 0.0,
                      longitude: position?.longitude ?? 0.0,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  mouseCursor: MaterialStateProperty.all(
                    SystemMouseCursors.click, // Define the cursor type here
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xff273ea5),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                ),
                child: const Text(
                  'Get Weather',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
