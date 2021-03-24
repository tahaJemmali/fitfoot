// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:workspace/AnalyseModule/components/size_config.dart';
import 'package:workspace/AnalyseModule/widgets/stats/components/bar_with_track.dart';
import 'package:workspace/AnalyseModule/widgets/stats/components/default_data_labels.dart';

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
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20, right: 2),
                  child: DataLabelDefault(),
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 60, right: 50, bottom: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: const Color.fromRGBO(203, 164, 199, 1),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Pied Gauche"),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        color: const Color.fromRGBO(140, 198, 64, 1),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text("Pied Droite"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: BarTracker()),
        ],
      ),
    ),
  );
}
