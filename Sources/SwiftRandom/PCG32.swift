//
//  File.swift
//  SwiftRandom
//
//  Created by Leif Ibsen on 09/10/2024.
//

import Foundation

public class PCG32: BitGenerator, Equatable {
    
    /// The standard multiplier = 6364136223846793005
    public static let Multiplier = UInt64(6364136223846793005)
    
    /// The default increment = 1442695040888963407
    public static let DefaultIncrement = UInt64(1442695040888963407)

    let multiplier = PCG32.Multiplier
    var increment: UInt64
    var state: UInt64

    /// Constructs a PCG32 instance from a specified state and increment
    ///
    /// - Parameters:
    ///   - state: The state
    ///   - increment: The increment, default is `PCG32.DefaultIncrement`
    public init(state: UInt64, increment: UInt64 = PCG32.DefaultIncrement) {
        
        // increment must be odd
        
        if increment == PCG32.DefaultIncrement {
            self.increment = increment
        } else {
            self.increment = increment << 1 | 1
        }
        self.state = state &+ self.increment
        self.state = self.state &* self.multiplier &+ self.increment
    }

    /// Constructs a PCG32 instance from a randomly generated state
    ///
    public convenience init() {
        var state = UInt64(0)
        guard SecRandomCopyBytes(kSecRandomDefault, 8, &state) == errSecSuccess else {
            fatalError("random failed")
        }
        self.init(state: state)
    }
    
    /// Constructs a PCG32 instance which is a copy of another PCG32, possibly advanced an amount
    ///
    /// - Parameters:
    ///   - pcg: The other PCG32
    ///   - advanced: The amount to advance, default is 0
    public convenience init(pcg: PCG32, advanced: UInt64 = 0) {
        self.init()
        self.setState(state: pcg.getState())
        self.advance(n: advanced)
    }

    public func nextUInt32() -> UInt32 {
        let n = Int(self.state >> 59)
        let x = UInt32(((self.state ^ (self.state >> 18)) >> 27) & 0xffffffff)
        let xr = (x >> n) | (x << (32 - n))
        self.state = self.state &* self.multiplier &+ self.increment
        return xr
    }

    public func nextUInt64() -> UInt64 {
        return UInt64(nextUInt32()) << 32 | UInt64(nextUInt32())
    }

    // Double value in 0.0 ..< 1.0 or 0.0 ... 1.0
    public func nextDouble(open: Bool = true) -> Double {
        return (Double(self.nextUInt32() >> 5) * MT32.D26 + Double(self.nextUInt32() >> 6)) / (open ? MT32.D53 : MT32.D53_1)
    }

    public func getState() -> Bytes {
        var bytes = Bytes(repeating: 0, count: 16)
        bytes[0] = Byte((self.state >> 0) & 0xff)
        bytes[1] = Byte((self.state >> 8) & 0xff)
        bytes[2] = Byte((self.state >> 16) & 0xff)
        bytes[3] = Byte((self.state >> 24) & 0xff)
        bytes[4] = Byte((self.state >> 32) & 0xff)
        bytes[5] = Byte((self.state >> 40) & 0xff)
        bytes[6] = Byte((self.state >> 48) & 0xff)
        bytes[7] = Byte((self.state >> 56) & 0xff)
        bytes[8] = Byte((self.increment >> 0) & 0xff)
        bytes[9] = Byte((self.increment >> 8) & 0xff)
        bytes[10] = Byte((self.increment >> 16) & 0xff)
        bytes[11] = Byte((self.increment >> 24) & 0xff)
        bytes[12] = Byte((self.increment >> 32) & 0xff)
        bytes[13] = Byte((self.increment >> 40) & 0xff)
        bytes[14] = Byte((self.increment >> 48) & 0xff)
        bytes[15] = Byte((self.increment >> 56) & 0xff)
        return bytes
    }

    public func setState(state: Bytes) {
        if state.count == 16 {
            self.state = UInt64(state[0])
            self.state |= UInt64(state[1]) << 8
            self.state |= UInt64(state[2]) << 16
            self.state |= UInt64(state[3]) << 24
            self.state |= UInt64(state[4]) << 32
            self.state |= UInt64(state[5]) << 40
            self.state |= UInt64(state[6]) << 48
            self.state |= UInt64(state[7]) << 56
            self.increment = UInt64(state[8])
            self.increment |= UInt64(state[9]) << 8
            self.increment |= UInt64(state[10]) << 16
            self.increment |= UInt64(state[11]) << 24
            self.increment |= UInt64(state[12]) << 32
            self.increment |= UInt64(state[13]) << 40
            self.increment |= UInt64(state[14]) << 48
            self.increment |= UInt64(state[15]) << 56
        }
    }

    /// Advance the generator state as if a certain number of `nextUInt32()` calls had been made.
    ///
    /// - Parameters:
    ///   - n: The amount to advance
    public func advance(n: UInt64) {
        var accMultiplier = UInt64(1)
        var accIncrement = UInt64(0)
        var curMultiplier = self.multiplier
        var curIncrement = self.increment
        var delta = n
        while delta > 0 {
            if delta & 1 == 1 {
                accMultiplier &*= curMultiplier
                accIncrement = accIncrement &* curMultiplier &+ curIncrement
            }
            curIncrement = (curMultiplier &+ 1) &* curIncrement
            curMultiplier &*= curMultiplier
            delta >>= 1
        }
        self.state = self.state &* accMultiplier &+ accIncrement
    }

    /// Equality of two PCG32 instances
    ///
    /// - Parameters:
    ///   - pcg1: a PCG32 instances
    ///   - pcg2: a PCG32 instances
    /// - Returns: `true` if pcg1 and pcg2 are equal, `false` otherwise
    public static func == (pcg1: PCG32, pcg2: PCG32) -> Bool {
        return pcg1.state == pcg2.state && pcg1.increment == pcg2.increment
    }

    /// Inequality of two PCG32 instances
    ///
    /// - Parameters:
    ///   - pcg1: a PCG32 instances
    ///   - pcg2: a PCG32 instances
    /// - Returns: `false` if pcg1 and pcg2 are equal, `true` otherwise
    public static func != (pcg1: PCG32, pcg2: PCG32) -> Bool {
        return pcg1.state != pcg2.state || pcg1.increment != pcg2.increment
    }

}
