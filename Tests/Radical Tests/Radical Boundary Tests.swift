import Radical
import Testing

@Suite
struct `Radical boundaries` {
    @Test
    func `zero and one reduce to degree one`() throws {
        #expect(try Radical(radicand: 0, degree: 7).degree == 1)
        #expect(try Radical(radicand: 1, degree: 7).rational == 1)
    }

    @Test
    func `a non-positive degree or a negative radicand is rejected`() {
        #expect(throws: Rational.Error.unrepresentable) { try Radical(radicand: 2, degree: 0) }
        #expect(throws: Rational.Error.unrepresentable) { try Radical(radicand: 2, degree: -2) }
        #expect(throws: Rational.Error.unrepresentable) { try Radical(radicand: -4, degree: 2) }
    }

    @Test
    func `a negative rational keeps its sign at degree one`() {
        #expect(Radical(-8).rational == -8)
        #expect(Radical(-8).isNegative)
        #expect(!Radical(0).isNegative)
    }

    @Test
    func `roots of different degrees multiply at their least common degree`() throws {
        let product = try Radical(radicand: 2, degree: 2).multiplied(by: Radical(radicand: 2, degree: 3))
        #expect(product == (try Radical(radicand: 32, degree: 6)))
        #expect(product.rational == nil)
    }

    @Test
    func `a large prime degree stays irreducible`() throws {
        let root = try Radical(radicand: 2, degree: 1_000_003)
        #expect(root.degree == 1_000_003)
        #expect(abs(root.approximation - 1) < 1e-5)
    }

    @Test
    func `the numeric root is exact at its fixed points and monotone`() {
        #expect(Radical.root(0, degree: 3) == 0)
        #expect(Radical.root(1, degree: 3) == 1)
        #expect(Radical.root(27, degree: 3) == 3)
        #expect(Radical.root(0.25, degree: 2) == 0.5)
        #expect(Radical.root(.infinity, degree: 2) == .infinity)
        #expect(Radical.root(2, degree: 2) < Radical.root(3, degree: 2))
    }
}
