import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/provider/detail/restaurant_detail_provider.dart';
import 'package:resto_radar/static/result_state.dart';

class ReviewForm extends StatefulWidget {
  final String restaurantId;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const ReviewForm({
    super.key,
    required this.restaurantId,
    this.onSuccess,
    this.onCancel,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview(RestaurantDetailProvider provider) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    final success = await provider.postReview(
      id: widget.restaurantId,
      name: _nameController.text.trim(),
      review: _reviewController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      _nameController.clear();
      _reviewController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ulasan berhasil dikirim!'),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 2),
        ),
      );

      widget.onSuccess?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal mengirim ulasan'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _cancelForm() {
    widget.onCancel?.call();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        final isSubmitting = provider.state is LoadingState;

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Tambah Ulasan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama Anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama harus diisi';
                  }
                  if (value.trim().length < 2) {
                    return 'Nama minimal 2 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Review Field
              TextFormField(
                controller: _reviewController,
                decoration: InputDecoration(
                  labelText: 'Ulasan',
                  hintText: 'Bagikan pengalaman Anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                minLines: 3,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ulasan harus diisi';
                  }
                  if (value.trim().length < 10) {
                    return 'Ulasan minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSubmitting ? null : _cancelForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Submit Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () => _submitReview(provider),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
