import Radical
import Testing

@Suite struct RadicalTests {
    @Test func exactAndIrrationalRootsRemainDistinct() throws {
        let root = try Radical(radicand: 2, degree: 2)
        #expect(root.rational == nil)
        #expect(try root.multiplied(by: root).rational == 2)
        #expect(try Radical(radicand: 16, degree: 4).rational == 2)
        #expect(try Radical(radicand: 64, degree: 6).rational == 2)
        #expect(try Radical(radicand: 8, degree: 6) == root)
        #expect(try Radical(radicand: Rational(numerator: 4, denominator: 9), degree: 2).rational == Rational("2/3"))
        #expect(try Radical(-8).raised(to: Rational(numerator: 1, denominator: 3)).rational == -2)
        #expect(throws: Rational.Error.unrepresentable) { try Radical(-1).raised(to: Rational(numerator: 1, denominator: 2)) }
        #expect(throws: Rational.Error.zero) { try Radical(0).raised(to: -1) }
        #expect(root.scaled(by: -2).isNegative)
        #expect(abs(root.approximation - 2.0.squareRoot()) < 1e-14)
    }
}
