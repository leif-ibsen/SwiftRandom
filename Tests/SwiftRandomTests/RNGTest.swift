//
//  MTTest.swift
//  
//
//  Created by Leif Ibsen on 23/04/2024.
//

import XCTest
@testable import SwiftRandom

final class RNGTest: XCTestCase {

    func doTestInt(_ rng: RNG) throws {
        var x1 = [Int](repeating: 0, count: 1000)
        var x2 = [Int](repeating: 0, count: 1000)
        var state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: Int.min ... Int.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: Int.min ... Int.max)
        }
        XCTAssertEqual(x1, x2)
        state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: 0 ... Int.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: 0 ... Int.max)
        }
        XCTAssertEqual(x1, x2)
        state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: Int.min ... 0)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: Int.min ... 0)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestInt32(_ rng: RNG) throws {
        var x1 = [Int32](repeating: 0, count: 1000)
        var x2 = [Int32](repeating: 0, count: 1000)
        var state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: Int32.min ... Int32.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: Int32.min ... Int32.max)
        }
        XCTAssertEqual(x1, x2)
        state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: 0 ... Int32.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: 0 ... Int32.max)
        }
        XCTAssertEqual(x1, x2)
        state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: Int32.min ... 0)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: Int32.min ... 0)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestInt64(_ rng: RNG) throws {
        var x1 = [Int64](repeating: 0, count: 1000)
        var x2 = [Int64](repeating: 0, count: 1000)
        var state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: Int64.min ... Int64.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: Int64.min ... Int64.max)
        }
        XCTAssertEqual(x1, x2)
        state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: 0 ... Int64.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: 0 ... Int64.max)
        }
        XCTAssertEqual(x1, x2)
        state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomInt(in: Int64.min ... 0)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomInt(in: Int64.min ... 0)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestUInt(_ rng: RNG) throws {
        var x1 = [UInt](repeating: 0, count: 1000)
        var x2 = [UInt](repeating: 0, count: 1000)
        let state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomUInt(in: 0 ... UInt.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomUInt(in: 0 ... UInt.max)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestUInt32(_ rng: RNG) throws {
        var x1 = [UInt32](repeating: 0, count: 1000)
        var x2 = [UInt32](repeating: 0, count: 1000)
        let state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomUInt(in: 0 ... UInt32.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomUInt(in: 0 ... UInt32.max)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestUInt64(_ rng: RNG) throws {
        var x1 = [UInt64](repeating: 0, count: 1000)
        var x2 = [UInt64](repeating: 0, count: 1000)
        let state = rng.getState()
        for i in 0 ..< x1.count {
            x1[i] = rng.randomUInt(in: 0 ... UInt64.max)
        }
        rng.setState(state: state)
        for i in 0 ..< x2.count {
            x2[i] = rng.randomUInt(in: 0 ... UInt64.max)
        }
        XCTAssertEqual(x1, x2)
    }

    func doTestMinMaxInt(_ rng: RNG) throws {
        XCTAssertTrue(rng.randomInt(in: 0 ... 0) == 0)
        XCTAssertTrue(rng.randomInt(in: 0 ..< 1) == 0)
        XCTAssertTrue(rng.randomInt(in: Int.max ... Int.max) == Int.max)
        XCTAssertTrue(rng.randomInt(in: Int.max - 1 ..< Int.max) == Int.max - 1)
        let x = rng.randomInt(in: Int.max - 1 ... Int.max)
        XCTAssertTrue(x == Int.max - 1 || x == Int.max)
        XCTAssertTrue(rng.randomInt(in: Int.min ... Int.min) == Int.min)
        XCTAssertTrue(rng.randomInt(in: Int.min ..< Int.min + 1) == Int.min)
        let x_1 = rng.randomInt(in: Int.min ... Int.min + 1)
        XCTAssertTrue(x_1 == Int.min || x_1 == Int.min + 1)

        XCTAssertTrue(rng.randomInt(in: Int32(0) ... Int32(0)) == 0)
        XCTAssertTrue(rng.randomInt(in: Int32(0) ..< Int32(1)) == 0)
        XCTAssertTrue(rng.randomInt(in: Int32.max ... Int32.max) == Int32.max)
        XCTAssertTrue(rng.randomInt(in: Int32.max - 1 ..< Int32.max) == Int32.max - 1)
        let x32 = rng.randomInt(in: Int32.max - 1 ... Int32.max)
        XCTAssertTrue(x32 == Int32.max - 1 || x32 == Int32.max)
        XCTAssertTrue(rng.randomInt(in: Int32.min ... Int32.min) == Int32.min)
        XCTAssertTrue(rng.randomInt(in: Int32.min ..< Int32.min + 1) == Int32.min)
        let x32_1 = rng.randomInt(in: Int32.min ... Int32.min + 1)
        XCTAssertTrue(x32_1 == Int32.min || x32_1 == Int32.min + 1)

        XCTAssertTrue(rng.randomInt(in: Int64(0) ... Int64(0)) == 0)
        XCTAssertTrue(rng.randomInt(in: Int64(0) ..< Int64(1)) == 0)
        XCTAssertTrue(rng.randomInt(in: Int64.max ... Int64.max) == Int64.max)
        XCTAssertTrue(rng.randomInt(in: Int64.max - 1 ..< Int64.max) == Int64.max - 1)
        let x64 = rng.randomInt(in: Int64.max - 1 ... Int64.max)
        XCTAssertTrue(x64 == Int64.max - 1 || x64 == Int64.max)
        XCTAssertTrue(rng.randomInt(in: Int64.min ... Int64.min) == Int64.min)
        XCTAssertTrue(rng.randomInt(in: Int64.min ..< Int64.min + 1) == Int64.min)
        let x64_1 = rng.randomInt(in: Int64.min ... Int64.min + 1)
        XCTAssertTrue(x64_1 == Int64.min || x64_1 == Int64.min + 1)
    }

    func doTestMinMaxUInt(_ rng: RNG) throws {
        XCTAssertTrue(rng.randomUInt(in: UInt(0) ... UInt(0)) == 0)
        XCTAssertTrue(rng.randomUInt(in: UInt(0) ..< UInt(1)) == 0)
        XCTAssertTrue(rng.randomUInt(in: UInt.max ... UInt.max) == UInt.max)
        XCTAssertTrue(rng.randomUInt(in: UInt.max - 1 ..< UInt.max) == UInt.max - 1)
        let x = rng.randomUInt(in: UInt.max - 1 ... UInt.max)
        XCTAssertTrue(x == UInt.max - 1 || x == UInt.max)
        XCTAssertTrue(rng.randomUInt(in: UInt.min ... UInt.min) == UInt.min)
        XCTAssertTrue(rng.randomUInt(in: UInt.min ..< UInt.min + 1) == UInt.min)

        XCTAssertTrue(rng.randomUInt(in: UInt32(0) ... UInt32(0)) == 0)
        XCTAssertTrue(rng.randomUInt(in: UInt32(0) ..< UInt32(1)) == 0)
        XCTAssertTrue(rng.randomUInt(in: UInt32.max ... UInt32.max) == UInt32.max)
        XCTAssertTrue(rng.randomUInt(in: UInt32.max - 1 ..< UInt32.max) == UInt32.max - 1)
        let x32 = rng.randomUInt(in: UInt32.max - 1 ... UInt32.max)
        XCTAssertTrue(x32 == UInt32.max - 1 || x32 == UInt32.max)
        XCTAssertTrue(rng.randomUInt(in: UInt32.min ... UInt32.min) == UInt32.min)
        XCTAssertTrue(rng.randomUInt(in: UInt32.min ..< UInt32.min + 1) == UInt32.min)

        XCTAssertTrue(rng.randomUInt(in: UInt64(0) ... UInt64(0)) == 0)
        XCTAssertTrue(rng.randomUInt(in: UInt64(0) ..< UInt64(1)) == 0)
        XCTAssertTrue(rng.randomUInt(in: UInt64.max ... UInt64.max) == UInt64.max)
        XCTAssertTrue(rng.randomUInt(in: UInt64.max - 1 ..< UInt64.max) == UInt64.max - 1)
        let x64 = rng.randomUInt(in: UInt64.max - 1 ... UInt64.max)
        XCTAssertTrue(x64 == UInt64.max - 1 || x64 == UInt64.max)
        XCTAssertTrue(rng.randomUInt(in: UInt64.min ... UInt64.min) == UInt64.min)
        XCTAssertTrue(rng.randomUInt(in: UInt64.min ..< UInt64.min + 1) == UInt64.min)
    }

    func doTestFloat(_ rng: RNG) throws {
        for _ in 0 ..< 1000 {
            let x = rng.randomFloat(in: 0.0 ..< 1.0)
            XCTAssertTrue(0.0 <= x && x < 1.0)
        }
        for _ in 0 ..< 1000 {
            let x = rng.randomFloat(in: 0.0 ... 1.0)
            XCTAssertTrue(0.0 <= x && x <= 1.0)
        }
    }

    func testInt() throws {
        let mt32 = RNG(bg: MT32())
        let mt64 = RNG(bg: MT64())
        let pcg32 = RNG(bg: PCG32())
        let pcg64 = RNG(bg: PCG64())
        try doTestInt(mt32)
        try doTestInt(mt64)
        try doTestInt(pcg32)
        try doTestInt(pcg64)
        try doTestInt32(mt32)
        try doTestInt32(mt64)
        try doTestInt32(pcg32)
        try doTestInt32(pcg64)
        try doTestInt64(mt32)
        try doTestInt64(mt64)
        try doTestInt64(pcg32)
        try doTestInt64(pcg64)
    }

    func testUInt() throws {
        let mt32 = RNG(bg: MT32())
        let mt64 = RNG(bg: MT64())
        let pcg32 = RNG(bg: PCG32())
        let pcg64 = RNG(bg: PCG64())
        try doTestUInt(mt32)
        try doTestUInt(mt64)
        try doTestUInt(pcg32)
        try doTestUInt(pcg64)
        try doTestUInt32(mt32)
        try doTestUInt32(mt64)
        try doTestUInt32(pcg32)
        try doTestUInt32(pcg64)
        try doTestUInt64(mt32)
        try doTestUInt64(mt64)
        try doTestUInt64(pcg32)
        try doTestUInt64(pcg64)
    }

    func testMinMaxInt() throws {
        let mt32 = RNG(bg: MT32())
        let mt64 = RNG(bg: MT64())
        let pcg32 = RNG(bg: PCG32())
        let pcg64 = RNG(bg: PCG64())
        try doTestMinMaxInt(mt32)
        try doTestMinMaxInt(mt64)
        try doTestMinMaxInt(pcg32)
        try doTestMinMaxInt(pcg64)
    }

    func testMinMaxUInt() throws {
        let mt32 = RNG(bg: MT32())
        let mt64 = RNG(bg: MT64())
        let pcg32 = RNG(bg: PCG32())
        let pcg64 = RNG(bg: PCG64())
        try doTestMinMaxUInt(mt32)
        try doTestMinMaxUInt(mt64)
        try doTestMinMaxUInt(pcg32)
        try doTestMinMaxUInt(pcg64)
    }

    func testFloat() throws {
        let mt32 = RNG(bg: MT32())
        let mt64 = RNG(bg: MT64())
        let pcg32 = RNG(bg: PCG32())
        let pcg64 = RNG(bg: PCG64())
        try doTestFloat(mt32)
        try doTestFloat(mt64)
        try doTestFloat(pcg32)
        try doTestFloat(pcg64)
    }

}
