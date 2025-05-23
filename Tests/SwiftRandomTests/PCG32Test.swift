//
//  Test.swift
//  SwiftRandom
//
//  Created by Leif Ibsen on 09/10/2024.
//

import XCTest
@testable import SwiftRandom

final class PCG32Test: XCTestCase {
    
    // Test data from rosettacode.org - Pseudo-random numbers/PCG32
    
    func test1() throws {
        var pcg32 = PCG32(state: 42, increment: 54)
        XCTAssertEqual(pcg32.nextUInt32(), 2707161783)
        XCTAssertEqual(pcg32.nextUInt32(), 2068313097)
        XCTAssertEqual(pcg32.nextUInt32(), 3122475824)
        XCTAssertEqual(pcg32.nextUInt32(), 2211639955)
        XCTAssertEqual(pcg32.nextUInt32(), 3215226955)
        pcg32 = PCG32(state: 987654321, increment: 1)
        var counts = [Int](repeating: 0, count: 5)
        for _ in 0 ..< 100000 {
            let x = Double(pcg32.nextUInt32()) / Double(1 << 32)
            counts[Int(x * 5.0)] += 1
        }
        XCTAssertEqual(counts[0], 20049)
        XCTAssertEqual(counts[1], 20022)
        XCTAssertEqual(counts[2], 20115)
        XCTAssertEqual(counts[3], 19809)
        XCTAssertEqual(counts[4], 20005)
    }
    
    func testAdvance1() throws {
        var pcg1 = PCG32()
        var pcg2 = pcg1
        for _ in 0 ..< 10000 {
            let _ = pcg1.nextUInt32()
        }
        pcg2.advance(n: 10000)
        XCTAssertEqual(pcg1, pcg2)
    }

    func testAdvance2() throws {
        var pcg32 = PCG32()
        let state = pcg32.getState()
        pcg32.advance(n: UInt64(Int64.max))
        pcg32.advance(n: UInt64(Int64.max))
        pcg32.advance(n: 2)
        XCTAssertEqual(state, pcg32.getState())
        pcg32.advance(n: UInt64.max)
        pcg32.advance(n: 1)
        XCTAssertEqual(state, pcg32.getState())
        pcg32.advance(n: 0)
        XCTAssertEqual(state, pcg32.getState())
    }

    func test64() throws {
        var pcg32 = PCG32()
        let state = pcg32.getState()
        let x64 = pcg32.nextUInt64()
        pcg32.setState(state: state)
        let x32x2 = UInt64(pcg32.nextUInt32()) << 32 | UInt64(pcg32.nextUInt32())
        XCTAssertEqual(x64, x32x2)
    }

}
