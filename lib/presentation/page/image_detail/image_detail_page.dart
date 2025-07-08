import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/gen/assets.gen.dart';
import 'package:icondo/presentation/bloc/image_detail/image_detail_bloc.dart';
import 'package:icondo/presentation/bloc/image_detail/image_detail_event.dart';

class ImageDetailPage extends StatefulWidget {
  final String imageUrl;

  const ImageDetailPage({super.key, required this.imageUrl});

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageDetailBloc(),
      child: _HomeDetailPageContent(imageUrl: widget.imageUrl),
    );
  }
}

class _HomeDetailPageContent extends StatelessWidget {
  final String imageUrl;

  const _HomeDetailPageContent({required this.imageUrl});

  void _downloadImage(BuildContext context) {
    context.read<ImageDetailBloc>().add(DownloadImage(imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xff333333),
      body: Stack(
        children: [
          // Main content
          Center(
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
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
          // Fixed top row
          Positioned(
            top: 40,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _downloadImage(context),
                  icon: Image.asset(
                    Assets.images.icDownload.path,
                    width: 30,
                    height: 30,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    Assets.images.icClose.path,
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
