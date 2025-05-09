//
//  PCG.swift
//  SwiftRandomTest
//
//  Created by Leif Ibsen on 08/10/2024.
//

import Foundation

public class PCG64: BitGenerator, Equatable {
    
    /// The standard multiplier = 47026247687942121848144207491837523525
    public static let Multiplier: UInt128 = 47026247687942121848144207491837523525

    /// The default increment = 117397592171526113268558934119004209487
    public static let DefaultIncrement: UInt128 = 117397592171526113268558934119004209487

    let multiplier = PCG64.Multiplier
    var increment: UInt128
    var state: UInt128

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
            self.increment = increment << 1 | 1
        }
        self.state = self.increment &+ state
        self.state = self.state &* self.multiplier &+ self.increment
    }

    /// Constructs a PCG64 instance from a randomly generated state
    ///
    public convenience init() {
        var state = UInt128(0)
        guard SecRandomCopyBytes(kSecRandomDefault, 16, &state) == errSecSuccess else {
            fatalError("random failed")
        }
        self.init(state: state)
    }
    
    /// Constructs a PCG64 instance which is a copy of another PCG64, possibly advanced an amount
    ///
    /// - Parameters:
    ///   - pcg: The other PCG64
    ///   - advanced: The amount to advance, default is 0
    public convenience init(pcg: PCG64, advanced: UInt128 = 0) {
        self.init()
        self.setState(state: pcg.getState())
        self.advance(n: advanced)
    }

    /// Required by the RandomNumberGenerator protocol
    ///
    /// - Returns: A random unsigned 64 bit integer
    public func next() -> UInt64 {
        return self.nextUInt64()
    }

    public func nextUInt32() -> UInt32 {
        return UInt32(self.nextUInt64() & 0xffffffff)
    }

    public func nextUInt64() -> UInt64 {
        let n = self.state >> 122
        let x = UInt64(self.state >> 64) ^ UInt64(self.state & 0xffffffffffffffff)
        let xr = (x >> n) | (x << (64 - n))
        self.state = self.multiplier &* self.state &+ self.increment
        return xr
    }
    
    public func nextUInt128() -> UInt128 {
        return UInt128(self.nextUInt64()) << 64 | UInt128(self.nextUInt64())
    }

    public func nextBit() -> Bool {
        return self.nextUInt64() & 1 == 1
    }

    /// Retrieve the internal generator state
    ///
    /// - Returns: The internal generator state - 32 bytes
    public func getState() -> Bytes {
        var bytes = Bytes(repeating: 0, count: 32)
        bytes[0] = Byte((self.state >> 0) & 0xff)
        bytes[1] = Byte((self.state >> 8) & 0xff)
        bytes[2] = Byte((self.state >> 16) & 0xff)
        bytes[3] = Byte((self.state >> 24) & 0xff)
        bytes[4] = Byte((self.state >> 32) & 0xff)
        bytes[5] = Byte((self.state >> 40) & 0xff)
        bytes[6] = Byte((self.state >> 48) & 0xff)
        bytes[7] = Byte((self.state >> 56) & 0xff)
        bytes[8] = Byte((self.state >> 64) & 0xff)
        bytes[9] = Byte((self.state >> 72) & 0xff)
        bytes[10] = Byte((self.state >> 80) & 0xff)
        bytes[11] = Byte((self.state >> 88) & 0xff)
        bytes[12] = Byte((self.state >> 96) & 0xff)
        bytes[13] = Byte((self.state >> 104) & 0xff)
        bytes[14] = Byte((self.state >> 112) & 0xff)
        bytes[15] = Byte((self.state >> 120) & 0xff)

        bytes[16] = Byte((self.increment >> 0) & 0xff)
        bytes[17] = Byte((self.increment >> 8) & 0xff)
        bytes[18] = Byte((self.increment >> 16) & 0xff)
        bytes[19] = Byte((self.increment >> 24) & 0xff)
        bytes[20] = Byte((self.increment >> 32) & 0xff)
        bytes[21] = Byte((self.increment >> 40) & 0xff)
        bytes[22] = Byte((self.increment >> 48) & 0xff)
        bytes[23] = Byte((self.increment >> 56) & 0xff)
        bytes[24] = Byte((self.increment >> 64) & 0xff)
        bytes[25] = Byte((self.increment >> 72) & 0xff)
        bytes[26] = Byte((self.increment >> 80) & 0xff)
        bytes[27] = Byte((self.increment >> 88) & 0xff)
        bytes[28] = Byte((self.increment >> 96) & 0xff)
        bytes[29] = Byte((self.increment >> 104) & 0xff)
        bytes[30] = Byte((self.increment >> 112) & 0xff)
        bytes[31] = Byte((self.increment >> 120) & 0xff)
        return bytes
    }

    /// Reinstate the internal generator state
    ///
    /// - Parameters:
    ///   - state: The new internal generator state - 32 bytes
    public func setState(state: Bytes) {
        if state.count == 32 {
            self.state = UInt128(state[0])
            self.state |= UInt128(state[1]) << 8
            self.state |= UInt128(state[2]) << 16
            self.state |= UInt128(state[3]) << 24
            self.state |= UInt128(state[4]) << 32
            self.state |= UInt128(state[5]) << 40
            self.state |= UInt128(state[6]) << 48
            self.state |= UInt128(state[7]) << 56
            self.state |= UInt128(state[8]) << 64
            self.state |= UInt128(state[9]) << 72
            self.state |= UInt128(state[10]) << 80
            self.state |= UInt128(state[11]) << 88
            self.state |= UInt128(state[12]) << 96
            self.state |= UInt128(state[13]) << 104
            self.state |= UInt128(state[14]) << 112
            self.state |= UInt128(state[15]) << 120
            
            self.increment = UInt128(state[16])
            self.increment |= UInt128(state[17]) << 8
            self.increment |= UInt128(state[18]) << 16
            self.increment |= UInt128(state[19]) << 24
            self.increment |= UInt128(state[20]) << 32
            self.increment |= UInt128(state[21]) << 40
            self.increment |= UInt128(state[22]) << 48
            self.increment |= UInt128(state[23]) << 56
            self.increment |= UInt128(state[24]) << 64
            self.increment |= UInt128(state[25]) << 72
            self.increment |= UInt128(state[26]) << 80
            self.increment |= UInt128(state[27]) << 88
            self.increment |= UInt128(state[28]) << 96
            self.increment |= UInt128(state[29]) << 104
            self.increment |= UInt128(state[30]) << 112
            self.increment |= UInt128(state[31]) << 120
        }
    }

    /// Advance the generator state as if a certain number of `nextUInt64()` calls had been made.
    ///
    /// - Parameters:
    ///   - n: The amount to advance
    public func advance(n: UInt128) {
        var accMultiplier = UInt128(1)
        var accIncrement = UInt128(0)
        var curMultiplier = self.multiplier
        var curIncrement = self.increment
        var delta = n
        while delta > 0 {
            if delta & 1 == 1 {
                accMultiplier = accMultiplier &* curMultiplier
                accIncrement = accIncrement &* curMultiplier &+ curIncrement
            }
            curIncrement = (curMultiplier &+ 1) &* curIncrement
            curMultiplier = curMultiplier &* curMultiplier
            delta >>= 1
        }
        self.state = self.state &* accMultiplier &+ accIncrement
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
