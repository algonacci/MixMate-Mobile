import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class RecommendationPage extends StatefulWidget {
  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  File? _image;
  List<Map<String, dynamic>> _outfits = [];
  String? _gender;
  String? _race;
  String? _style;
  bool _isFetching = false;

  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> sendImage() async {
    if (_image != null) {
      setState(() {
        _isFetching = true;
      });

      final url = Uri.parse('https://predict-dn2kyiya7a-et.a.run.app/predict');

      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final decodedResponse = utf8.decode(responseData);
        final data = jsonDecode(decodedResponse);

        setState(() {
          _outfits = List<Map<String, dynamic>>.from(data['outfits']);
          _gender = data['gender'];
          _race = data['race'];
          _style = data['style'];
          _isFetching = false;
        });
      } else {
        setState(() {
          _isFetching = false;
        });
        print('Failed to send image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_image != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => getImage(ImageSource.gallery),
                    child: Text('Select from Gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () => getImage(ImageSource.camera),
                    child: Text('Take a Photo'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isFetching ? null : sendImage,
                child: _isFetching
                    ? CircularProgressIndicator()
                    : Text('Recommend'),
              ),
              SizedBox(height: 16),
              if (_gender != null || _race != null || _style != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        if (_gender != null)
                          Text(
                            'Gender: $_gender',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        if (_race != null)
                          Text(
                            'Race: $_race',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        if (_style != null)
                          Text(
                            'Style: $_style',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16),
              if (_isFetching)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (_outfits.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = _outfits[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              outfit['images'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  outfit['item_name'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Price: ${outfit['price']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
