// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'category.dart';
import 'category_list_tile.dart';
import 'unit.dart';
import 'unit_converter.dart';
import 'backdrop.dart';

final _backgroundColor = Colors.green[100];

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen();

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  Category _defaultCategory;
  Category _currentCategory;

  final _categories = <Category>[];

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];
  // NOTE: The list indeces are parallell with those of _categoryNames.
  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  @override
  void initState() {
    super.initState();

    // Convert caterory names into a list of Category objects.
    for (var i = 0; i < _categoryNames.length; i++) {
      var category = Category(
        name: _categoryNames[i],
        color: _baseColors[i],
        iconLocation: Icons.cake,
        units: _retrieveUnitList(_categoryNames[i]),
      );

      _categories.add(category);

      if (i == 0) {
        _defaultCategory = category;
      }
    }
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  Widget _buildBackPanel({orientation: Orientation}) {
    var _categoryList;
    if (orientation == Orientation.portrait) {
      _categoryList = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CategoryListTile(
            category: _categories[index],
            onTap: _onCategoryTap,
          );
        },
        itemCount: _categories.length,
      );
    } else {
      _categoryList = GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _categories.map((Category c) {
          return CategoryListTile(
            category: c,
            onTap: _onCategoryTap,
          );
        }).toList(),
      );
    }

    return Container(
      color: _backgroundColor,
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _categoryList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      currentCategory: _currentCategory ?? _defaultCategory,
      frontTitle: Text('Unit Converter'),
      frontPanel: _currentCategory == null
          ? UnitConverter(category: _defaultCategory)
          : UnitConverter(category: _currentCategory),
      backTitle: Text('Select a Category'),
      backPanel:
          _buildBackPanel(orientation: MediaQuery.of(context).orientation),
    );
  }
}
