import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern_libraryapp/models/book_response.dart';
import 'package:intern_libraryapp/services/book_service.dart';

class AdminEditBookPage extends StatefulWidget {
  final Book book;

  const AdminEditBookPage({required this.book});

  @override
  _AdminEditBookPageState createState() => _AdminEditBookPageState();
}

class _AdminEditBookPageState extends State<AdminEditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _publisherController;
  late TextEditingController _authorController;
  late TextEditingController _isbnController;
  late TextEditingController _yearController;
  late TextEditingController _totalController;

  File? _newImage;

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
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _publisherController = TextEditingController(text: widget.book.publisher);
    _authorController = TextEditingController(text: widget.book.author);
    _isbnController = TextEditingController(text: widget.book.isbn);
    _yearController = TextEditingController(text: widget.book.year.toString());
    _totalController = TextEditingController(
      text: widget.book.total.toString(),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateBook() async {
    try {
      await BookService().updateBook(
        id: widget.book.id,
        title: _titleController.text,
        publisher: _publisherController.text,
        author: _authorController.text,
        isbn: _isbnController.text,
        year: _yearController.text,
        total: _totalController.text,
        coverFile:
            _newImage ?? File(''), // Kirim file kosong jika tidak diganti
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Buku berhasil diperbarui')));

      Navigator.pop(context); // kembali ke halaman sebelumnya
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui buku')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Buku')),
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
              _newImage != null
                  ? Image.file(_newImage!, height: 200)
                  : widget.book.cover != null
                  ? Image.network(
                      '${dotenv.env['BASE_URL']}/uploads/${widget.book.cover}',
                      height: 200,
                    )
                  : Text('Tidak ada cover'),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Ganti Cover'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateBook,
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
