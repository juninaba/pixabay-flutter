import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List imageList = [];

  Future<void> fetchImages(String text) async {
    final response = await Dio().get(
     'https://pixabay.com/api/',
     queryParameters: {
      'key': '30777988-554f88de1fcac32563a9040fe',
      'q': text,
      'image_type': 'photo',
      'per_page': 100,
     }
    );
    imageList = response.data['hits'];
    setState(() {
      
    });
  }

  Future<void> shareImage(String url) async {
    final dir = await getTemporaryDirectory();
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      )
    );

    final imageFile = await File('${dir.path}/image.png').writeAsBytes(response.data);

    await Share.shareFiles([imageFile.path]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImages('花');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            print(text);
            fetchImages(text);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3
        ),
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> image = imageList[index];
          return InkWell(
            onTap: () async {
              shareImage(image['webformatURL']);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  image['previewURL'],
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 14,
                        ),
                        Text(image['likes'].toString()),
                      ],
                    )
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
