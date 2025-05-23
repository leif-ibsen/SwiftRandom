//
//  MT32.swift
//  SwiftRandom
//
//  Created by Leif Ibsen on 09/04/2024.
//

import Foundation

public struct MT32: BitGenerator, CustomStringConvertible, Equatable {
    
    // Polynomial coefficients - used in the jump function
    static let coefficients: [UInt32] = [
        0x72de3963, 0xb5709ec4, 0x88279bb6, 0xa823f8e5, 0x26d83e59, 0x041f2259, 0xe7fdbb15, 0x8b521777,
        0x48b5e756, 0xbf2812d5, 0xe4b0adb9, 0x0b4849aa, 0x3e928b83, 0xe96d39ce, 0xaf6131d3, 0x09eaf2e8,
        0x33548456, 0xc1814c7b, 0x893a7c83, 0xfebd07bc, 0x01bd8267, 0x5147dcbf, 0xe2a67de6, 0x9afef574,
        0xb8334d09, 0xf0d3deca, 0x5561fd58, 0xd884703b, 0xef5c803b, 0xb39b8f42, 0x20dfb761, 0xd61cfed3,
        0xcf5f3e5b, 0x47416177, 0x8e8442e9, 0x8ea9cfab, 0x585d0ec0, 0x60ddf78d, 0x2c9b8528, 0xf0f7d60e,
        0xb2bb3bfc, 0xca3ee37d, 0x81c9e659, 0x870ed969, 0x9573a0de, 0xce524851, 0x77683b94, 0x73cda5ed,
        0x56bcfcbc, 0xf43b956c, 0x1f91de14, 0xbf04b400, 0x9438c481, 0x1d859831, 0xca6ae0a2, 0x9d97aed5,
        0x9e464218, 0xe75c9519, 0x253c5486, 0xcd43455c, 0x73b5ccd8, 0x7f8282d4, 0xc8cacd44, 0x192ddf99,
        0xd6be8546, 0x5288b589, 0xb4f26ca7, 0x9819557f, 0x200570eb, 0x03e73d28, 0x264acc04, 0x78a114c9,
        0x95f0fb7b, 0x42eee897, 0xabcc80c2, 0x67e751e8, 0x1330cc85, 0x140e87ef, 0x913b9a96, 0xd3f8525e,
        0x3ee3d205, 0x1ba1158f, 0x2c4cdb89, 0x1f6aa87d, 0x9b5e9a3a, 0x878b3223, 0xa498c3ed, 0xa48c7778,
        0x974ac066, 0x1d08f055, 0xc8a08242, 0xd6de80e9, 0xa1cf0b40, 0x2892ce4c, 0x842731c7, 0x604168ae,
        0xdd23ee6d, 0xbecff8b2, 0xdfac7287, 0xa4369751, 0xba8bc89d, 0x4a5840d9, 0xa7a58582, 0xf53bdbed,
        0xcfba4997, 0xa4149d1c, 0xd5c66fc3, 0xf2c72905, 0xce68ad39, 0xae4d8e96, 0xf213a9b5, 0xc588f396,
        0x9d6116bb, 0x2c618d4e, 0xb34420d1, 0xebfb61f3, 0x3b702ed7, 0xcbdca6f2, 0x7cb78166, 0xbe283395,
        0x03a2436a, 0x20c0d096, 0xe190aa6f, 0xbf49b815, 0x49d78dc3, 0x9b45b903, 0x0aa4c4c8, 0x67eb90e3,
        0xf32b13f0, 0x7f5ceab1, 0xccc48294, 0x641eaedb, 0x6d6aafb6, 0x80b55358, 0x72b55832, 0xf1fa779a,
        0x3b60af74, 0x8992aefd, 0x4fa609f2, 0x28359472, 0x61e7aaf1, 0x527dc1a9, 0x834e8087, 0xbcad693f,
        0xc9ca3bf6, 0x95171796, 0x9f41164a, 0xb7d36775, 0xcf20cf3b, 0x5c77677b, 0xf4765b01, 0x47dfd69f,
        0xd90d6e15, 0xd708247f, 0x5fe95113, 0xad799628, 0xc627f9f2, 0xfcfb0ce2, 0x0f2441ce, 0x4b003380,
        0x72161100, 0x50fa780b, 0x1f72b11a, 0xb71ca8b7, 0xffab42fd, 0x5475bace, 0x91c28b39, 0x356eef78,
        0x1441c9c3, 0xdc80086d, 0x96c47491, 0xb5c30ec9, 0xa254e42d, 0xa9321add, 0x963a3612, 0xc30bee5b,
        0x635c75c7, 0xdf141323, 0x38308f58, 0x8926e38f, 0x71b69592, 0x897754d8, 0x3cddde5e, 0x5bc06174,
        0xad520904, 0xbebb80a7, 0x5cc284d4, 0xd91d5d33, 0x8c6ba748, 0x11090e41, 0x33bb9929, 0x462cffbc,
        0xc42a508e, 0xefc68605, 0x602a3a14, 0x230e6cd9, 0x26c6f9f4, 0x49b8eb31, 0x51bd358f, 0x7c49e7a4,
        0x47b592cb, 0x1910bb39, 0x3ced6a5b, 0xad0ca518, 0x93461dcb, 0xd98ca579, 0x9526948e, 0xecc5cb65,
        0xfd1a431b, 0x0bddc87d, 0x5d694024, 0x7d9820ac, 0xffeb5538, 0x716c1ae1, 0x13cffb2f, 0x04f8ed86,
        0xd777f039, 0x1b32eb97, 0x87c1a95f, 0x893da4ee, 0xc235f16c, 0x965118d4, 0xe87994ba, 0xf99023e2,
        0xbb8c4545, 0x891268a5, 0xe7cf46b4, 0x4d163861, 0x0b2c5681, 0xca688c0e, 0x36702e5f, 0xb86346b5,
        0x55e311bb, 0x72a60137, 0x142fdc5c, 0x47d10e13, 0xa34ce0cb, 0xac088c30, 0x8f9503fe, 0x4d79a2e8,
        0x937670c7, 0x02b4c095, 0x20f8f5e0, 0x080533c0, 0x81fe8f32, 0xab1d0c25, 0x048f776d, 0xb601bb28,
        0x96004a47, 0xf8b8e16e, 0x6862af7b, 0x4a9fa042, 0xb0b6f662, 0x54384ad4, 0xa350c0ee, 0x81670a57,
        0x26061dc1, 0x3a2c2820, 0xb575f899, 0xb9749667, 0x738dfc2a, 0xaa853838, 0x00ccc442, 0xa53a92a4,
        0xcfaf5a3e, 0xbdc8cfa2, 0x09884265, 0x529fee9d, 0xa4d7f84f, 0x966c709e, 0x4c80bc42, 0xd14265d4,
        0xf5ebe7f3, 0xb23c2aed, 0x804523f1, 0xb7d47c42, 0xa7cb0aa9, 0x73370568, 0x06d90ac5, 0x66158a1e,
        0x9805c7ad, 0xc4a3898c, 0x7890adde, 0x7fc53690, 0x85c39b20, 0xc5427e08, 0xc0c864f8, 0x2fba05ed,
        0xc365017a, 0x210ad2bf, 0x8ffb95ea, 0x609ca003, 0x8e6c4f72, 0x84e663c4, 0x3c110562, 0x753c1ca8,
        0x8700b723, 0x48642afc, 0x14ac952c, 0xcef1123e, 0xed84973c, 0xf075b8b8, 0x0ceac5c9, 0xf00a255a,
        0xdfcd487c, 0x7e77e0da, 0x8be5750c, 0x0071cb97, 0x560827fe, 0x28c4386f, 0xaf4049f0, 0xbf6b3ad6,
        0xa911aadd, 0x2e3006d1, 0x5eb5bb74, 0x2e8489f9, 0xc36fb83d, 0x84278164, 0x82302b47, 0x61e0e6be,
        0x0422260e, 0x11b59c56, 0xe4f20c9c, 0x9cd5ecaa, 0xf866e2da, 0x9bc72523, 0x52c41667, 0x816f533c,
        0x47a3235e, 0xa0dbff9e, 0x0c62a756, 0xea9ca5a3, 0xde0761a6, 0xc51267e9, 0x3eed2af6, 0xf28b8866,
        0x695ed01f, 0xfd769663, 0x9065af4e, 0xbc47fcdf, 0xdfca6259, 0x424e389c, 0x166c2c1b, 0xbb03335e,
        0x2a73a1a1, 0xc4be33dd, 0xe690d058, 0x45746bc2, 0x94b43407, 0x07d38d7f, 0x60854fb3, 0x74b851e4,
        0xdb3d2ac2, 0xd99df507, 0x86d3323b, 0x5d6c254c, 0x82bfac22, 0xb4dd3032, 0xb27e023b, 0xb7261a5f,
        0x34fe8179, 0x40f361bf, 0x6c9e7858, 0xe716500e, 0x65873b06, 0x35c6ee0b, 0xfb2864e7, 0xe4c5d4fc,
        0x281901c6, 0x858ee284, 0xe5fca3cd, 0x44803a65, 0xf850f7f6, 0xf9f41e41, 0x65eb5539, 0x87cbf3c9,
        0xbe2f8074, 0xae056412, 0x3c5cb955, 0xd8fe916f, 0xaec289df, 0xd18ccb5e, 0x0eef81bf, 0x446157f2,
        0x4690364a, 0xde982175, 0xc1597ea0, 0xd094591b, 0xb1ed3e17, 0x79676e7a, 0xc495ebc1, 0xa283bdf6,
        0x648c3570, 0x6a06b25c, 0x398b0580, 0x0deb138c, 0xe51108ed, 0x4e3d096a, 0x1dda7416, 0xafde012b,
        0x722f0317, 0xcb001892, 0x23875cf7, 0x82d756d2, 0xc99114de, 0x2091ce44, 0xd24757b4, 0x8a944ef9,
        0x8594145a, 0xedf8f12b, 0x998c4aff, 0xf30c0ce9, 0x9ce601a0, 0xba657a58, 0x36a851dd, 0x94e6ec8d,
        0xed46b938, 0x86ada470, 0x409b507d, 0x46c714b9, 0x05c862a8, 0xb628043e, 0x7ac4a188, 0x8d763a8c,
        0x0adc18b6, 0x7f5ba797, 0x69073599, 0x5db4bc6b, 0x444d59d3, 0x3d087e22, 0xe9c04e89, 0x61466f51,
        0x548aa4e6, 0x151fd405, 0x91555389, 0x60905661, 0x5e8d5619, 0x3e3c8561, 0x39c6b81c, 0x2491156c,
        0xfc2fd4a6, 0x17b4d42c, 0x82c9bcf9, 0x2bd704cf, 0x7b2568ec, 0x05403240, 0x5d2268d9, 0x7e037b6b,
        0xd86bec7a, 0x231f10e7, 0xba016830, 0x964f8501, 0xa3b7321f, 0x9873c321, 0x350ac2dd, 0xa5a250e1,
        0x26578385, 0xc738d247, 0x012541ca, 0xcd33873c, 0xc5907f19, 0xd0cdc82c, 0x5c2b540a, 0x5656cca4,
        0x1f887dd1, 0xa3d987b8, 0x83e7fe48, 0x06a28478, 0x945682db, 0x465f2df8, 0x9b494ce1, 0xfac8ffbc,
        0x598f39cd, 0xb12ac825, 0xfa99231b, 0x3e5c217e, 0x3b2d8ba2, 0xe550fdba, 0x8e510006, 0x846a6733,
        0x3e573194, 0xee48a926, 0x5ccd36bd, 0x41c394c8, 0x10a79620, 0xa19b67f2, 0x8b3fd2a6, 0x8a285c06,
        0x3a1797d9, 0x3637050a, 0x63dfca07, 0x7295647e, 0x7a7b3bba, 0xbe8e7601, 0xea660549, 0x3c1e511a,
        0xc7a1931a, 0x06c40c25, 0x3796cf70, 0x7d188664, 0xccd9fa38, 0xb9f70031, 0x601e2c75, 0x87fe9735,
        0xf8cd68b0, 0xef645dd6, 0x7d05b323, 0x535d7138, 0x5c02f47f, 0x90327a26, 0x63ecd3b2, 0xabd5ea25,
        0x01624325, 0x302c1641, 0xdbfbeb93, 0x1cdfa6bc, 0x866519a2, 0xb15987ed, 0x113296f1, 0x0c31ec84,
        0x232a35b2, 0xb4132090, 0x92d0c3c5, 0x535172e3, 0x095ffccb, 0xfc24a0a9, 0x932c038e, 0x2546326e,
        0xccc15e47, 0x1bbafc54, 0x3cf2a838, 0xa8486630, 0x1057e025, 0x8405b4ae, 0xda36738d, 0x1eec4c73,
        0x88b30f90, 0x4f9ff104, 0x85eea780, 0x6eab7da8, 0x40d9fdbe, 0x6fe9593d, 0x3c850d3c, 0x65606c0c,
        0xb078a231, 0x70308a34, 0x635af9bd, 0x6d9a7cbe, 0xed73ee32, 0x63660519, 0x1701dd8d, 0x0e62955f,
        0x180db0e9, 0x9cb66a13, 0xd3c2cd3e, 0x78fb88aa, 0x85fdbe48, 0xa2859c52, 0x9579f8f8, 0x902ffd41,
        0x4b7c6a7b, 0x1f5e048a, 0x8e262d89, 0x706d2495, 0xebbbd878, 0x816d7f42, 0x88cdfbf1, 0x3e6cc58a,
        0x754a64ab, 0xaa7dfafd, 0xe98d0a02, 0xb63cd2f7, 0x38c8c85c, 0x72c5b57f, 0xb97f2b0a, 0xe479da34,
        0x553e33f7, 0x7c86232a, 0xb35cc8f8, 0xedc6266d, 0xca67e7fe, 0x14b7f688, 0x072d997b, 0xb3d3d66f,
        0x528c6a42, 0x121005b9, 0x0df2b622, 0x87d31f39, 0x12ce5fd4, 0xedaedb37, 0x49dec2f4, 0x8e53ff25,
        0xe79e435a, 0x764041aa, 0x29a3ee70, 0xb359bd5e, 0x5aa2b047, 0x303acd04, 0xb82a2d07, 0x165795c2,
        0xa64ab733, 0x950faac1, 0xdfa2861f, 0xff195e03, 0x8cd6e865, 0x5eb360ec, 0x639cb063, 0x19e1a74d,
        0x7ec12528, 0x775c20d6, 0xa44c4ddf, 0x08722d7f, 0xb0c92d32, 0x83d145bc, 0x3b2207e8, 0x73da60e4,
        0xa13d0929, 0x962813b9, 0x738f420b, 0xeb6572d6, 0x151a52ca, 0x80a4a0ef, 0x23eee457, 0x00000000
    ]

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
    public init() {
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
    public init(seed: [UInt32]) {
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

    public var description: String {
        return "32 bit Mersenne Twister mt19937"
    }

    mutating func twist() {
        if self.w < 227 {
            let tmp = (self.X[self.w] & 0x80000000) | (self.X[self.w + 1] & 0x7fffffff)
            var tmpA = tmp >> 1
            if tmp & 1 == 1 {
                tmpA ^= 0x9908b0df
            }
            self.X[self.w] = self.X[self.w + 397] ^ tmpA
            self.w += 1
        } else if self.w < 623 {
            let tmp = (self.X[self.w] & 0x80000000) | (self.X[self.w + 1] & 0x7fffffff)
            var tmpA = tmp >> 1
            if tmp & 1 == 1 {
                tmpA ^= 0x9908b0df
            }
            self.X[self.w] = self.X[self.w - 227] ^ tmpA
            self.w += 1
        } else {
            let tmp = (self.X[623] & 0x80000000) | (self.X[0] & 0x7fffffff)
            var tmpA = tmp >> 1
            if tmp & 1 == 1 {
                tmpA ^= 0x9908b0df
            }
            self.X[623] = self.X[396] ^ tmpA
            self.w = 0
        }
    }

    /// Required by the RandomNumberGenerator protocol
    ///
    /// - Returns: A random unsigned 64 bit integer
    public mutating func next() -> UInt64 {
        return self.nextUInt64()
    }

    public mutating func nextUInt32() -> UInt32 {
        if self.w == MT32.N {
            for i in 0 ..< 227 {
                let tmp = (self.X[i] & 0x80000000) | (self.X[i + 1] & 0x7fffffff)
                var tmpA = tmp >> 1
                if tmp & 1 == 1 {
                    tmpA ^= 0x9908b0df
                }
                self.X[i] = self.X[i + 397] ^ tmpA
            }
            for i in 227 ..< 623 {
                let tmp = (self.X[i] & 0x80000000) | (self.X[i + 1] & 0x7fffffff)
                var tmpA = tmp >> 1
                if tmp & 1 == 1 {
                    tmpA ^= 0x9908b0df
                }
                self.X[i] = self.X[i - 227] ^ tmpA
            }
            let tmp = (self.X[623] & 0x80000000) | (self.X[0] & 0x7fffffff)
            var tmpA = tmp >> 1
            if tmp & 1 == 1 {
                tmpA ^= 0x9908b0df
            }
            self.X[623] = self.X[396] ^ tmpA
            self.w = 0
        }
        var y = self.X[self.w]
        y ^= y >> 11
        y ^= (y << 7) & 0x9d2c5680
        y ^= (y << 15) & 0xefc60000
        y ^= y >> 18
        self.w += 1
        return y
    }

    public mutating func nextUInt64() -> UInt64 {
        return UInt64(self.nextUInt32()) << 32 | UInt64(self.nextUInt32())
    }
    
    public mutating func nextUInt128() -> UInt128 {
        return UInt128(self.nextUInt64()) << 64 | UInt128(self.nextUInt64())
    }
    
    public mutating func nextBit() -> Bool {
        return nextUInt32() & 1 == 1
    }

    /// Advance the generator state as if `(jumps * 2^128) nextUInt32()` calls had been made
    ///
    /// - Precondition: `jumps` is not negative
    /// - Parameters:
    ///   - jumps: The amount to advance - default is 1
    public mutating func jump(jumps: Int = 1) {
        precondition(jumps >= 0, "Negative jump count")
        for _ in 0 ..< jumps {
            var i = 19936
            while !coefficient(i) {
                i -= 1
            }
            if self.w == MT32.N {
                self.w = 0
            }
            var temp = self
            temp.twist()
            i -= 1
            while i > 0 {
                if coefficient(i) {
                    addState(&temp)
                }
                temp.twist()
                i -= 1
            }
            addState(&temp)
            self = temp
        }
    }

    // mt += self
    func addState(_ mt: inout MT32) {
        if self.w >= mt.w {
            for i in 0 ..< MT32.N - self.w {
                mt.X[i + mt.w] ^= self.X[i + self.w]
            }
            for i in MT32.N - self.w ..< MT32.N - mt.w {
                mt.X[i + mt.w] ^= self.X[i + self.w - MT32.N]
            }
            for i in MT32.N - mt.w ..< MT32.N {
                mt.X[i + mt.w - MT32.N] ^= self.X[i + self.w - MT32.N]
            }
        } else {
            for i in 0 ..< MT32.N - mt.w {
                mt.X[i + mt.w] ^= self.X[i + self.w]
            }
            for i in MT32.N - mt.w ..< MT32.N - self.w {
                mt.X[i + mt.w - MT32.N] ^= self.X[i + self.w]
            }
            for i in MT32.N - self.w ..< MT32.N {
                mt.X[i + mt.w - MT32.N] ^= self.X[i + self.w - MT32.N]
            }
        }
    }

    func coefficient(_ n: Int) -> Bool {
        return MT32.coefficients[n >> 5] & (1 << (n & 0x1f)) != 0
    }

    /// Retrieve the internal generator state
    ///
    /// - Returns: The internal generator state - 2498 bytes
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

    /// Reinstate the internal generator state
    ///
    /// - Parameters:
    ///   - state: The new internal generator state - 2498 bytes
    public mutating func setState(state: Bytes) {
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
