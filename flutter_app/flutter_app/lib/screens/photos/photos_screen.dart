import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../../core/theme.dart";
import "../../models/site_photo.dart";
import "../../providers/data_provider.dart";

class PhotosScreen extends StatelessWidget {
  final int projectId;
  const PhotosScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Photos du chantier")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickPhoto(context),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add_a_photo),
        label: const Text("Ajouter"),
      ),
      body: Consumer<DataProvider>(
        builder: (context, data, _) {
          final photos = data.photosForProject(projectId);
          if (photos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library_outlined, size: 64, color: AppColors.mutedForeground.withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  const Text("Aucune photo", style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: photos.length,
            itemBuilder: (_, i) => _PhotoTile(photo: photos[i]),
          );
        },
      ),
    );
  }

  void _pickPhoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Ajouter une photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: const Text("Prendre une photo"),
              onTap: () async {
                Navigator.pop(context);
                await _capture(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.photo_library, color: AppColors.accent),
              ),
              title: const Text("Choisir depuis la galerie"),
              onTap: () async {
                Navigator.pop(context);
                await _capture(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _capture(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 80);
    if (file == null || !context.mounted) return;
    await context.read<DataProvider>().addPhoto(projectId, file.path, "progress");
  }
}

class _PhotoTile extends StatelessWidget {
  final SitePhoto photo;
  const _PhotoTile({required this.photo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          photo.imageUrl != null
              ? Image.network(photo.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder())
              : _placeholder(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                ),
              ),
              child: Text(
                photo.description.isNotEmpty ? photo.description : photo.photoType,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.muted,
      child: const Icon(Icons.image, size: 48, color: AppColors.mutedForeground),
    );
  }
}
