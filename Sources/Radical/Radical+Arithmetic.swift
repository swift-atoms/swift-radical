public import Rational

extension Radical {
    public func raised(to exponent: Rational) throws(Rational.Error) -> Self {
        guard let numerator = exponent.numerator.absolute.exactly(Int.self),
            let denominator = exponent.denominator.exactly(Int.self) else { throw .overflow }
        guard !isNegative || denominator % 2 == 1 else { throw .unrepresentable }
        let degree = degree.multipliedReportingOverflow(by: denominator)
        guard !degree.overflow else { throw .overflow }
        let power = exponent < .zero ? -numerator : numerator
        return Self(
            positive: try radicand.raised(to: power), degree: degree.partialValue,
            negative: isNegative && numerator % 2 != 0
        )
    }

    public func multiplied(by other: Self) throws(Rational.Error) -> Self {
        var left = degree
        var right = other.degree
        while right != 0 { (left, right) = (right, left % right) }
        let product = (degree / left).multipliedReportingOverflow(by: other.degree)
        guard !product.overflow else { throw .overflow }
        let degree = product.partialValue
        let value = try radicand.raised(to: degree / self.degree) * other.radicand.raised(to: degree / other.degree)
        return Self(positive: value, degree: degree, negative: isNegative != other.isNegative)
    }

    public func scaled(by value: Rational) -> Self {
        let absolute = value < .zero ? -value : value
        do {
            return Self(
                positive: try radicand * absolute.raised(to: degree), degree: degree,
                negative: isNegative != (value < .zero)
            )
        } catch { preconditionFailure("A nonnegative integer power is defined") }
    }

    public var approximation: Double {
        let value = Self.root(radicand.approximation, degree: degree)
        return isNegative ? -value : value
    }

    public static func root(_ value: Double, degree: Int) -> Double {
        precondition(degree > 0 && value >= 0)
        if value == 0 || value == 1 || degree == 1 || !value.isFinite { return value }
        var low = min(1, value)
        var high = max(1, value)
        while true {
            let middle = low + (high - low) / 2
            if middle == low || middle == high { return middle }
            var power = degree
            var factor = middle
            var product = 1.0
            while power != 0 {
                if power & 1 != 0 { product *= factor }
                power >>= 1
                if power != 0 { factor *= factor }
            }
            if product == value { return middle }
            if product < value { low = middle } else { high = middle }
        }
    }
}
