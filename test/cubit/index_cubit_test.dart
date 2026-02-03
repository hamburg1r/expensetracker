import 'package:bloc_test/bloc_test.dart';
import 'package:expensetracker/cubit/index_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IndexCubit', () {
    test('initial state is 0', () {
      final indexCubit = IndexCubit();
      expect(indexCubit.state, 0);
      indexCubit.close();
    });

    blocTest<IndexCubit, int>(
      'emits [1] when setIndex is called with 1',
      build: () => IndexCubit(),
      act: (cubit) => cubit.setIndex(1),
      expect: () => [1],
    );

    blocTest<IndexCubit, int>(
      'emits [5] when setIndex is called with 5',
      build: () => IndexCubit(),
      act: (cubit) => cubit.setIndex(5),
      expect: () => [5],
    );
  });
}
