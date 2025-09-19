// ignore_for_file: public_member_api_docs, sort_constructors_first
class Tuple2<T1, T2> {
  Tuple2({
    required this.value1,
    required this.value2,
  });
  final T1 value1;
  final T2 value2;
}

Tuple2<T1, T2> tuple2<T1, T2>(T1 value1, T2 value2) => Tuple2(value1: value1, value2: value2);

class Tuple3<T1, T2, T3> {
  Tuple3({
    required this.value1,
    required this.value2,
    required this.value3,
  });
  final T1 value1;
  final T2 value2;
  final T3 value3;
}

Tuple3<T1, T2, T3> tuple3<T1, T2, T3>(T1 value1, T2 value2, T3 value3) =>
    Tuple3(value1: value1, value2: value2, value3: value3);
