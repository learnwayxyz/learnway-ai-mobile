library;

///Find the coeffficient of Bezout coefficient
/// 24s + 16t = gcd(24,16)
/// STEPS:
/// Find the GCD using Euclidean algorithm
/// After finding the GCD, we can now determine how many values apart
/// With the above steps we can determine how many of the blocks we used
///
///
void main() {
  CalculateBezoutCoefficient bezoutCoefficient = CalculateBezoutCoefficient();

  bezoutCoefficient.perfomrEA(24, 16);
}

class CalculateBezoutCoefficient {
  ///perform EA
  String perfomrEA(int t, int s) {
    /// s will divide t, store the remainder
    // final value = s ~/ t;
    // final remainder = s % t;
    var a = t;
    var b = s;

    while (b != 0) {
      final quotient = s ~/ t;
      final remainder = s % t;
      a = remainder;
    }
    return 'gef';
  }
}
