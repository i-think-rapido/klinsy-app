
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

const NO_PICTURE = '<none>';

class CameraService {

  CameraService._privateConstructor() {
    WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((value) => _firstCamera = value.first);
  }
  static final CameraService _instance = CameraService._privateConstructor();
  factory CameraService() {
    return _instance;
  }

  late final CameraDescription? _firstCamera;

  CameraDescription get camera {
    return _firstCamera!;
  }

}