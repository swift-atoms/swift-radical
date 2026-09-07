public import Rational

public struct Radical: Hashable, Sendable {
    public let radicand: Rational
    public let degree: Int
    public let isNegative: Bool

    public init(_ value: Rational) {
        self.radicand = (value < .zero) ? -value : value
        self.degree = 1
        self.isNegative = (value < .zero)
    }

    public init(radicand: Rational, degree: Int) throws(Rational.Error) {
        guard degree > 0, radicand >= .zero else { throw .unrepresentable }
        self.init(positive: radicand, degree: degree, negative: false)
    }

    internal init(positive radicand: Rational, degree: Int, negative: Bool) {
        var value = radicand
        var degree = degree
        if value == .zero || value == .one { degree = 1 }
        var remaining = degree
        var prime = 2
        let limit = max(value.numerator.bitWidth, value.denominator.bitWidth)
        while prime <= remaining / prime && prime <= limit {
            if remaining % prime == 0 {
                while remaining % prime == 0 { remaining /= prime }
                while degree % prime == 0,
                    let root = value.root(prime) {
                    value = root
                    degree /= prime
                }
            }
            prime += 1
        }
        if remaining > 1, remaining <= limit,
            let root = value.root(remaining) {
            value = root
            degree /= remaining
        }
        self.radicand = value
        self.degree = degree
        self.isNegative = value != .zero && negative
    }

    public var rational: Rational? {
        guard degree == 1 else { return nil }
        return isNegative ? -radicand : radicand
    }
}
