# ``SwiftRandom``

Random Number Generation

## Overview

The SwiftRandom package generates various types of random numbers using the Mersenne Twister algorithm
or the Permuted Congruential Generator algorithm.

It generates the following:

* Random floating point values in a specified open or closed range
* Random integers in a specified open or closed range
* Random unsigned integers in a specified open or closed range
* Random bits
* A uniform distribution in a specified open or closed range
* A normal distribution with specified mean and deviation
* An exponential distribution with specified mean

Random number generation uses a ``BitGenerator`` which is one of ``MT32``, ``MT64``, ``PCG32`` or ``PCG64``.

> Important:
SwiftRandom is not suitable for cryptographic applications.

### Example 1

```swift
import SwiftRandom

// Create the BitGenerator to use, f.ex. PCG32 based on initial state = 1234
let pcg32 = PCG32(state: 1234)

// Create the RNG instance
let rng = RNG(bg: pcg32)

// Create 20 normal distributed values with mean 2.0 and standard deviation 1.3
var x = [Double](repeating: 0.0, count: 20)
rng.normalDistribution(mean: 2.0, stdev: 1.3, values: &x)

print(x)
```

giving:

```swift
[2.1734545110811996, 1.335732163289224, 0.941024900396149, 3.2264230814632975, 5.459014841733499,
1.800905802727681, 1.8800986950394902, 4.590683327055603, 1.0172035621489117, 2.9474413989338397,
0.6246918556470995, 2.851867736518513, 2.753185266377434, -0.3036907536413542, 2.5184316925825057,
2.8841595259841846, 0.6693799134497671, 1.94079213687274, 1.3378909025908157, 2.564141001379788]
```

### Example 2

```swift
import SwiftRandom

// Simulate 1000 dice rolls

let rng = RNG(bg: PCG64())
var counts = [Int](repeating: 0, count: 6)

for _ in 0 ..< 1000 {
    let dice = rng.randomInt(in: 1 ... 6)
    counts[dice - 1] += 1
}

print(counts)

```

giving (for example):

```swift
[152, 163, 166, 176, 191, 152]
```

### Usage

To use SwiftRandom, in your project Package.swift file add a dependency like

```swift
dependencies: [
  package(url: "https://github.com/leif-ibsen/SwiftRandom", from: "1.0.0"),
]
```

SwiftRandom itself does not depend on other packages.

> Important:
SwiftRandom requires Swift 5.0. It also requires that the `Int` and `UInt` types be 64 bit types.

## Topics

### Classes

- ``SwiftRandom/RNG``
- ``SwiftRandom/MT32``
- ``SwiftRandom/MT64``
- ``SwiftRandom/PCG32``
- ``SwiftRandom/PCG64``

### Protocols

- ``SwiftRandom/BitGenerator``

### Type Aliases

- ``SwiftRandom/Byte``
- ``SwiftRandom/Bytes``
- ``SwiftRandom/UInt128``

### Additional Information

- <doc:Performance>
- <doc:References>
