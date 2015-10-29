# MATLAB
various MATLAB projects
-----------------------

===
my_huff_encode.m
===
[val, code] = my_huff_encode(i)
This file implements the Huffman coding algorithm.
It takes a matrix or vector 'i' of raw input data and generates the coding scheme.
'val' and 'code' are both vectors.
code[i] gives the 1/0 bitstream code (terminated by a '2'),
val[i] gives the actual data that corresponds to code[i].
The source code contains simplied Chinese characters. Recommended character set is GB2312.

===
lane_detect/observation.m
===
This file uses Hough Transform to detect left/right edge of the lane.
The raw images are in img/ directory.