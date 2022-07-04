import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedIamge) imagePicked;
  const UserImagePicker({
    required this.imagePicked,
    Key? key,
  }) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  void _getImage(File? pickedImage) {
    if (pickedImage == null) return;
    setState(() {
      _image = pickedImage;
    });
    widget.imagePicked(pickedImage);
  }

  void _addImage() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => BottomModal(getImage: _getImage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _image != null ? FileImage(_image!) : null,
          backgroundColor: Colors.grey,
        ),
        TextButton.icon(
          onPressed: _addImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
          style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}

class BottomModal extends StatefulWidget {
  final void Function(File file) getImage;
  const BottomModal({
    required this.getImage,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  void _pickImage(XFile image) {
    widget.getImage(File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await ImagePicker().pickImage(
              source: ImageSource.gallery,
              imageQuality: 50,
              maxWidth: 150,
            );
            if (file == null) return;
            _pickImage(file);
          },
          icon: const Icon(Icons.browse_gallery),
          label: const Text('Choose from gallery'),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            Navigator.of(context).pop();
            final file = await ImagePicker().pickImage(
              source: ImageSource.camera,
              imageQuality: 50,
              maxWidth: 150,
            );
            if (file == null) return;
            _pickImage(file);
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take a picture'),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
