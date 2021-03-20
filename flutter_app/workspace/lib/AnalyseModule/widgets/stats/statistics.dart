// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: customTabbar(),
    );
  }
}

DefaultTabController customTabbar() {
  final tabs = ["Amélioration du pied", "Fréquence d'utilisation"];
  return DefaultTabController(
    length: tabs.length,
    child: Scaffold(
      appBar: AppBar(
        title: Text("Suivi et Statistiques"),
        automaticallyImplyLeading: true,
        bottom: TabBar(
          isScrollable: false,
          indicatorColor: Colors.white,
          tabs: [
            for (final tab in tabs) Tab(text: tab),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Center(
            child: Text("t1"),
          ),
          Center(
            child: Text("t2"),
          ),
        ],
      ),
    ),
  );
}
