# Performance

##

The SwiftRandom performance was measured on a MacBook Pro 2024, Apple M3 chip.

The number of values that are generated per second is shown below - units are millions / second.

| Type          | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| randomFloat   |       89 |      128 |      160 |      189 |
| randomInt     |       92 |      129 |      168 |      190 |
| randomUInt    |       92 |      129 |      168 |      190 |



The time it takes to generate a distribution with 1.000.000 numbers is shown below - units are milli seconds.

| Distribution  | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| Uniform       |  11 mSec |   8 mSec |   6 mSec |   6 mSec |
| Normal        |  20 mSec |  16 mSec |  14 mSec |  12 mSec |
| Exponential   |  15 mSec |  11 mSec |  10 mSec |   9 mSec |
