// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:spray/Profile.dart';
import 'package:spray/groupview.dart';
import 'package:spray/timer.dart';
import 'add.dart';
import 'board.dart';
import 'home.dart';
import 'login.dart';
import 'members.dart';

class SprayApp extends StatelessWidget {
  const SprayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Spray',
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (BuildContext context) => const HomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/timer': (BuildContext context) => TimerPage(),
        //'/board': (BuildContext context) => const BoardPage(),
        '/members': (BuildContext context) => MemberPage(),
        '/group': (BuildContext context) => GroupPage(),
        '/add': (BuildContext context) => AddPage(),
        '/profile': (BuildContext context) => Profile(),

      },
    );
  }
}

