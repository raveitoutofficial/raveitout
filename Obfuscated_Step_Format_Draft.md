# RIO Note Data Draft

## Encoding

Data is encoded in a stream of ASCII printable characters.

Characters should be interpreted as their ASCII character code (except a few that I will describe below), having 7 bits.

1. A character starting with bits 00 must be reinterpreted as such:
  * Character 9 (horizontal tab) should be reinterpreted as having the value 127 instead.
  * The sequence of characters 13 and 10 (CRLF, hex 0D 0A) should be reinterpreted as having the value 59 (hex 3B), because that is normally the semicolon.
2. A character starting with bits 01 must start a measure, and contains 5 bits of data.
3. A character starting with bit 1 must NOT start a measure, and contain 6 bits of data.

That is, each measure (units separated by commas in .sm and .ssc) starts with a character between space and ? (hex 20 to 3F), and ends with the start of another measure.

The note data must end in one single literal semicolon.

## Masking

Because a stepchart may have long stretches of 0's, each measure should apply a repeating XOR filter pattern to make it harder for someone uninstructed to decode. A simple pseudorandom number generator should be used to generate this filter, so that the filters themselves are not stored in the program.

### Generating the XOR filter
(Not final implementation, could change)
Use Linear Congruence Method:

X(n+1) = (X(n) * A + B) % M

M == 256. A must be 1 more than a multiple of 4, and B must be an odd number, which guarantees the *maximum* period to equal 256.

Use the measure number for the seed.

A is 1+d*4, where d is equal to the difficulty rating of the chart modulo 64. If it is a single chart, B is 573. If it is a double chart, B is 365.

For any seed, this has a period of 256 for all seeds (at least, it seems for the first 128).
The lowest few bits follow a regular pattern, so only the 5 most significant digits should be used to mask the information.

Because XORing twice with the same number yields the original number, reading the data simply requires applying the same filter again.

## Data encoded

Notes are stored in a format similar to Stepmania, except each code takes 3 or 5 bits of data instead of one character.

The code is made of 3 bits for the object type, followed by 2 bits for the player number if necessary. Each measure consists of a number of codes that equals the number of panels multiplied by 4, 8, 12, 16, 24, 32, 48, or 64.

The data must be saved in 6 + 5n bits per measure, but because we know how many codes we can expect in a measure, we can safely discard up to 5 bits of data.
If, prior to encountering a character with header 01, there are up to 5 bits of data left over, they should be discarded.
When saving, these extra bits may be filled with anything, or possibly a simple parity check. I will leave that out for now.

* 000 - nothing (doesn't need player number)
* 001 - mine (doesn't need player number)
* 010 - tap
* 011 - lift
* 100 - hold head
* 101 - roll head
* 110 - tail
* 111 - fake

* 00 - Player 1 (Blue)
* 01 - Player 2 (Red)
* 10 - Player 3 (Yellow)
* 11 - Player 4 (Green)

## Future-proofing
For future-proofing, the notedata should include the custom SSC tag #RIOVERSION, should the algorithm change.