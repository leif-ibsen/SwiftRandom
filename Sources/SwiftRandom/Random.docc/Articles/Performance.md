# Performance

##

The SwiftRandom performance was measured on a MacBook Pro 2024, Apple M3 chip.

The number of values that are generated per second is shown below - units are million numbers / second.

| Type          | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| randomFloat   |       52 |       83 |       76 |      111 |
| randomInt     |       91 |      125 |      142 |      167 |
| randomUInt    |       91 |      125 |      142 |      167 |



The time it takes to generate a distribution with 1.000.000 numbers is shown below - units are milli seconds.

| Distribution  | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| Uniform       |  12 mSec |   8 mSec |   6 mSec |   6 mSec |
| Normal        |  23 mSec |  17 mSec |  15 mSec |  13 mSec |
| Exponential   |  15 mSec |  12 mSec |  10 mSec |   9 mSec |
