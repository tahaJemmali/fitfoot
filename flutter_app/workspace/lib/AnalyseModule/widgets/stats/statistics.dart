// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:workspace/AnalyseModule/components/size_config.dart';
import 'package:workspace/AnalyseModule/widgets/stats/components/amelioration.dart';
import 'package:workspace/AnalyseModule/widgets/stats/components/useFrequence.dart';
import 'package:workspace/Login/utils/constants.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, body: customTabbar(context));
  }
}

DefaultTabController customTabbar(BuildContext c) {
  final tabs = [getTranslated(c, "freq"), getTranslated(c, "amelt")];
  return DefaultTabController(
    length: tabs.length,
    initialIndex: 0,
    child: Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(c, "suiviand")),
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
          Frequence(),
          Amelioration(),
        ],
      ),
    ),
  );
}
