import 'package:flutter/material.dart';
import 'dart:io'; // Import this to use File
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../../common/color_extenstion.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const EditBookPage({super.key, required this.bookData});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _authorController;
  late TextEditingController _priceController;
  late TextEditingController _publisherController;
  late TextEditingController _lengthController;
  late TextEditingController _languageController;
  late TextEditingController _descriptionController;
  File? _image; // This will store the selected image

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.bookData['name']);
    _authorController = TextEditingController(text: widget.bookData['author']);
    _priceController = TextEditingController(text: widget.bookData['price'].toString());
    _publisherController = TextEditingController(text: widget.bookData['publisher']);
    _lengthController = TextEditingController(text: widget.bookData['length'].toString());
    _languageController = TextEditingController(text: widget.bookData['language']);
    _descriptionController = TextEditingController(text: widget.bookData['description']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _publisherController.dispose();
    _lengthController.dispose();
    _languageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle save functionality here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book details updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
        title: Text(
          "Edit Book",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Book Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Book Name',
                icon: Icons.book,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _authorController,
                labelText: 'Author',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _priceController,
                labelText: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _publisherController,
                labelText: 'Publisher',
                icon: Icons.store,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _lengthController,
                labelText: 'Length (pages)',
                icon: Icons.format_list_numbered,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _languageController,
                labelText: 'Language',
                icon: Icons.language,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 10),

              // Image Picker Section
              const Text(
                'Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _image != null
                      ? Image.file(
                    _image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: 100,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: TColor.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
