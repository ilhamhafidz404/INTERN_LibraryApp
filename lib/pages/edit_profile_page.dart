import 'package:flutter/material.dart';
import 'package:intern_libraryapp/services/profile_service.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final nisnController = TextEditingController();
  final motherNameController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  final List<String> genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> levelOptions = ['X', 'XI', 'XII'];

  String? gender;
  String? level;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final profile = await ProfileService().showProfile();

      setState(() {
        nameController.text = profile.name;
        nikController.text = profile.nik;
        nisnController.text = profile.nisn;
        motherNameController.text = profile.motherName;
        placeOfBirthController.text = profile.placeOfBirth;

        // Format tanggal ke dd-MM-yyyy
        final formattedDate = DateFormat(
          'dd-MM-yyyy',
        ).format(profile.dateOfBirth);
        dateOfBirthController.text = formattedDate;

        gender = profile.gender == 'F' ? 'Perempuan' : 'Laki-laki';
        if (!genderOptions.contains(gender)) gender = null;

        level = profile.level;
        if (!levelOptions.contains(level)) level = null;

        isLoading = false;
      });
    } catch (e) {
      print('Gagal load profile: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat profil')));
    }
  }

  void saveForm() async {
    if (_formKey.currentState!.validate()) {
      await ProfileService().updateProfile(
        name: nameController.text,
        nik: nikController.text,
        nisn: nisnController.text,
        placeOfBirth: placeOfBirthController.text,
        dateOfBirth: dateOfBirthController.text,
        motherName: motherNameController.text,
        gender: gender == 'Perempuan' ? 'F' : 'M',
        level: level ?? "X",
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Data berhasil disimpan')));
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
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    nisnController.dispose();
    motherNameController.dispose();
    placeOfBirthController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Nama Lengkap',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: nikController,
                      decoration: inputDecoration.copyWith(labelText: 'NIK'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: nisnController,
                      decoration: inputDecoration.copyWith(labelText: 'NISN'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: motherNameController,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Nama Ibu',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: placeOfBirthController,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Tempat Lahir',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: dateOfBirthController,
                      readOnly: true,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Tanggal Lahir',
                        hintText: 'dd-mm-yyyy',
                      ),
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final currentText = dateOfBirthController.text;
                        final initialDate = currentText.isNotEmpty
                            ? DateFormat('dd-MM-yyyy').parse(currentText)
                            : DateTime(2005);

                        final picked = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          final formatted = DateFormat(
                            'dd-MM-yyyy',
                          ).format(picked);
                          dateOfBirthController.text = formatted;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: genderOptions.contains(gender) ? gender : null,
                      decoration: inputDecoration.copyWith(
                        labelText: 'Jenis Kelamin',
                      ),
                      items: genderOptions
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => gender = value),
                      validator: (value) =>
                          value == null ? 'Wajib dipilih' : null,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: levelOptions.contains(level) ? level : null,
                      decoration: inputDecoration.copyWith(labelText: 'Kelas'),
                      items: levelOptions
                          .map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => level = value),
                      validator: (value) =>
                          value == null ? 'Wajib dipilih' : null,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: saveForm,
                      child: const Text('Simpan Perubahan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFed5d5e),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}
