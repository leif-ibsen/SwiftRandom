//
//  MT64.swift
//  SwiftRandom
//
//  Created by Leif Ibsen on 09/04/2024.
//

import Foundation

public class MT64: BitGenerator, Equatable {
    
    static let N = 312

    var X: [UInt64]
    var w: Int

    /// Constructs an MT64 instance from a specified seed
    ///
    /// - Parameters:
    ///   - seed: The seed
    public init(seed: UInt64) {
        self.X = [UInt64](repeating: 0, count: MT64.N)
        self.w = MT64.N
        self.X[0] = seed
        for i in 1 ..< MT64.N {
            self.X[i] = 6364136223846793005
            self.X[i] &*= self.X[i - 1] ^ (self.X[i - 1] >> 62)
            self.X[i] &+= UInt64(i)
        }
    }

    /// Constructs an MT64 instance from a randomly generated seed
    ///
    public convenience init() {
        var seed = [UInt64](repeating: 0, count: MT64.N)
        guard SecRandomCopyBytes(kSecRandomDefault, 8 * seed.count, &seed) == errSecSuccess else {
            fatalError("random failed")
        }
        self.init(seed: seed)
    }
    
    /// Constructs an MT64 instance from a specified seed array
    ///
    /// - Parameters:
    ///   - seed: The seed array
    public convenience init(seed: [UInt64]) {
        self.init(seed: UInt64(19650218))
        var i = 1
        var j = 0
        var k = MT64.N > seed.count ? MT64.N : seed.count
        while k > 0 {
            self.X[i] ^= (self.X[i - 1] ^ (self.X[i - 1] >> 62)) &* 3935559000370003845
            self.X[i] &+= seed[j]
            self.X[i] &+= UInt64(j)
            i += 1
            j += 1
            if i >= MT64.N {
                self.X[0] = self.X[MT64.N - 1]
                i = 1
            }
            if j >= seed.count {
                j = 0
            }
            k -= 1
        }
        k = MT64.N - 1
        while k > 0 {
            self.X[i] ^= (self.X[i - 1] ^ (self.X[i - 1] >> 62)) &* 2862933555777941757
            self.X[i] &-= UInt64(i)
            i += 1
            if i >= MT64.N {
                self.X[0] = self.X[MT64.N - 1]
                i = 1
            }
            k -= 1
        }
        self.X[0] = 0x8000000000000000
    }
    
    /// Constructs an MT64 instance which is a copy of another MT64
    ///
    /// - Parameters:
    ///   - mt: The other MT64
    public convenience init(mt: MT64) {
        self.init()
        self.setState(state: mt.getState())
    }

    func twist() {
        for i in 0 ..< MT64.N {
            let tmp = (self.X[i] & 0xffffffff80000000) &+ (self.X[(i + 1) % MT64.N] & 0x7fffffff)
            var tmpA = tmp >> 1
            if tmp & 1 == 1 {
                tmpA ^= 0xb5026f5aa96619e9
            }
            self.X[i] = self.X[(i + 156) % MT64.N] ^ tmpA
        }
        self.w = 0
    }

    public func nextUInt32() -> UInt32 {
        return UInt32(self.nextUInt64() & 0xffffffff)
    }

    public func nextUInt64() -> UInt64 {
        if self.w == MT64.N {
            self.twist()
        }
        var y = self.X[self.w]
        y ^= (y >> 29) & 0x5555555555555555
        y ^= (y << 17) & 0x71d67fffeda60000
        y ^= (y << 37) & 0xfff7eee000000000
        y ^= y >> 43
        self.w += 1
        return y
    }
    
    public func nextUInt128() -> UInt128 {
        return UInt128(self.nextUInt64()) << 64 | UInt128(self.nextUInt64())
    }

    public func nextBit() -> Bool {
        return nextUInt64() & 1 == 1
    }

    /// Retrieve the internal generator state
    ///
    /// - Returns: The internal generator state - 2498 bytes
    public func getState() -> Bytes {
        var state = Bytes(repeating: 0, count: 2 + 8 * MT64.N)
        state[0] = Byte(self.w & 0xff)
        state[1] = Byte((self.w >> 8) & 0xff)
        var i8 = 0
        for i in 0 ..< self.X.count {
            state[2 + i8] = Byte(self.X[i] & 0xff)
            state[3 + i8] = Byte(self.X[i] >> 8 & 0xff)
            state[4 + i8] = Byte(self.X[i] >> 16 & 0xff)
            state[5 + i8] = Byte(self.X[i] >> 24 & 0xff)
            state[6 + i8] = Byte(self.X[i] >> 32 & 0xff)
            state[7 + i8] = Byte(self.X[i] >> 40 & 0xff)
            state[8 + i8] = Byte(self.X[i] >> 48 & 0xff)
            state[9 + i8] = Byte(self.X[i] >> 56 & 0xff)
            i8 += 8
        }
        return state
    }

    /// Reinstate the internal generator state
    ///
    /// - Parameters:
    ///   - state: The new internal generator state - 2498 bytes
    public func setState(state: Bytes) {
        if state.count == 2 + 8 * MT64.N {
            let W = Int(state[1]) << 8 | Int(state[0])
            if W <= MT64.N {
                self.w = W
                var i8 = 0
                for i in 0 ..< self.X.count {
                    self.X[i] = UInt64(state[2 + i8])
                    self.X[i] |= UInt64(state[3 + i8]) << 8
                    self.X[i] |= UInt64(state[4 + i8]) << 16
                    self.X[i] |= UInt64(state[5 + i8]) << 24
                    self.X[i] |= UInt64(state[6 + i8]) << 32
                    self.X[i] |= UInt64(state[7 + i8]) << 40
                    self.X[i] |= UInt64(state[8 + i8]) << 48
                    self.X[i] |= UInt64(state[9 + i8]) << 56
                    i8 += 8
                }
            }
        }
    }

    /// Equality of two MT64 instances
    ///
    /// - Parameters:
    ///   - mt1: an MT64 instances
    ///   - mt2: an MT64 instances
    /// - Returns: `true` if mt1 and mt2 are equal, `false` otherwise
    public static func == (mt1: MT64, mt2: MT64) -> Bool {
        return mt1.X == mt2.X && mt1.w == mt2.w
    }

    /// Inequality of two MT64 instances
    ///
    /// - Parameters:
    ///   - mt1: an MT64 instances
    ///   - mt2: an MT64 instances
    /// - Returns: `false` if mt1 and mt2 are equal, `true` otherwise
    public static func != (mt1: MT64, mt2: MT64) -> Bool {
        return mt1.X != mt2.X || mt1.w != mt2.w
    }

}
