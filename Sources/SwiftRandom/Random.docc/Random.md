# ``SwiftRandom``

Random Number Generation

## Overview

The SwiftRandom package generates various types of random numbers using the Mersenne Twister algorithm
or the Permuted Congruential Generator algorithm.

It generates the following:

* Random floating point values in a specified open range
* Random integers in a specified open or closed range
* Random unsigned integers in a specified open or closed range
* Random bits
* A uniform distribution in a specified open range
* A normal distribution with specified mean and deviation
* An exponential distribution with specified mean
* Mean value, variance and standard deviation of a set of values

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

// Create 1000 normal distributed values with mean 2.0 and standard deviation 1.3
var x = [Double](repeating: 0.0, count: 1000)
rng.normalDistribution(mean: 2.0, stdev: 1.3, values: &x)

// See the actual mean and standard deviation
print("mean:  ", rng.meanValue(of: x))
print("stdDev:", rng.standardDeviation(of: x))
```

giving:

```swift
mean:   1.9523520613523375
stdDev: 1.2654344086187834
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
  package(url: "https://github.com/leif-ibsen/SwiftRandom", from: "3.0.0"),
]
```

SwiftRandom itself does not depend on other packages.

> Important:
SwiftRandom requires Swift 6.0. It also requires that the `Int` and `UInt` types be 64 bit types.
>
> SwiftRandom uses the `Int128` and `UInt128` types. Therefore, for `macOS` the version must be at least 15,
for `iOS` the version must be at least 18, and for `watchOS` the version must be at least 11.

## Topics

### Structures

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

### Additional Information

- <doc:Performance>
- <doc:References>
