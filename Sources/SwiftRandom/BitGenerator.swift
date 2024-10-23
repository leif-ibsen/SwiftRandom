//
//  Protocol.swift
//  SwiftRandom
//
//  Created by Leif Ibsen on 18/04/2024.
//

/// The bit generator protocol that the RNG class requires
public protocol BitGenerator {

    /// Generate a random 32 bit unsigned integer
    ///
    /// - Returns: A random 32 bit unsigned integer
    func nextUInt32() -> UInt32
    
    /// Generate a random 64 bit unsigned integer
    ///
    /// - Returns: A random 64 bit unsigned integer
    func nextUInt64() -> UInt64
    
    /// Generate a random floating point value in either 0.0 ..< 1.0 or 0.0 ... 1.0
    ///
    /// - Parameters:
    ///   - open:`true` implies 0.0 ..< 1.0 `false` implies 0.0 ... 1.0
    /// - Returns: A random floating point value in the specified range
    func nextDouble(open: Bool) -> Double

    /// Retrieve the internal generator state
    ///
    /// - Returns: The internal generator state
    func getState() -> Bytes
    
    /// Reinstate the internal generator state
    ///
    /// - Parameters:
    ///   - state: The new internal generator state
    func setState(state: Bytes)

}
