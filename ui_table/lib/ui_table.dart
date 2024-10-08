import 'dart:math';

import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class UiTable extends StatefulWidget {
  final List<double> cellsWidth;
  final List<List<Widget>> data;
  final double headerHeight;
  final double cellHeight;
  final BorderSide? borderSide;

  const UiTable({
    super.key,
    required this.cellsWidth,
    required this.data,
    this.borderSide,
    this.headerHeight = 40,
    this.cellHeight = 40,
  });

  @override
  State<UiTable> createState() => _UiTableState();
}

class _UiTableState extends State<UiTable> {
  final double track = 10;
  late final double leftFix;
  late final double rightFix;
  late final BorderSide borderSide;

  late ScrollController scrollVerticalLeftFix;
  late ScrollController scrollVerticalRightFix;
  late ScrollController scrollVerticalCenter;
  late ScrollController scrollVerticalBar;

  late ScrollController scrollHorizontalLeftFix;
  late ScrollController scrollHorizontalCenter;
  late ScrollController scrollHorizontalBar;

  final LinkedScrollControllerGroup _verticalControllers =
      LinkedScrollControllerGroup();

  final LinkedScrollControllerGroup _horizontalControllers =
      LinkedScrollControllerGroup();
  

  late double headerHeight;
  late double cellHeight;

  @override
  void initState() {
    super.initState();

    headerHeight = widget.headerHeight.roundToDouble();
    cellHeight = widget.cellHeight.roundToDouble();

    for(int i = 0;i<widget.cellsWidth.length;i++){
      widget.cellsWidth[i] = widget.cellsWidth[i].roundToDouble();
    }

    leftFix = widget.cellsWidth.first;
    rightFix = widget.cellsWidth.last + track;

    borderSide = widget.borderSide ?? const BorderSide(color: Colors.grey);

    scrollVerticalLeftFix = _verticalControllers.addAndGet();
    scrollVerticalRightFix = _verticalControllers.addAndGet();
    scrollVerticalCenter = _verticalControllers.addAndGet();
    scrollVerticalBar = _verticalControllers.addAndGet();

    scrollHorizontalLeftFix = _horizontalControllers.addAndGet();
    scrollHorizontalCenter = _horizontalControllers.addAndGet();
    scrollHorizontalBar = _horizontalControllers.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeRight: true,
      removeLeft: true,
      removeBottom: true,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          scrollbars: false,
        ),
        child: KeyboardListener(
          autofocus: true,
          onKeyEvent: _handleKeyEvent,
          focusNode: FocusNode(),
          child: Column(
            children: [
              Row(
                children: [
                  _buildHeaderLeft(),
                  Expanded(
                    child: _buildHeaderCenter(),
                  ),
                  _buildHeaderRight(),
                  SizedBox(width: track),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildBodyLeft(),
                    Expanded(
                      child: _buildBodyCenter(),
                    ),
                    _buildBodyRight(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //body ====
  Column _buildBodyCenter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollHorizontalCenter,
            child: SizedBox(
              width: widget.cellsWidth
                  .sublist(1, widget.cellsWidth.length - 1)
                  .reduce((a, b) => a + b),
              child: ListView.builder(
                controller: scrollVerticalCenter,
                itemCount: widget.data.length - 1,
                itemBuilder: (BuildContext context, int index) => Container(
                  height: cellHeight,
                  decoration: index == 0
                      ? null
                      : BoxDecoration(
                          border: Border(
                            top: borderSide,
                          ),
                        ),
                  child: Row(
                    children: widget.data[index + 1]
                        .sublist(1, widget.data[index + 1].length - 1)
                        .asMap()
                        .entries
                        .map(
                          (MapEntry<int, Widget> e) => Container(
                            height: double.infinity,
                            width: widget.cellsWidth[e.key + 1],
                            decoration: e.key == 0
                                ? null
                                : BoxDecoration(
                                    border: Border(
                                      left: borderSide,
                                    ),
                                  ),
                            child: e.value,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: track,
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollHorizontalBar,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: scrollHorizontalBar,
              itemCount: widget.cellsWidth.length - 2,
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: widget.cellsWidth[index + 1],
              ),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _buildBodyRight() {
    return SizedBox(
      width: rightFix,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollVerticalRightFix,
                    itemCount: widget.data.length - 1,
                    itemBuilder: (BuildContext context, int index) => Container(
                      height: cellHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          top: index == 0 ? BorderSide.none : borderSide,
                          left: borderSide,
                        ),
                      ),
                      child: widget.data[index + 1].last,
                    ),
                  ),
                ),
                SizedBox(
                  width: track,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollVerticalBar,
                    child: ListView.builder(
                      controller: scrollVerticalBar,
                      itemCount: widget.data.length - 1,
                      itemBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: cellHeight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: track),
        ],
      ),
    );
  }

  SizedBox _buildBodyLeft() {
    return SizedBox(
      width: leftFix,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollVerticalLeftFix,
              itemCount: widget.data.length - 1,
              itemBuilder: (BuildContext context, int index) => Container(
                height: cellHeight,
                decoration: BoxDecoration(
                  border: Border(
                    top: index == 0 ? BorderSide.none : borderSide,
                    right: borderSide,
                  ),
                ),
                child: widget.data[index + 1].first,
              ),
            ),
          ),
          SizedBox(height: track),
        ],
      ),
    );
  }

  //head ===
  Container _buildHeaderRight() {
    return Container(
      width: rightFix - track,
      height: headerHeight,
      decoration: BoxDecoration(
        border: Border(
          left: borderSide,
          bottom: borderSide,
        ),
      ),
      child: widget.data.first.last,
    );
  }

  SizedBox _buildHeaderCenter() {
    return SizedBox(
      height: headerHeight,
      child: ListView.builder(
        controller: scrollHorizontalLeftFix,
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.first.length - 2,
        itemBuilder: (BuildContext context, int index) => Container(
          width: widget.cellsWidth[index + 1],
          decoration: BoxDecoration(
            border: Border(
              left: index == 0 ? BorderSide.none : borderSide,
              bottom: borderSide,
            ),
          ),
          child: widget.data.first[index + 1],
        ),
      ),
    );
  }

  Container _buildHeaderLeft() {
    return Container(
      width: leftFix,
      height: headerHeight,
      decoration: BoxDecoration(
        border: Border(
          right: borderSide,
          bottom: borderSide,
        ),
      ),
      child: widget.data.first.first,
    );
  }

  @override
  void dispose() {
    scrollVerticalLeftFix.dispose();
    scrollVerticalRightFix.dispose();
    scrollVerticalCenter.dispose();
    scrollVerticalBar.dispose();
    scrollHorizontalLeftFix.dispose();
    scrollHorizontalCenter.dispose();
    scrollHorizontalBar.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    switch (event.logicalKey.keyLabel) {
      case 'Arrow Right':
     _horizontalControllers.jumpTo(_horizontalControllers.offset + 10);
        break;
      case 'Arrow Left':
      _horizontalControllers.jumpTo(max(0,_horizontalControllers.offset - 10));
        break;
      case 'Arrow Up':
      _verticalControllers.jumpTo(max(0, _verticalControllers.offset + 10));
        break;
      case 'Arrow Down':
      _verticalControllers.jumpTo(max(0, _verticalControllers.offset - 10));
        break;
    }
  }
}
