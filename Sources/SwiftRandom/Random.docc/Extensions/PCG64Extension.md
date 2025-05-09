# ``SwiftRandom/PCG64``

The 64 bit Permuted Congruential Generator: PCG-XSL-RR

## Topics

### Constants

- ``Multiplier``
- ``DefaultIncrement``

### Constructors

- ``init()``
- ``init(state:increment:)``
- ``init(pcg:advanced:)``

### Methods

- ``next()``
- ``nextUInt32()``
- ``nextUInt64()``
- ``nextUInt128()``
- ``nextBit()``
- ``getState()``
- ``setState(state:)``
- ``advance(n:)``

### Equality
- ``==(_:_:)``
- ``!=(_:_:)``
