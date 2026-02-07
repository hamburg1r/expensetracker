import 'package:expensetracker/domain/model/debt.dart';
import 'package:expensetracker/domain/model/person.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:expensetracker/cubit/person_cubit.dart';
import 'package:expensetracker/domain/repository/person.dart';
import 'package:expensetracker/domain/repository/debt.dart';
import 'package:expensetracker/domain/cache.dart';

import 'person_cubit_test.mocks.dart';

@GenerateMocks([PersonRepo, DebtRepo, Cache])
void main() {
  group('PersonCubit', () {
    late MockPersonRepo mockPersonRepo;
    late MockDebtRepo mockDebtRepo;
    late MockCache mockCache;

    setUp(() {
      mockPersonRepo = MockPersonRepo();
      mockDebtRepo = MockDebtRepo();
      mockCache = MockCache();
    });

    test('initial state is PersonInitial when initialLoad is false', () {
      final personCubit = PersonCubit(
        mockPersonRepo,
        mockDebtRepo,
        mockCache,
        false,
      );
      expect(personCubit.state, isA<PersonInitial>());
      personCubit.close();
    });

    test('calls loadAll and emits states when initialLoad is true', () async {
      // Arrange
      final people = [Person(id: 1, name: 'John Doe', phoneNumber: '123')];
      when(mockPersonRepo.getAll()).thenAnswer((_) async => people);
      when(
        mockCache.getAll<Person>(),
      ).thenReturn({for (var p in people) p.id: p});
      when(mockCache.addStrong(any)).thenReturn(1);

      // Act
      final personCubit = PersonCubit(
        mockPersonRepo,
        mockDebtRepo,
        mockCache,
        true,
      );

      // Assert
      expect(personCubit.state, isA<PersonLoading>());

      // Wait for the async operations in the constructor to complete
      await personCubit.stream.firstWhere((state) => state is PersonLoaded);

      verify(mockPersonRepo.getAll()).called(1);
      verify(mockCache.addStrong(any)).called(1);

      personCubit.close();
    });

    group('loadAll', () {
      final people = [
        Person(id: 1, name: 'John Doe', phoneNumber: '1234567890'),
      ];

      blocTest<PersonCubit, PersonState>(
        'emits [PersonLoading, PersonLoaded] when successful',
        build: () {
          when(mockPersonRepo.getAll()).thenAnswer((_) async => people);
          when(
            mockCache.getAll<Person>(),
          ).thenReturn({for (var p in people) p.id: p});
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) => cubit.loadAll(),
        expect: () => [
          isA<PersonLoading>(),
          isA<PersonLoaded>().having((s) => s.people, 'people', {
            for (var p in people) p.id: p,
          }),
        ],
        verify: (_) {
          verify(mockPersonRepo.getAll()).called(1);
          verify(mockCache.addStrong(people.first)).called(1);
        },
      );

      blocTest<PersonCubit, PersonState>(
        'emits [PersonLoading, PersonError] when fails',
        build: () {
          when(mockPersonRepo.getAll()).thenThrow(Exception('Failed to load'));
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) => cubit.loadAll(),
        expect: () => [
          isA<PersonLoading>(),
          isA<PersonError>(),
        ],
        verify: (_) {
          verify(mockPersonRepo.getAll()).called(1);
        },
      );
    });

    group('create', () {
      final person = Person(id: 1, name: 'John Doe', phoneNumber: '1234567890');

      blocTest<PersonCubit, PersonState>(
        'calls create on repo and emits PersonLoaded',
        build: () {
          when(mockPersonRepo.create(person)).thenAnswer((_) async => 1);
          when(mockCache.getAll<Person>()).thenReturn({person.id: person});
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) => cubit.create(person),
        expect: () => [
          isA<PersonLoaded>().having((s) => s.people, 'people', {
            person.id: person,
          }),
        ],
        verify: (_) {
          verify(mockPersonRepo.create(person)).called(1);
          verify(mockCache.addStrong(person)).called(1);
        },
      );
    });

    group('remove', () {
      blocTest<PersonCubit, PersonState>(
        'calls delete on repo and emits PersonLoaded',
        build: () {
          when(mockPersonRepo.delete(1)).thenAnswer((_) async => true);
          when(mockCache.getAll<Person>()).thenReturn({});
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) => cubit.remove(1),
        expect: () => [
          isA<PersonLoaded>().having((s) => s.people, 'people', {}),
        ],
        verify: (_) {
          verify(mockPersonRepo.delete(1)).called(1);
          verify(mockCache.remove<Person>(1)).called(1);
        },
      );
    });

    group('update', () {
      final person = Person(id: 1, name: 'John Doe', phoneNumber: '1234567890');

      blocTest<PersonCubit, PersonState>(
        'calls update on repo and emits PersonLoaded',
        build: () {
          when(mockPersonRepo.update(person)).thenAnswer((_) async {});
          when(mockCache.getAll<Person>()).thenReturn({person.id: person});
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) => cubit.update(person),
        expect: () => [
          isA<PersonLoaded>().having((s) => s.people, 'people', {
            person.id: person,
          }),
        ],
        verify: (_) {
          verify(mockPersonRepo.update(person)).called(1);
          verify(mockCache.update(person)).called(1);
        },
      );
    });

    group('getById', () {
      final person = Person(id: 1, name: 'John Doe', phoneNumber: '1234567890');

      test('returns person from cache if exists', () async {
        when(mockCache.get<Person>(1)).thenReturn(person);
        when(mockCache.references(any)).thenReturn(0);
        final personCubit = PersonCubit(
          mockPersonRepo,
          mockDebtRepo,
          mockCache,
          false,
        );

        final result = await personCubit.getById(1);

        expect(result, person);
        verify(mockCache.get<Person>(1)).called(1);
        verifyNever(mockPersonRepo.getById(1));
        personCubit.close();
      });

      blocTest<PersonCubit, PersonState>(
        'fetches from repo if not in cache and emits PersonLoaded',
        build: () {
          when(mockCache.get<Person>(1)).thenReturn(null);
          when(mockPersonRepo.getById(1)).thenAnswer((_) async => person);
          when(mockCache.getAll<Person>()).thenReturn({person.id: person});
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) async {
          final result = await cubit.getById(1);
          expect(result, person);
        },
        expect: () => [
          isA<PersonLoaded>().having((s) => s.people, 'people', {
            person.id: person,
          }),
        ],
        verify: (_) {
          verify(mockPersonRepo.getById(1)).called(1);
          verify(mockCache.addStrong(person)).called(1);
        },
      );

      blocTest<PersonCubit, PersonState>(
        'emits PersonError on failure',
        build: () {
          when(mockCache.get<Person>(1)).thenReturn(null);
          when(mockPersonRepo.getById(1)).thenThrow(Exception('error'));
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) async {
          final result = await cubit.getById(1);
          expect(result, isNull);
        },
        expect: () => [
          isA<PersonError>(),
        ],
      );
    });

    group('getDebtsOwed', () {
      final person = Person(id: 1, name: 'John Doe', phoneNumber: '1234567890');
      final debt = Debt(
        id: 1,
        creditor: person,
        amount: 100,
        date: DateTime.now(),
      );

      blocTest<PersonCubit, PersonState>(
        'emits PersonError when person is not in cache',
        build: () {
          when(mockCache.get<Person>(1)).thenReturn(null);
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) async {
          final result = await cubit.getDebtsOwed(1, 0);
          expect(result, isEmpty);
        },
        expect: () => [
          isA<PersonError>().having(
            (e) => e.message,
            'message',
            'Person with id 1 is not loaded. Debts cannot be fetched.',
          ),
        ],
      );

      test('fetches debts and updates cache on success', () async {
        // Arrange
        final personWithNoDebts = Person(
          id: 1,
          name: 'John Doe',
          phoneNumber: '1234567890',
          debtsOwed: [],
        );
        when(mockCache.get<Person>(1)).thenReturn(personWithNoDebts);
        when(
          mockPersonRepo.getDebtsOwed(1, 0, 20),
        ).thenAnswer((_) async => [debt.id]);
        when(mockDebtRepo.getById(debt.id)).thenAnswer((_) async => debt);
        when(mockCache.addWeak(debt)).thenReturn(1);
        when(mockCache.update(any)).thenReturn(1);

        final cubit = PersonCubit(
          mockPersonRepo,
          mockDebtRepo,
          mockCache,
          false,
        );

        // Act
        final result = await cubit.getDebtsOwed(1, 0);

        // Assert
        expect(result, [debt]);
        verify(mockPersonRepo.getDebtsOwed(1, 0, 20)).called(1);
        verify(mockDebtRepo.getById(debt.id)).called(1);
        verify(mockCache.addWeak(debt)).called(1);

        final verificationResult = verify(mockCache.update(captureAny));
        verificationResult.called(1);
        final capturedPerson = verificationResult.captured.single as Person;
        expect(capturedPerson.debtsOwed, [debt]);
      });

      test(
        'fetches debts and replaces cache on success when replace is true',
        () async {
          // Arrange
          final oldDebt = Debt(
            id: 100,
            creditor: person,
            amount: 50,
            date: DateTime(2023, 1, 1),
          );
          final personWithOldDebts = Person(
            id: 1,
            name: 'John Doe',
            phoneNumber: '1234567890',
            debtsOwed: [oldDebt],
          );
          final newDebt = Debt(
            id: 2,
            creditor: person,
            amount: 200,
            date: DateTime.now(),
          );

          when(mockCache.get<Person>(1)).thenReturn(personWithOldDebts);
          when(
            mockPersonRepo.getDebtsOwed(1, 0, 20),
          ).thenAnswer((_) async => [newDebt.id]);
          when(
            mockDebtRepo.getById(newDebt.id),
          ).thenAnswer((_) async => newDebt);
          when(mockCache.addWeak(newDebt)).thenReturn(1);
          when(mockCache.update(any)).thenReturn(1);
          when(
            mockCache.releaseStrong(oldDebt),
          ).thenReturn(1); // Expect old debt to be released

          final cubit = PersonCubit(
            mockPersonRepo,
            mockDebtRepo,
            mockCache,
            false,
          );

          // Act
          final result = await cubit.getDebtsOwed(1, 0, true); // replace = true

          // Assert
          expect(result, [newDebt]);
          verify(mockPersonRepo.getDebtsOwed(1, 0, 20)).called(1);
          verify(mockDebtRepo.getById(newDebt.id)).called(1);
          verify(mockCache.addWeak(newDebt)).called(1);
          verify(mockCache.releaseStrong(oldDebt)).called(1);

          final verificationResult = verify(mockCache.update(captureAny));
          verificationResult.called(1);
          final capturedPerson = verificationResult.captured.single as Person;
          expect(capturedPerson.debtsOwed, [newDebt]);
        },
      );
    });

    test('getAllLoaded returns people from cache', () async {
      // Arrange
      final people = [
        Person(id: 1, name: 'John Doe', phoneNumber: '1234567890'),
      ];
      when(
        mockCache.getAll<Person>(),
      ).thenReturn({for (var p in people) p.id: p});
      final cubit = PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);

      // Act
      final result = await cubit.getAllLoaded();

      // Assert
      expect(result, people);
      verify(mockCache.getAll<Person>()).called(1);
    });

    group('getPage', () {
      final people = [
        Person(id: 1, name: 'John Doe', phoneNumber: '1234567890'),
      ];

      blocTest<PersonCubit, PersonState>(
        'emits [PersonLoading, PersonLoaded] when successful',
        build: () {
          when(mockPersonRepo.getPage(1, 20)).thenAnswer((_) async => people);
          when(
            mockCache.getAll<Person>(),
          ).thenReturn({for (var p in people) p.id: p});
          when(mockCache.addStrong(any)).thenReturn(1);
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) => cubit.getPage(1),
        expect: () => [
          isA<PersonLoading>(),
          isA<PersonLoaded>().having((s) => s.people, 'people', {
            for (var p in people) p.id: p,
          }),
        ],
        verify: (_) {
          verify(mockPersonRepo.getPage(1, 20)).called(1);
          verify(mockCache.addStrong(people.first)).called(1);
        },
      );

      blocTest<PersonCubit, PersonState>(
        'emits [PersonLoading, PersonError] when fails',
        build: () {
          when(
            mockPersonRepo.getPage(1, 20),
          ).thenThrow(Exception('Failed to load'));
          return PersonCubit(mockPersonRepo, mockDebtRepo, mockCache, false);
        },
        act: (cubit) => cubit.getPage(1),
        expect: () => [
          isA<PersonLoading>(),
          isA<PersonError>(),
        ],
        verify: (_) {
          verify(mockPersonRepo.getPage(1, 20)).called(1);
        },
      );
    });
  });
}
