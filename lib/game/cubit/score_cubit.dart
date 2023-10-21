import 'package:bloc/bloc.dart';

class ScoreCubit extends Cubit<int> {
  ScoreCubit() : super(0);

  void setScore(int score) {
    emit(score);
  }
}
