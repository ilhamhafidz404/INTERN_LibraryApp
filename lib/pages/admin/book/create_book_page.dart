import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/services/book_service.dart';

class AdminCreateBookPage extends StatefulWidget {
  @override
  _AdminCreateBookPageState createState() => _AdminCreateBookPageState();
}

class _AdminCreateBookPageState extends State<AdminCreateBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitBook() async {
    try {
      await BookService().storeBook(
        title: _titleController.text,
        publisher: _publisherController.text,
        author: _authorController.text,
        isbn: _isbnController.text,
        year: _yearController.text,
        total: _totalController.text,
        coverFile: _image!,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Buku berhasil ditambahkan')));

      Navigator.pop(context); // kembali ke halaman sebelumnya
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan buku')));
    }
  }

  final inputDecoration = const InputDecoration(
    labelStyle: TextStyle(color: Colors.grey),
    floatingLabelStyle: TextStyle(color: Colors.black54),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black38, width: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: inputDecoration.copyWith(labelText: 'Judul'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _publisherController,
                decoration: inputDecoration.copyWith(labelText: 'Penerbit'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _authorController,
                decoration: inputDecoration.copyWith(labelText: 'Penulis'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _isbnController,
                decoration: inputDecoration.copyWith(labelText: 'ISBN'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _yearController,
                decoration: inputDecoration.copyWith(labelText: 'Tahun'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _totalController,
                decoration: inputDecoration.copyWith(labelText: 'Total'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _image != null
                  ? Image.file(_image!, height: 200)
                  : Text('Belum ada cover dipilih'),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Pilih Cover'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitBook,
                child: Text('Simpan Buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
