import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:see_our_sounds/src/core/core.dart';
import 'package:see_our_sounds/src/core/app_constants.dart';
import 'package:see_our_sounds/src/models/audio_tagging_model.dart';
import 'package:sound_stream/sound_stream.dart';

final audioTaggingServiceProvider =
    Provider((ref) => AudioTaggingServiceImpl());

abstract class AudioTaggingService {
  Future<void> getPong();

  Future<AudioTaggingModel> postAudio(Uint8List data);
}

class AudioTaggingServiceImpl extends AudioTaggingService {
  RecorderStream recorderStream = RecorderStream();

  @override
  Future<void> getPong() async {
    var request =
        http.Request('GET', Uri.parse(AppUri.uriBase + AppUri.uriPing));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  @override
  Future<AudioTaggingModel> postAudio(Uint8List data) async {
    final uri = Uri.parse(AppUri.uriBase + AppUri.uriUint);
    var response = await http.post(uri, body: data);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return AudioTaggingModel.fromJson(responseBody);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
