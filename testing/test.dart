class A {
  int a;
  A({
    this.a = 1,
  });
  @override
  String toString() {
    return "A { a:$a }";
  }
}

class B {
  int b;
  A objA;
  B({
    this.b = 1,
    required this.objA,
  });
  @override
  String toString() {
    return "B { b: $b, objA: $objA }";
  }
}

void main() {
  Map<int, dynamic> dict = {};
  dict[0] = A(a: 1);
  dict[1] = B(objA: dict[0]);
  print(dict);
  dict[0].a = 10;
  print(dict);
  dict[0] = A(a: 10000);
  print(dict);
}
