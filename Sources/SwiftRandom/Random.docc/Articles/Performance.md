# Performance

##

The SwiftRandom performance was measured on a MacBook Pro 2024, Apple M3 chip.

The number of values that are generated per second is shown below - units are millions / second.

| Type          | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| randomFloat   |      103 |      141 |      156 |      210 |
| randomInt     |      150 |      246 |      156 |      210 |
| randomUInt    |      151 |      246 |      157 |      210 |



The time it takes to generate a distribution with 1.000.000 numbers is shown below - units are milli seconds.

| Distribution  | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| Uniform       |   5 mSec |   3 mSec |   5 mSec |   4 mSec |
| Normal        |  13 mSec |  10 mSec |  11 mSec |  11 mSec |
| Exponential   |   9 mSec |   7 mSec |   8 mSec |   7 mSec |
