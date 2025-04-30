# ``SwiftRandom/RNG``

The Random Number Generator

## Overview

The RNG class generates random numbers and certain random distributions.
It is based on a class that conforms to the ``BitGenerator`` protocol.

There are four such classes:

* ``MT32`` that uses the 32 bit Mersenne Twister algorithm
* ``MT64`` that uses the 64 bit Mersenne Twister algorithm
* ``PCG32`` that uses the 32 bit Permuted Congruential Generator algorithm
* ``PCG64`` that uses the 64 bit Permuted Congruential Generator algorithm

The internal state of a generator instance can be saved with the ``getState()`` method and reinstated later with the ``setState(state:)`` method.

## Topics

### Constructor

- ``init(bg:)``

### Methods

- ``randomBit()``
- ``getState()``
- ``setState(state:)``

### Open range

- ``randomInt(in:)-4lun3``
- ``randomInt(in:)-3wjtg``
- ``randomInt(in:)-4hjuu``
- ``randomUInt(in:)-53fz8``
- ``randomUInt(in:)-46j03``
- ``randomUInt(in:)-487j0``
- ``randomFloat(in:)-9uni9``

### Closed range

- ``randomInt(in:)-8hvsa``
- ``randomInt(in:)-1ox85``
- ``randomInt(in:)-6fu34``
- ``randomUInt(in:)-5b46m``
- ``randomUInt(in:)-64t51``
- ``randomUInt(in:)-29xcy``
- ``randomFloat(in:)-yaia``

### Distributions

- ``uniformDistribution(in:values:)-51y8o``
- ``uniformDistribution(in:values:)-moek``
- ``normalDistribution(mean:stdev:values:)``
- ``exponentialDistribution(mean:values:)``
