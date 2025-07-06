import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/presentation/home/bloc/detail/detail_bloc.dart';
import 'package:icondo/presentation/home/bloc/detail/detail_event.dart';

class HomeDetailPage extends StatefulWidget {
  final String imageUrl;

  const HomeDetailPage({super.key, required this.imageUrl});

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(),
      child: _HomeDetailPageContent(imageUrl: widget.imageUrl),
    );
  }
}

class _HomeDetailPageContent extends StatelessWidget {
  final String imageUrl;

  const _HomeDetailPageContent({required this.imageUrl});

  void _downloadImage(BuildContext context) {
    context.read<DetailBloc>().add(DownloadImage(imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xff333333),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _downloadImage(context),
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
          SizedBox(height: 40),
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
        ],
      ),
    );
  }
}
