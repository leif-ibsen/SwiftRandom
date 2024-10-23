//
//  PCG.swift
//  SwiftRandomTest
//
//  Created by Leif Ibsen on 08/10/2024.
//

import Foundation

public class PCG64: BitGenerator, Equatable {
    
    static func add128(_ x: UInt128, _ y: UInt128) -> UInt128 {
        let lo = x.lo &+ y.lo
        var hi = x.hi &+ y.hi
        if lo < x.lo {
            hi &+= 1
        }
        return UInt128(hi, lo)
    }

    static func mul128(_ x: UInt128, _ y: UInt128) -> UInt128 {
        var (hi, lo) = x.lo.multipliedFullWidth(by: y.lo)
        hi &+= x.lo.multipliedFullWidth(by: y.hi).low
        hi &+= y.lo.multipliedFullWidth(by: x.hi).low
        return UInt128(hi, lo)
    }

    /// The standard multiplier = 47026247687942121848144207491837523525
    public static let Multiplier: UInt128 = (hi: 2549297995355413924, lo: 4865540595714422341)

    /// The default increment = 117397592171526113268558934119004209487
    public static let DefaultIncrement: UInt128 = (hi: 6364136223846793005, lo: 1442695040888963407)

    let multiplier = PCG64.Multiplier
    var increment: UInt128
    var state: UInt128
    var UInt32x2: UInt64
    var hasUInt32: Bool

    /// Constructs a PCG64 instance from a specified state and increment
    ///
    /// - Parameters:
    ///   - state: The state
    ///   - increment: The increment, default is `PCG64.DefaultIncrement`
    public init(state: UInt128, increment: UInt128 = PCG64.DefaultIncrement) {

        // increment must be odd
        
        if increment == PCG64.DefaultIncrement {
            self.increment = increment
        } else {
            self.increment = UInt128(increment.hi << 1 | increment.lo >> 63, increment.lo << 1 | 1)
        }
        self.state = PCG64.add128(self.increment, UInt128(state.hi, state.lo))
        self.state = PCG64.add128(PCG64.mul128(self.state, self.multiplier), self.increment)
        self.UInt32x2 = 0
        self.hasUInt32 = false
    }

    /// Constructs a PCG64 instance from a randomly generated state
    ///
    public convenience init() {
        var state = [UInt64](repeating: 0, count: 2)
        guard SecRandomCopyBytes(kSecRandomDefault, 16, &state) == errSecSuccess else {
            fatalError("random failed")
        }
        self.init(state: (state[0], state[1]))
    }
    
    /// Constructs a PCG64 instance which is a copy of another PCG64, possibly advanced an amount
    ///
    /// - Parameters:
    ///   - pcg: The other PCG64
    ///   - advanced: The amount to advance, default is 0
    public convenience init(pcg: PCG64, advanced: UInt128 = (0, 0)) {
        self.init()
        self.setState(state: pcg.getState())
        self.advance(n: advanced)
    }

    public func nextUInt32() -> UInt32 {
        if self.hasUInt32 {
            self.hasUInt32 = false
            return UInt32(self.UInt32x2 >> 32)
        } else {
            self.hasUInt32 = true
            self.UInt32x2 = self.nextUInt64()
            return UInt32(self.UInt32x2 & 0xffffffff)
        }
    }

    public func nextUInt64() -> UInt64 {
        let n = self.state.hi >> 58
        let x = self.state.hi ^ self.state.lo
        let xr = (x >> n) | (x << (64 - n))
        self.state = PCG64.add128(PCG64.mul128(self.multiplier, self.state), self.increment)
        return xr
    }
    
    // Double value in 0.0 ..< 1.0 or 0.0 ... 1.0
    public func nextDouble(open: Bool = true) -> Double {
        return Double(self.nextUInt64() >> 11) / (open ? MT32.D53 : MT32.D53_1)
    }

