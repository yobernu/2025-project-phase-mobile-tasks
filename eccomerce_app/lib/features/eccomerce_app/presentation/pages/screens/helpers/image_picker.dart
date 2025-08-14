import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImagePickerService {
  final ImagePicker picker;

  ImagePickerService({ImagePicker? picker}) : picker = picker ?? ImagePicker();

  Future<File?> pickAndSaveImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = p.basename(pickedFile.path);
    final File savedImage = await File(
      pickedFile.path,
    ).copy('${appDir.path}/$fileName');

    return savedImage;
  }
}
