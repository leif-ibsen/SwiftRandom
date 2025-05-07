## SwiftRandom

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

SwiftRandom is not suitable for cryptographic applications.

SwiftRandom requires Swift 6.0. It also requires that the `Int` and `UInt` types be 64 bit types.

SwiftRandom uses the `Int128` and `UInt128` types. Therefore, for `macOS` the version must be at least 15,
for `iOS` the version must be at least 18, and for `watchOS` the version must be at least 11.

Its documentation is build with the DocC plugin and published on GitHub Pages at this location:

https://leif-ibsen.github.io/SwiftRandom/documentation/swiftrandom

The documentation is also available in the *SwiftRandom.doccarchive* file.