    public func getState() -> Bytes {
        var bytes = Bytes(repeating: 0, count: 32)
        bytes[0] = Byte((self.state.lo >> 0) & 0xff)
        bytes[1] = Byte((self.state.lo >> 8) & 0xff)
        bytes[2] = Byte((self.state.lo >> 16) & 0xff)
        bytes[3] = Byte((self.state.lo >> 24) & 0xff)
        bytes[4] = Byte((self.state.lo >> 32) & 0xff)
        bytes[5] = Byte((self.state.lo >> 40) & 0xff)
        bytes[6] = Byte((self.state.lo >> 48) & 0xff)
        bytes[7] = Byte((self.state.lo >> 56) & 0xff)
        bytes[8] = Byte((self.state.hi >> 0) & 0xff)
        bytes[9] = Byte((self.state.hi >> 8) & 0xff)
        bytes[10] = Byte((self.state.hi >> 16) & 0xff)
        bytes[11] = Byte((self.state.hi >> 24) & 0xff)
        bytes[12] = Byte((self.state.hi >> 32) & 0xff)
        bytes[13] = Byte((self.state.hi >> 40) & 0xff)
        bytes[14] = Byte((self.state.hi >> 48) & 0xff)
        bytes[15] = Byte((self.state.hi >> 56) & 0xff)

        bytes[16] = Byte((self.increment.lo >> 0) & 0xff)
        bytes[17] = Byte((self.increment.lo >> 8) & 0xff)
        bytes[18] = Byte((self.increment.lo >> 16) & 0xff)
        bytes[19] = Byte((self.increment.lo >> 24) & 0xff)
        bytes[20] = Byte((self.increment.lo >> 32) & 0xff)
        bytes[21] = Byte((self.increment.lo >> 40) & 0xff)
        bytes[22] = Byte((self.increment.lo >> 48) & 0xff)
        bytes[23] = Byte((self.increment.lo >> 56) & 0xff)
        bytes[24] = Byte((self.increment.hi >> 0) & 0xff)
        bytes[25] = Byte((self.increment.hi >> 8) & 0xff)
        bytes[26] = Byte((self.increment.hi >> 16) & 0xff)
        bytes[27] = Byte((self.increment.hi >> 24) & 0xff)
        bytes[28] = Byte((self.increment.hi >> 32) & 0xff)
        bytes[29] = Byte((self.increment.hi >> 40) & 0xff)
        bytes[30] = Byte((self.increment.hi >> 48) & 0xff)
        bytes[31] = Byte((self.increment.hi >> 56) & 0xff)
        return bytes
    }

    public func setState(state: Bytes) {
        if state.count == 32 {
            var lo = UInt64(state[0])
            lo |= UInt64(state[1]) << 8
            lo |= UInt64(state[2]) << 16
            lo |= UInt64(state[3]) << 24
            lo |= UInt64(state[4]) << 32
            lo |= UInt64(state[5]) << 40
            lo |= UInt64(state[6]) << 48
            lo |= UInt64(state[7]) << 56
            var hi = UInt64(state[8])
            hi |= UInt64(state[9]) << 8
            hi |= UInt64(state[10]) << 16
            hi |= UInt64(state[11]) << 24
            hi |= UInt64(state[12]) << 32
            hi |= UInt64(state[13]) << 40
            hi |= UInt64(state[14]) << 48
            hi |= UInt64(state[15]) << 56
            self.state = UInt128(hi, lo)
            
            lo = UInt64(state[16])
            lo |= UInt64(state[17]) << 8
            lo |= UInt64(state[18]) << 16
            lo |= UInt64(state[19]) << 24
            lo |= UInt64(state[20]) << 32
            lo |= UInt64(state[21]) << 40
            lo |= UInt64(state[22]) << 48
            lo |= UInt64(state[23]) << 56
            hi = UInt64(state[24])
            hi |= UInt64(state[25]) << 8
            hi |= UInt64(state[26]) << 16
            hi |= UInt64(state[27]) << 24
            hi |= UInt64(state[28]) << 32
            hi |= UInt64(state[29]) << 40
            hi |= UInt64(state[30]) << 48
            hi |= UInt64(state[31]) << 56
            self.increment = UInt128(hi, lo)
        }
    }

    /// Advance the generator state as if a certain number of `nextUInt64()` calls had been made.
    ///
    /// - Parameters:
    ///   - n: The amount to advance
    public func advance(n: UInt128) {
        var accMultiplier = UInt128(0, 1)
        var accIncrement = UInt128(0, 0)
        var curMultiplier = self.multiplier
        var curIncrement = self.increment
        var delta = n
        while delta.hi > 0 || delta.lo > 0 {
            if delta.lo & 1 == 1 {
                accMultiplier = PCG64.mul128(accMultiplier, curMultiplier)
                accIncrement = PCG64.add128(PCG64.mul128(accIncrement, curMultiplier), curIncrement)
            }
            curIncrement = PCG64.add128(PCG64.mul128(curMultiplier, curIncrement), curIncrement)
            curMultiplier = PCG64.mul128(curMultiplier, curMultiplier)
            // delta >>= 1
            delta.lo = (delta.lo >> 1) | (delta.hi << 63)
            delta.hi >>= 1
        }
        self.state = PCG64.add128(PCG64.mul128(self.state, accMultiplier), accIncrement)
    }

    /// Equality of two PCG64 instances
    ///
    /// - Parameters:
    ///   - pcg1: a PCG64 instances
    ///   - pcg2: a PCG64 instances
    /// - Returns: `true` if pcg1 and pcg2 are equal, `false` otherwise
    public static func == (pcg1: PCG64, pcg2: PCG64) -> Bool {
        return pcg1.state == pcg2.state && pcg1.increment == pcg2.increment
    }

    /// Inequality of two PCG64 instances
    ///
    /// - Parameters:
    ///   - pcg1: a PCG64 instances
    ///   - pcg2: a PCG64 instances
    /// - Returns: `false` if pcg1 and pcg2 are equal, `true` otherwise
    public static func != (pcg1: PCG64, pcg2: PCG64) -> Bool {
        return pcg1.state != pcg2.state || pcg1.increment != pcg2.increment
    }

}
