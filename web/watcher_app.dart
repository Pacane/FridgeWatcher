// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library tracker.web.tracker_app;

import 'package:polymer/polymer.dart';
import 'package:fridge_watcher/models.dart';
import 'package:fridge_watcher/seed.dart' as seed;
import 'package:fridge_watcher/router.dart';
import 'package:fridge_watcher/event_bus.dart';
import 'package:fridge_watcher/page_change_event.dart';

@CustomTag('watcher-app')
class WatcherApp extends PolymerElement {
  bool get applyAuthorStyles => true;
  @observable Router router = new Router();
  bool debugMode = true;

  WatcherApp.created() : super.created() {
    eventBus.on(PageChangeEvent).listen((PageChangeEvent event) {
      if (event.path.toString() == '/foo') {
        shadowRoot.querySelector("h2").text = "Foo!";
      }
    });
  }

  void notFound(String path) {
//    var pathUri = Uri.parse(path);
//    if (pathUri.pathSegments.length > 0) showHomePage = false;
//    if (pathUri.pathSegments.length > 0 && !reservedPaths.contains(Uri.parse(path).pathSegments[0])) {
//      String alias = Uri.parse(path).pathSegments[0];
//      // Check the app cache for the community.
//      changeCommunity(alias).then((bool success) {
//        if (pathUri.pathSegments.length == 1) {
//          router.selectedPage = 'lobby';
//        } else {
//          // If we're at <community>/<something>, see if <something> is a valid page.
//          switch (pathUri.pathSegments[1]) {
//            case 'people':
//              pageTitle = "People";
//              router.selectedPage = 'people';
//              break;
//            case 'events':
//              pageTitle = 'Events';
//              router.selectedPage = 'events';
//              break;
//            case 'feed':
//              pageTitle = 'Feed';
//              router.selectedPage = 'feed';
//              break;
//            case 'announcements':
//              pageTitle = 'Announcements';
//              router.selectedPage = 'announcements';
//              break;
//            default:
//              pageTitle = "default";
//              print('404: ' + path);
//          }
//        }
//      });
//    }
  }

  void globalHandler(String path) {
//    if (router.selectedPage != '/foo') showHomePage = false;

    if (this.debugMode) print("Global handler fired at: $path");

    /* TODO: Things like G tracking could be handled here. */
//      if (js.context['_gaq'] != null) {
//        js.context._gaq.push(js.array(['_trackPageview', path]));
//        js.context._gaq.push(js.array(['b._trackPageview', path]));
//      }
  }
}
