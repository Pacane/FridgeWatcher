import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:shelf_static/src/util.dart';
import 'package:shelf/src/response.dart';
import 'package:mime/mime.dart' as mime;
import 'dart:async';

Future main() async {
  var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests())
  .addHandler(await _echoRequest);

  io.serve(handler, 'localhost', 8080).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

Future<shelf.Response> _echoRequest(shelf.Request request) async {
  String basePath = 'web/';


  File file = null;
  file = new File.fromUri(new Uri.file(basePath + request.url.toString()));

  if (!await file.exists()) {
    file = new File.fromUri(new Uri.file(basePath + 'index.html'));
  }

  var fileStat = file.statSync();
  var ifModifiedSince = request.ifModifiedSince;

  if (ifModifiedSince != null) {
    var fileChangeAtSecResolution = toSecondResolution(fileStat.changed);
    if (!fileChangeAtSecResolution.isAfter(ifModifiedSince)) {
      return new Response.notModified();
    }
  }

  var headers = <String, String>{
    HttpHeaders.CONTENT_LENGTH: fileStat.size.toString(),
  };

  var contentType = mime.lookupMimeType(file.path);
  if (contentType != null) {
    headers[HttpHeaders.CONTENT_TYPE] = contentType;
  }

  return new Response.ok(file.openRead(), headers: headers);
}