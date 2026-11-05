# swift-radical

Use this package when a computation takes roots or fractional powers of exact rationals and must keep irrational results exact, such as √2 or ∛5, instead of rounding them to `Double`. Start from `Radical`: build one from a `Rational`, or from a nonnegative radicand and a degree, then raise it to rational exponents, multiply radicals, and scale by rationals. A `Radical` that turns out rational at degree one gives back its `Rational`. If every value in your computation is rational, use `Rational` from swift-rational directly.

## Laws

- A `Radical` stands for ±`radicand`^(1/`degree`), with `radicand` ≥ 0, `degree` ≥ 1, and the sign carried by `isNegative`.
- Every value is stored in lowest terms. Each exact root is taken out of the radicand until no prime factor p of `degree` leaves the radicand a perfect p-th power. So the sixth root of 8 is the same value as the square root of 2, and the fourth root of 16 is the rational 2. Equality and hashing compare this reduced form, so two `Radical`s are equal exactly when they denote the same number.
- Zero and one always have degree 1, and zero is never negative.
- `rational` is non-nil exactly when the reduced `degree` is 1, that is, exactly when the value is rational.
- The throwing initializer rejects a negative radicand or a degree below 1 with `Rational.Error.unrepresentable`. A negative value enters only through the `Rational` initializer or through `scaled(by:)`. An odd root of a negative value comes from `raised(to:)`.
- `raised(to:)` with an exponent whose reduced denominator is even fails with `Rational.Error.unrepresentable` on a negative value. With a negative exponent on zero it fails with `Rational.Error.zero`. When the degree or the exponent leaves `Int`, it fails with `Rational.Error.overflow`. The sign of the result is kept only when the exponent's numerator is odd.
- `multiplied(by:)` brings both factors to the least common multiple of their degrees and then reduces. The sign of the product is negative when exactly one factor is negative. It fails with `Rational.Error.overflow` when that common degree leaves `Int`.
- `scaled(by:)` never fails. It keeps the degree unless the factor is zero.
- `approximation` and `Radical.root(_:degree:)` find the root by bisection in `Double`. The result is exact at 0, 1, infinity and degree 1. Otherwise it is the midpoint at which the bisection hits the value exactly, or the end of an interval that has closed to adjacent `Double`s. The result is monotone in the value. `Radical.root(_:degree:)` traps on a negative or NaN value and on a degree below 1.
