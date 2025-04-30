//
//  Mersenne.swift
//  SwiftRandomTest
//
//  Created by Leif Ibsen on 18/04/2024.
//

import Foundation

/// Unsigned 8 bit value
public typealias Byte = UInt8

/// Array of unsigned 8 bit values
public typealias Bytes = [UInt8]

/// 128 bit unsigned integer
public typealias UInt128 = (hi: UInt64, lo: UInt64)

public class RNG {
    
    var bgProtocol: BitGenerator
    var bits: UInt64
    var remainingBits: Int
    
    /// Constructs an RNG instance from a bit generator
    ///
    /// - Parameters:
    ///   - bg: An instance of a class that conforms to the ``BitGenerator`` protocol
    public init(bg: BitGenerator) {
        self.bgProtocol = bg
        self.bits = 0
        self.remainingBits = 0
    }

    /// Random bit
    ///
    /// - Returns: A random bit
    public func randomBit() -> Bool {
        if self.remainingBits == 0 {
            self.bits = self.bgProtocol.nextUInt64()
            self.remainingBits = 64
        }
        let bit = self.bits & 1 == 1
        self.bits >>= 1
        self.remainingBits -= 1
        return bit
    }

    // Open range
    
    /// Random integer value
    ///
    /// - Parameters:
    ///   - range: An open range
    /// - Returns: A random integer in the specified range
    public func randomInt(in range: Range<Int>) -> Int {
        return randomInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open range
    /// - Returns: A random 32 bit integer in the specified range
    public func randomInt(in range: Range<Int32>) -> Int32 {
        return randomInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open range
    /// - Returns: A random 64 bit integer in the specified range
    public func randomInt(in range: Range<Int64>) -> Int64 {
        return randomInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random unsigned integer value
    ///
    /// - Parameters:
    ///   - range: An open range
    /// - Returns: A random unsigned integer in the specified range
    public func randomUInt(in range: Range<UInt>) -> UInt {
        return randomUInt(in: range.lowerBound ... range.upperBound - 1)
    }
    
    /// Random unsigned 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open range
    /// - Returns: A random unsigned 32 bit integer in the specified range
    public func randomUInt(in range: Range<UInt32>) -> UInt32 {
        return randomUInt(in: range.lowerBound ... range.upperBound - 1)
    }
    
    /// Random unsigned 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open range
    /// - Returns: A random unsigned 64 bit integer in the specified range
    public func randomUInt(in range: Range<UInt64>) -> UInt64 {
        return randomUInt(in: range.lowerBound ... range.upperBound - 1)
    }

    // Closed range
    
    /// Random integer value
    ///
    /// - Parameters:
    ///   - range: A closed range
    /// - Returns: A random integer in the specified range
    public func randomInt(in range: ClosedRange<Int>) -> Int {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = UInt(bitPattern: range.upperBound &- range.lowerBound)
        let mask = UInt64(0xffffffffffffffff) >> size.leadingZeroBitCount
        var x: UInt64
        repeat {
            x = self.bgProtocol.nextUInt64() & mask
        } while x > size
        return range.lowerBound &+ Int(bitPattern: UInt(x))
    }

    /// Random 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed range
    /// - Returns: A random 32 bit integer in the specified range
    public func randomInt(in range: ClosedRange<Int32>) -> Int32 {
        return Int32(randomInt(in: Int(range.lowerBound) ... Int(range.upperBound)))
    }

    /// Random 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed range
    /// - Returns: A random 64 bit integer in the specified range
    public func randomInt(in range: ClosedRange<Int64>) -> Int64 {
        return Int64(randomInt(in: Int(range.lowerBound) ... Int(range.upperBound)))
    }

    /// Random unsigned integer value
    ///
    /// - Parameters:
    ///   - range: A closed range
    /// - Returns: A random unsigned integer in the specified range
    public func randomUInt(in range: ClosedRange<UInt>) -> UInt {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = range.upperBound - range.lowerBound
        let mask = UInt64(0xffffffffffffffff) >> size.leadingZeroBitCount
        var x: UInt64
        repeat {
            x = self.bgProtocol.nextUInt64() & mask
        } while x > size
        return range.lowerBound + UInt(x)
    }

    /// Random unsigned 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed range
    /// - Returns: A random unsigned 32 bit integer in the specified range
    public func randomUInt(in range: ClosedRange<UInt32>) -> UInt32 {
        return UInt32(randomUInt(in: UInt(range.lowerBound) ... UInt(range.upperBound)))
    }

    /// Random unsigned 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed range
    /// - Returns: A random unsigned 64 bit integer in the specified range
    public func randomUInt(in range: ClosedRange<UInt64>) -> UInt64 {
        return UInt64(randomUInt(in: UInt(range.lowerBound) ... UInt(range.upperBound)))
    }

    /// Random floating point value
    ///
    /// - Parameters:
    ///   - range: An open range
    /// - Returns: A random floating point value in the specified range
    public func randomFloat(in range: Range<Double>) -> Double {
        return range.lowerBound + (range.upperBound - range.lowerBound) * self.bgProtocol.nextDouble(open: true)
    }
    
    /// Random floating point value
    ///
    /// - Parameters:
    ///   - range: A closed range
    /// - Returns: A random floating point value in the specified range
    public func randomFloat(in range: ClosedRange<Double>) -> Double {
        return range.lowerBound + (range.upperBound - range.lowerBound) * self.bgProtocol.nextDouble(open: false)
    }

    /// Get the internal state
    ///
    /// - Returns:The internal state of the underlying bit generator - 2498 bytes for ``MT32`` and ``MT64``, 16 bytes for ``PCG32`` and 32 bytes for ``PCG64``
    public func getState() -> Bytes {
        return self.bgProtocol.getState()
    }

    /// Reinstate the internal state
    ///
    /// - Parameters:
    ///   - state: The new internal state of the underlying bit generator - 2498 bytes for ``MT32`` and ``MT64``, 16 bytes for ``PCG32`` and 32 bytes for ``PCG64``
    public func setState(state: Bytes) {
        self.bgProtocol.setState(state: state)
    }

    /// Generates an array of normal distributed values
    ///
    /// - Precondition: The standard deviation is positive
    /// - Parameters:
    ///   - mean: The mean value
    ///   - stdev: The standard deviation, a positive number
    ///   - values: Filled with the generated values
    public func normalDistribution(mean: Double, stdev: Double, values: inout [Double]) {
        precondition(stdev > 0.0, "Standard deviation must be positive")
        var s: Double
        var x1: Double
        var x2: Double
        for i in stride(from: 0, to: values.count, by: 2) {
            repeat {
                x1 = self.randomFloat(in: -1.0 ..< 1.0)
                x2 = self.randomFloat(in: -1.0 ..< 1.0)
                s = x1 * x1 + x2 * x2
            } while s == 0.0 || s >= 1.0
            s = sqrt(-2.0 * log(s) / s) * stdev
            values[i] = mean + x1 * s
            if i < values.count - 1 {
                values[i + 1] = mean + x2 * s
            }
        }
    }
    
    /// Generates an array of exponentially distributed values
    ///
    /// - Precondition: The mean value is positive
    /// - Parameters:
    ///   - mean: The mean value, a positive number
    ///   - values: Filled with the generated values
    public func exponentialDistribution(mean: Double, values: inout [Double]) {
        precondition(mean > 0.0, "Mean value must be positive")
        self.uniformDistribution(in: 0.0 ..< 1.0, values: &values)
        for i in 0 ..< values.count {
            values[i] = -log(1.0 - values[i]) * mean
        }
    }

    /// Generates an array of uniformly distributed values in an open range
    ///
    /// - Parameters:
    ///   - range: The open range of values
    ///   - values: Filled with the generated values
    public func uniformDistribution(in range: Range<Double>, values: inout [Double]) {
        for i in 0 ..< values.count {
            values[i] = self.randomFloat(in: range)
        }
    }

    /// Generates an array of uniformly distributed values in a closed range
    ///
    /// - Parameters:
    ///   - range: The closed range of values
    ///   - values: Filled with the generated values
    public func uniformDistribution(in range: ClosedRange<Double>, values: inout [Double]) {
        for i in 0 ..< values.count {
            values[i] = self.randomFloat(in: range)
        }
    }

}
