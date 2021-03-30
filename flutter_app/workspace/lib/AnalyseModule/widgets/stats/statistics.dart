// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:workspace/AnalyseModule/components/size_config.dart';
import 'package:workspace/AnalyseModule/widgets/stats/components/amelioration.dart';
import 'package:workspace/AnalyseModule/widgets/stats/components/useFrequence.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return customTabbar();
          });
        }));
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
          Amelioration(
            key: GlobalKey(),
          ),
          Frequence(key: GlobalKey()),
        ],
      ),
    ),
  );
}
