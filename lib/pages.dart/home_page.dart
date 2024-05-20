import 'package:flutter/material.dart';
import 'package:nyobaflutter/models.dart/album.dart';
import 'package:nyobaflutter/services.dart/album_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Album> lastAlbum = [];
  bool isLoading = true;

  void fetchAlbum() async {
    try {
      final result = await AlbumService.fetchAlbum();
      setState(() {
        lastAlbum = result;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch albums: $e');
    }
  }

  void deleteAlbum(int id) async {
    try {
      await AlbumService.deleteAlbum(id);
      setState(() {
        lastAlbum.removeWhere((album) => album.id == id);
      });
    } catch (e) {
      print('Failed to delete album: $e');
    }
  }

  void updateAlbum(Album album) async {
    try {
      await AlbumService.updateAlbum(album);
      setState(() {
        final index = lastAlbum.indexWhere((a) => a.id == album.id);
        if (index != -1) {
          lastAlbum[index] = album;
        }
      });
    } catch (e) {
      print('Failed to update album: $e');
    }
  }

  void showEditDialog(Album album) {
    final titleController = TextEditingController(text: album.title);
    final urlController = TextEditingController(text: album.url);
    final thumbnailUrlController =
        TextEditingController(text: album.thumbnailUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: thumbnailUrlController,
                decoration: InputDecoration(labelText: 'Thumbnail URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedAlbum = Album(
                  albumId: album.albumId,
                  id: album.id,
                  title: titleController.text,
                  url: urlController.text,
                  thumbnailUrl: thumbnailUrlController.text,
                );
                updateAlbum(updatedAlbum);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Nova Yoa'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: lastAlbum.length,
              itemBuilder: (context, index) {
                final album = lastAlbum[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(album.thumbnailUrl),
                      ),
                      title: Text('${album.id} ${album.title}'),
                      subtitle: Text(album.url),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => deleteAlbum(album.id),
                            icon: Icon(Icons.delete),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () => showEditDialog(album),
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
