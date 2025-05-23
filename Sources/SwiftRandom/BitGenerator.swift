//
//  Protocol.swift
//  SwiftRandom
//
//  Created by Leif Ibsen on 18/04/2024.
//

/// The bit generator protocol that the RNG structure requires
public protocol BitGenerator: RandomNumberGenerator {

    /// Description of `self`
    var description: String { get }

    /// Generate a random 32 bit unsigned integer
    ///
    /// - Returns: A random 32 bit unsigned integer
    mutating func nextUInt32() -> UInt32
    
    /// Generate a random 64 bit unsigned integer
    ///
    /// - Returns: A random 64 bit unsigned integer
    mutating func nextUInt64() -> UInt64
    
    /// Generate a random 128 bit unsigned integer
    ///
    /// - Returns: A random 128 bit unsigned integer
    mutating func nextUInt128() -> UInt128
    
    /// Generate a random bit
    ///
    /// - Returns: A random bit
    mutating func nextBit() -> Bool

    /// Retrieve the internal generator state
    ///
    /// - Returns: The internal generator state
    func getState() -> Bytes
    
    /// Reinstate the internal generator state
    ///
    /// - Parameters:
    ///   - state: The new internal generator state
    mutating func setState(state: Bytes)

}
