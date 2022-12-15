import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart';

imageResize(XFile xFile) async {
  final image = decodeImage(await xFile.readAsBytes());
  return copyResize(image!, width: 500);
}
