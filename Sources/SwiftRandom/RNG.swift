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

public struct RNG: CustomStringConvertible {
    
    static let D53 = Double(1 << 53)
    
    // Double value in 0.0 ..< 1.0
    mutating func nextDouble() -> Double {
        return Double(self.bitGenerator.nextUInt64() & 0x1fffffffffffff) / RNG.D53
    }

    var bitGenerator: BitGenerator
    
    /// Constructs an RNG instance from a bit generator
    ///
    /// - Parameters:
    ///   - bg: An instance of a structure that conforms to the ``BitGenerator`` protocol
    public init(bg: BitGenerator) {
        self.bitGenerator = bg
    }
    
    /// Description of `self`
    public var description: String {
        return "RNG based on " + self.bitGenerator.description
    }

    /// Random bit
    ///
    /// - Returns: A random bit
    public mutating func randomBit() -> Bool {
        return self.bitGenerator.nextBit()
    }

    // Open range
    
    /// Random integer value
    ///
    /// - Parameters:
    ///   - range: An open `Int` range
    /// - Returns: A random integer in the specified range
    public mutating func randomInt(in range: Range<Int>) -> Int {
        return randomInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open `Int32` range
    /// - Returns: A random 32 bit integer in the specified range
    public mutating func randomInt(in range: Range<Int32>) -> Int32 {
        return randomInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open `Ìnt64` range
    /// - Returns: A random 64 bit integer in the specified range
    public mutating func randomInt(in range: Range<Int64>) -> Int64 {
        return randomInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random 128 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open `Int128` range
    /// - Returns: A random 128 bit integer in the specified range
    public mutating func randomInt(in range: Range<Int128>) -> Int128 {
        return randomInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random unsigned integer value
    ///
    /// - Parameters:
    ///   - range: An open `UInt` range
    /// - Returns: A random unsigned integer in the specified range
    public mutating func randomUInt(in range: Range<UInt>) -> UInt {
        return randomUInt(in: range.lowerBound ... range.upperBound - 1)
    }
    
    /// Random unsigned 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open `UInt32` range
    /// - Returns: A random unsigned 32 bit integer in the specified range
    public mutating func randomUInt(in range: Range<UInt32>) -> UInt32 {
        return randomUInt(in: range.lowerBound ... range.upperBound - 1)
    }
    
    /// Random unsigned 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open `UInt64` range
    /// - Returns: A random unsigned 64 bit integer in the specified range
    public mutating func randomUInt(in range: Range<UInt64>) -> UInt64 {
        return randomUInt(in: range.lowerBound ... range.upperBound - 1)
    }

    /// Random unsigned 128 bit integer value
    ///
    /// - Parameters:
    ///   - range: An open `UInt128` range
    /// - Returns: A random unsigned 128 bit integer in the specified range
    public mutating func randomUInt(in range: Range<UInt128>) -> UInt128 {
        return randomUInt(in: range.lowerBound ... range.upperBound - 1)
    }

    // Closed range
    
    /// Random integer value
    ///
    /// - Parameters:
    ///   - range: A closed `Int` range
    /// - Returns: A random integer in the specified range
    public mutating func randomInt(in range: ClosedRange<Int>) -> Int {
        return Int(randomInt(in: Int64(range.lowerBound) ... Int64(range.upperBound)))
    }

    /// Random 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed `Int32` range
    /// - Returns: A random 32 bit integer in the specified range
    public mutating func randomInt(in range: ClosedRange<Int32>) -> Int32 {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = UInt32(bitPattern: range.upperBound &- range.lowerBound)
        let mask = UInt32(0xffffffff) >> size.leadingZeroBitCount
        var x: UInt32
        repeat {
            x = self.bitGenerator.nextUInt32() & mask
        } while x > size
        return range.lowerBound &+ Int32(bitPattern: x)
    }

    /// Random 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed `Int64` range
    /// - Returns: A random 64 bit integer in the specified range
    public mutating func randomInt(in range: ClosedRange<Int64>) -> Int64 {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = UInt64(bitPattern: range.upperBound &- range.lowerBound)
        let mask = UInt64(0xffffffffffffffff) >> size.leadingZeroBitCount
        var x: UInt64
        repeat {
            x = self.bitGenerator.nextUInt64() & mask
        } while x > size
        return range.lowerBound &+ Int64(bitPattern: x)
    }

    /// Random 128 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed `Int128` range
    /// - Returns: A random 128 bit integer in the specified range
    public mutating func randomInt(in range: ClosedRange<Int128>) -> Int128 {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = UInt128(bitPattern: range.upperBound &- range.lowerBound)
        let mask = UInt128(0xffffffffffffffffffffffffffffffff) >> size.leadingZeroBitCount
        var x: UInt128
        repeat {
            x = self.bitGenerator.nextUInt128() & mask
        } while x > size
        return range.lowerBound &+ Int128(bitPattern: x)
    }

    /// Random unsigned integer value
    ///
    /// - Parameters:
    ///   - range: A closed `UInt` range
    /// - Returns: A random unsigned integer in the specified range
    public mutating func randomUInt(in range: ClosedRange<UInt>) -> UInt {
        return UInt(randomUInt(in: UInt64(range.lowerBound) ... UInt64(range.upperBound)))
    }

    /// Random unsigned 32 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed `UInt32` range
    /// - Returns: A random unsigned 32 bit integer in the specified range
    public mutating func randomUInt(in range: ClosedRange<UInt32>) -> UInt32 {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = range.upperBound - range.lowerBound
        let mask = UInt32(0xffffffff) >> size.leadingZeroBitCount
        var x: UInt32
        repeat {
            x = self.bitGenerator.nextUInt32() & mask
        } while x > size
        return range.lowerBound + x
    }

    /// Random unsigned 64 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed `UInt64` range
    /// - Returns: A random unsigned 64 bit integer in the specified range
    public mutating func randomUInt(in range: ClosedRange<UInt64>) -> UInt64 {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = range.upperBound - range.lowerBound
        let mask = UInt64(0xffffffffffffffff) >> size.leadingZeroBitCount
        var x: UInt64
        repeat {
            x = self.bitGenerator.nextUInt64() & mask
        } while x > size
        return range.lowerBound + x
    }

    /// Random unsigned 128 bit integer value
    ///
    /// - Parameters:
    ///   - range: A closed `UInt128` range
    /// - Returns: A random unsigned 128 bit integer in the specified range
    public mutating func randomUInt(in range: ClosedRange<UInt128>) -> UInt128 {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        let size = range.upperBound - range.lowerBound
        let mask = UInt128(0xffffffffffffffffffffffffffffffff) >> size.leadingZeroBitCount
        var x: UInt128
        repeat {
            x = self.bitGenerator.nextUInt128() & mask
        } while x > size
        return range.lowerBound + x
    }

    /// Random floating point value
    ///
    /// - Parameters:
    ///   - range: An open `Double` range
    /// - Returns: A random floating point value in the specified range
    public mutating func randomFloat(in range: Range<Double>) -> Double {
        return range.lowerBound + (range.upperBound - range.lowerBound) * self.nextDouble()
    }
    
    /// Retrieve the internal generator state
    ///
    /// - Returns:The internal state of the underlying bit generator
    public func getState() -> Bytes {
        return self.bitGenerator.getState()
    }

    /// Reinstate the internal generator state
    ///
    /// - Parameters:
    ///   - state: The new internal state of the underlying bit generator
    public mutating func setState(state: Bytes) {
        self.bitGenerator.setState(state: state)
    }

    /// Generates an array of normal distributed values
    ///
    /// - Precondition: The standard deviation is positive
    /// - Parameters:
    ///   - mean: The mean value
    ///   - stdev: The standard deviation, a positive number
    ///   - values: Filled with the generated values
    public mutating func normalDistribution(mean: Double, stdev: Double, values: inout [Double]) {
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
    public mutating func exponentialDistribution(mean: Double, values: inout [Double]) {
        precondition(mean > 0.0, "Mean value must be positive")
        self.uniformDistribution(in: 0.0 ..< 1.0, values: &values)
        for i in 0 ..< values.count {
            values[i] = -log(1.0 - values[i]) * mean
        }
    }

    /// Generates an array of uniformly distributed values in an open range
    ///
    /// - Parameters:
    ///   - range: An open `Double` range
    ///   - values: Filled with the generated values
    public mutating func uniformDistribution(in range: Range<Double>, values: inout [Double]) {
        for i in 0 ..< values.count {
            values[i] = self.randomFloat(in: range)
        }
    }
    
    /// Compute mean value
    ///
    /// - Precondition: Values must not be empty
    /// - Parameters:
    ///   - values: Values to compute mean value of
    /// - Returns: The mean value
    public func meanValue(of values: [Double]) -> Double {
        precondition(values.count > 0, "Values must not be empty")
        var x = 0.0
        for i in 0 ..< values.count {
            x += values[i]
        }
        return x / Double(values.count)
    }

    /// Compute variance
    ///
    /// - Precondition: Values must not be empty
    /// - Parameters:
    ///   - values: Values to compute variance of
    /// - Returns: The variance
    public func variance(of values: [Double]) -> Double {
        precondition(values.count > 0, "Values must not be empty")
        var sum = 0.0
        let mean = self.meanValue(of: values)
        for i in 0 ..< values.count {
            sum += pow(values[i] - mean, 2)
        }
        return sum / Double(values.count)
    }
    
    /// Compute standard deviation
    ///
    /// - Precondition: Values must not be empty
    /// - Parameters:
    ///   - values: Values to compute standard deviation of
    /// - Returns: The standard deviation
    public func standardDeviation(of values: [Double]) -> Double {
        precondition(values.count > 0, "Values must not be empty")
        return self.variance(of: values).squareRoot()
    }

}
