import 'dart:math';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class HighScoreCubit extends HydratedCubit<int> {
  HighScoreCubit() : super(0);

  void setScore(int score) {
    final highScore = max(state, score);
    emit(highScore);
  }


  @override
  int? fromJson(Map<String, dynamic> json) {
    final highScore = json['highScore'] as int?;

    return highScore ?? 0;
  }

  @override
  Map<String, dynamic>? toJson(int state) {
    return {'highScore': state};
  }
}
