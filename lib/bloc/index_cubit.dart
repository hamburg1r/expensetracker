import 'package:flutter_bloc/flutter_bloc.dart';

class IndexCubit extends Cubit<int> {
  IndexCubit() : super(0);

  Future<void> setIndex(int index) async {
    emit(index);
  }
}
