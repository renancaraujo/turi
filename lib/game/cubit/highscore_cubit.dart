import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class HighScoreCubit extends Cubit<int> {
  HighScoreCubit() : super(0);

  void setScore(int score) {
    final highScore = max(state, score);
    emit(highScore);
  }
}
