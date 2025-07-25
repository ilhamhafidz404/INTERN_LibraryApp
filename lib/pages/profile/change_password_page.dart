import 'package:flutter/material.dart';
import 'package:intern_libraryapp/services/profile_service.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

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
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void changePassword() async {
    if (_formKey.currentState!.validate()) {
      await ProfileService().changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        confirmationNewPassword: confirmPasswordController.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Password berhasil diubah')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ubah Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: oldPasswordController,
                obscureText: obscureOld,
                decoration: inputDecoration.copyWith(
                  labelText: 'Password Lama',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureOld ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => obscureOld = !obscureOld),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                obscureText: obscureNew,
                decoration: inputDecoration.copyWith(
                  labelText: 'Password Baru',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => obscureNew = !obscureNew),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib diisi';
                  } else if (value.length < 6) {
                    return 'Minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                decoration: inputDecoration.copyWith(
                  labelText: 'Konfirmasi Password Baru',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => obscureConfirm = !obscureConfirm),
                  ),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Konfirmasi tidak sama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: isLoading ? null : changePassword,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFed5d5e),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
