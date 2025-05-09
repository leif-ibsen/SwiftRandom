# ``SwiftRandom/BitGenerator``

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview

The BitGenerator protocol inherits from the RandomNumberGenerator protocol.
A BitGenerator instance can thus be used when a RandomNumberGenerator instance is required.

The bit generators that implement this protocol are deterministic.
Their sequence of generated values depends only on the seed they were instantiated with.

## Topics

### Methods

- ``nextUInt32()``
- ``nextUInt64()``
- ``nextUInt128()``
- ``nextBit()``
- ``getState()``
- ``setState(state:)``


