import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  Response response = await Dio().get(
   'https://pixabay.com/api/?key=30777988-554f88de1fcac32563a9040fe&q=$text&image_type=photo&pretty=true'
  );
  // print(response.data);
  imageList = response.data['hits'];
  setState(() {
    
  });
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
          return Image.network(image['previewURL']);
        },
      ),
    );
  }
}
