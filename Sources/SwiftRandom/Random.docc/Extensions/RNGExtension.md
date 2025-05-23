# ``SwiftRandom/RNG``

The Random Number Generator

## Overview

The RNG structure generates random numbers and certain random distributions.
It is based on a structure that conforms to the ``BitGenerator`` protocol.

There are four such structures:

* ``MT32`` that uses the 32 bit Mersenne Twister algorithm
* ``MT64`` that uses the 64 bit Mersenne Twister algorithm
* ``PCG32`` that uses the 32 bit Permuted Congruential Generator algorithm
* ``PCG64`` that uses the 64 bit Permuted Congruential Generator algorithm

The internal state of a generator instance can be saved with the ``getState()`` method and reinstated later with the ``setState(state:)`` method.

## Topics

### Properties

- ``description``

### Constructor

- ``init(bg:)``

### Methods

- ``randomBit()``
- ``randomFloat(in:)``
- ``getState()``
- ``setState(state:)``

### Open range

- ``randomInt(in:)-8y1hy``
- ``randomInt(in:)-1ug2q``
- ``randomInt(in:)-4tmq0``
- ``randomInt(in:)-3adg7``
- ``randomUInt(in:)-2sjl8``
- ``randomUInt(in:)-21cbi``
- ``randomUInt(in:)-951fa``
- ``randomUInt(in:)-4lfl5``

### Closed range

- ``randomInt(in:)-3yfbi``
- ``randomInt(in:)-3sq9o``
- ``randomInt(in:)-52ntn``
- ``randomInt(in:)-8faww``
- ``randomUInt(in:)-6cd56``
- ``randomUInt(in:)-504a7``
- ``randomUInt(in:)-13u8b``
- ``randomUInt(in:)-2yf6x``

### Distributions

- ``uniformDistribution(in:values:)``
- ``normalDistribution(mean:stdev:values:)``
- ``exponentialDistribution(mean:values:)``
- ``meanValue(of:)``
- ``variance(of:)``
- ``standardDeviation(of:)``
