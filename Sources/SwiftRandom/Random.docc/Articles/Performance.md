# Performance

##

The SwiftRandom performance was measured on an iMac 2021, Apple M1 chip.

The number of values - in millions - that are generated per second is shown below.

| Type          | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| randomFloat   |       60 |       95 |      117 |      144 |
| randomInt     |       71 |      101 |      132 |      151 |
| randomUInt    |       71 |      101 |      132 |      151 |



The time it takes to generate a distribution with 1.000.000 numbers - units are milli seconds - is shown below.

| Distribution  | MT32     | MT64     | PCG32    | PCG64    |
|:--------------|---------:|---------:|---------:|---------:|
| Uniform       |  15 mSec |  11 mSec |  10 mSec |   7 mSec |
| Normal        |  30 mSec |  23 mSec |  20 mSec |  17 mSec |
| Exponential   |  20 mSec |  17 mSec |  15 mSec |  12 mSec |
