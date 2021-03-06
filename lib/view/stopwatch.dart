// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library stopwatch.view;

import 'dart:html';
import 'package:purity/purity.dart' as purity;
import 'package:purity_stopwatch_example/interface/stopwatch.dart';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_button.dart';

@CustomTag('stopwatch-element')
class StopwatchElement extends PolymerElement with purity.Receiver{

  @published
  String counter;
  StopwatchConsumer consumer;
  PaperButton stopButton;
  PaperButton startButton;
  PaperButton resetButton;

  StopwatchElement.created() : super.created();

  @override
  void attached() {
    super.attached();
    startButton = $['startButton'];
    stopButton = $['stopButton'];
    resetButton = $['resetButton'];
  }

  @override
  void detached() {
    super.detached();
  }

  void start(Event e, var detail, Node target) {
    consumer.source.start();
  }

  void stop(Event e, var detail, Node target) {
    consumer.source.stop();
  }

  void reset(Event e, var detail, Node target) {
    consumer.source.reset();
  }

  void _initSourceBinding(){
    listen(consumer.source, DurationChange, _handleDurationChange);
    consumer.source.reset();
  }

  String _durationToDisplayString(Duration du){
    var seconds = du.inSeconds % 60;
    seconds = seconds < 10? '0$seconds':'$seconds';
    var minutes = du.inMinutes % 60;
    minutes = minutes < 10? '0$minutes':'$minutes';
    var hours = du.inHours;
    hours = hours < 10? '0$hours':'$hours';
    return '$hours : $minutes : $seconds';
  }

  void _handleDurationChange(purity.Event<DurationChange> e){
    counter = _durationToDisplayString(e.data.duration);
  }
}

class StopwatchConsumer extends purity.Consumer{
  final StopwatchElement view = new Element.tag('stopwatch-element');

  StopwatchConsumer(src) : super(src){
    registerStopwatchTranTypes();
    view.consumer = this;
    view._initSourceBinding();
  }

  void dispose(){
    view.remove();
    super.dispose();
  }
}
