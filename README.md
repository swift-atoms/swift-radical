# Radical

A symbolic signed real root of a nonnegative rational. Depends on Rational; rational arithmetic itself remains in Rational.

Exact roots are normalized, and `rational` returns a value only when the radical reduces to a rational number. General addition of radicals is not represented by this type. The root degree currently uses Int and checked degree arithmetic can throw on overflow. Approximation is explicit and may overflow or underflow.
