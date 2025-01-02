import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.onPickImage, {super.key});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  ImageSource? source;

  void _pickImage() async {
    await showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Pick Image Source',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('Camera'),
                    onTap: () {
                      source = ImageSource.camera;
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      source = ImageSource.gallery;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
    if (source == null) return;
    final imagePicker = ImagePicker();
    final pickImage = await imagePicker.pickImage(
        source: source!, imageQuality: 80, maxWidth: 300);

    if (pickImage == null) return;

    setState(() {
      _pickedImageFile = File(pickImage.path);
    });
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: const AssetImage('lib\\images\\user (1).png'),
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: Text(
              'Add Image',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ))
      ],
    );
  }
}
