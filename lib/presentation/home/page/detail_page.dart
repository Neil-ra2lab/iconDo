import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../services/image_download_service.dart';

class DetailPage extends StatefulWidget {
  final String imageUrl;

  const DetailPage({super.key, required this.imageUrl});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<void> _downloadImage(BuildContext context) async {
    try {
      await ImageDownloadService.downloadAndResizeImage(widget.imageUrl);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xff333333),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              right: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await _downloadImage(context);
                  },
                  icon: Image.asset(
                    'assets/images/ic_download.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    'assets/images/ic_close.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.white, size: 64),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
