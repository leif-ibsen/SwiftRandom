//
//  MT32.swift
//  SwiftRandom
//
//  Created by Leif Ibsen on 09/04/2024.
//

import Foundation

public class MT32: BitGenerator, Equatable {
    
    static let D26 = Double(1 << 26)
    static let D53 = Double(1 << 53)
    static let D53_1 = Double(1 << 53 - 1)

    static let N = 624
    
    var X: [UInt32]
    var w: Int
    
    /// Constructs an MT32 instance from a specified seed
    ///
    /// - Parameters:
    ///   - seed: The seed
    public init(seed: UInt32) {
        self.X = [UInt32](repeating: 0, count: MT32.N)
        self.w = MT32.N
        self.X[0] = seed
        for i in 1 ..< MT32.N {
            self.X[i] = 1812433253
            self.X[i] &*= self.X[i - 1] ^ (self.X[i - 1] >> 30)
            self.X[i] &+= UInt32(i)
        }
    }

    /// Constructs an MT32 instance from a randomly generated seed
    ///
    public convenience init() {
        var seed = [UInt32](repeating: 0, count: MT32.N)
        guard SecRandomCopyBytes(kSecRandomDefault, 4 * seed.count, &seed) == errSecSuccess else {
            fatalError("random failed")
        }
        self.init(seed: seed)
    }

    /// Constructs an MT32 instance from a specified seed array
    ///
    /// - Parameters:
    ///   - seed: The seed array
    public convenience init(seed: [UInt32]) {
        self.init(seed: UInt32(19650218))
        var i = 1
        var j = 0
        var k = MT32.N > seed.count ? MT32.N : seed.count
        while k > 0 {
            self.X[i] ^= (self.X[i - 1] ^ (self.X[i - 1] >> 30)) &* 1664525
            self.X[i] &+= seed[j]
            self.X[i] &+= UInt32(j)
            i += 1
            j += 1
            if i >= MT32.N {
                self.X[0] = self.X[MT32.N - 1]
                i = 1
            }
            if j >= seed.count {
                j = 0
            }
            k -= 1
        }
        k = MT32.N - 1
        while k > 0 {
            self.X[i] ^= (self.X[i - 1] ^ (self.X[i - 1] >> 30)) &* 1566083941
            self.X[i] &-= UInt32(i)
            i += 1
            if i >= MT32.N {
                self.X[0] = self.X[MT32.N - 1]
                i = 1
            }
            k -= 1
        }
        self.X[0] = 0x80000000
    }
    
    /// Constructs an MT32 instance which is a copy of another MT32
    ///
    /// - Parameters:
    ///   - mt: The other MT32
    public convenience init(mt: MT32) {
        self.init()
        self.setState(state: mt.getState())
    }

    func twist() {
        for i in 0 ..< MT32.N {
            let tmp = (self.X[i] & 0x80000000) &+ (self.X[(i + 1) % MT32.N] & 0x7fffffff)
            var tmpA = tmp >> 1
            if tmp & 1 == 1 {
                tmpA ^= 0x9908B0df
            }
            self.X[i] = self.X[(i + 397) % MT32.N] ^ tmpA
        }
        self.w = 0
    }

    public func nextUInt32() -> UInt32 {
        if self.w == MT32.N {
            self.twist()
        }
        var y = self.X[self.w]
        y ^= y >> 11
        y ^= (y << 7) & 0x9d2c5680
        y ^= (y << 15) & 0xefc60000
        y ^= y >> 18
        self.w += 1
        return y
    }

    public func nextUInt64() -> UInt64 {
        return UInt64(self.nextUInt32()) << 32 | UInt64(self.nextUInt32())
    }
    
    // Double value in 0.0 ..< 1.0 or 0.0 ... 1.0
    public func nextDouble(open: Bool = true) -> Double {
        return (Double(self.nextUInt32() >> 5) * MT32.D26 + Double(self.nextUInt32() >> 6)) / (open ? MT32.D53 : MT32.D53_1)
    }

    public func getState() -> Bytes {
        var state = Bytes(repeating: 0, count: 2 + 4 * MT32.N)
        state[0] = Byte(self.w & 0xff)
        state[1] = Byte((self.w >> 8) & 0xff)
        var i4 = 0
        for i in 0 ..< self.X.count {
            state[2 + i4] = Byte(self.X[i] & 0xff)
            state[3 + i4] = Byte(self.X[i] >> 8 & 0xff)
            state[4 + i4] = Byte(self.X[i] >> 16 & 0xff)
            state[5 + i4] = Byte(self.X[i] >> 24 & 0xff)
            i4 += 4
        }
        return state
    }

    public func setState(state: Bytes) {
        if state.count == 2 + 4 * MT32.N {
            let W = Int(state[1]) << 8 | Int(state[0])
            if W <= MT32.N {
                self.w = W
                var i4 = 0
                for i in 0 ..< self.X.count {
                    self.X[i] = UInt32(state[2 + i4])
                    self.X[i] |= UInt32(state[3 + i4]) << 8
                    self.X[i] |= UInt32(state[4 + i4]) << 16
                    self.X[i] |= UInt32(state[5 + i4]) << 24
                    i4 += 4
                }
            }
        }
    }
    
    /// Equality of two MT32 instances
    ///
    /// - Parameters:
    ///   - mt1: an MT32 instances
    ///   - mt2: an MT32 instances
    /// - Returns: `true` if mt1 and mt2 are equal, `false` otherwise
    public static func == (mt1: MT32, mt2: MT32) -> Bool {
        return mt1.X == mt2.X && mt1.w == mt2.w
    }

    /// Inequality of two MT32 instances
    ///
    /// - Parameters:
    ///   - mt1: an MT32 instances
    ///   - mt2: an MT32 instances
    /// - Returns: `false` if mt1 and mt2 are equal, `true` otherwise
    public static func != (mt1: MT32, mt2: MT32) -> Bool {
        return mt1.X != mt2.X || mt1.w != mt2.w
    }

}
