import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  final _bioController = TextEditingController();

  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _avatarUrlController.dispose();
    _bioController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    await _viewModel.loadProfile();

    if (!mounted) return;

    final profile = _viewModel.profile;
    if (profile == null) {
      final message = _viewModel.error;
      if (message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
      return;
    }

    _fullNameController.text = profile.fullName;
    _emailController.text = profile.email;
    _avatarUrlController.text = profile.avatarUrl ?? '';
    _bioController.text = profile.bio ?? '';
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final isSuccess = await _viewModel.saveProfile(
      fullName: _fullNameController.text,
      avatarUrl: _avatarUrlController.text,
      bio: _bioController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSuccess
              ? 'Profile updated successfully.'
              : (_viewModel.error ??
                    'Failed to save profile. Please try again.'),
        ),
      ),
    );

    if (isSuccess) {
      final profile = _viewModel.profile;
      if (profile != null) {
        _fullNameController.text = profile.fullName;
        _emailController.text = profile.email;
        _avatarUrlController.text = profile.avatarUrl ?? '';
        _bioController.text = profile.bio ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('My Profile')),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final horizontalPadding = constraints.maxWidth >= 900
                        ? constraints.maxWidth * 0.22
                        : constraints.maxWidth >= 650
                        ? constraints.maxWidth * 0.14
                        : 20.0;

                    final avatarUrl = _avatarUrlController.text.trim();
                    final parsed = Uri.tryParse(avatarUrl);
                    final hasNetworkAvatar =
                        parsed != null &&
                        (parsed.isScheme('http') || parsed.isScheme('https'));

                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        20,
                        horizontalPadding,
                        24,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: CircleAvatar(
                                  radius: 38,
                                  backgroundColor: AppTheme.gradientStart,
                                  backgroundImage: hasNetworkAvatar
                                      ? NetworkImage(avatarUrl)
                                      : null,
                                  child: hasNetworkAvatar
                                      ? null
                                      : const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: AppTheme.primary,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _fullNameController,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _emailController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _avatarUrlController,
                                keyboardType: TextInputType.url,
                                onChanged: (_) => setState(() {}),
                                decoration: const InputDecoration(
                                  labelText: 'Avatar URL',
                                  prefixIcon: Icon(Icons.image_outlined),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _bioController,
                                minLines: 3,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  labelText: 'Bio',
                                  alignLabelWithHint: true,
                                  prefixIcon: Icon(Icons.edit_note_outlined),
                                ),
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _viewModel.isSaving
                                      ? null
                                      : _saveProfile,
                                  child: _viewModel.isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Save Changes'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
