#!/usr/bin/env python3

import optparse # for handling command line arguments (positional parameters)
import math
import sys

def ceil_log_2(n):
	return math.ceil(math.log2(n))

if __name__ == '__main__':
	parser = optparse.OptionParser()
	opts, args = parser.parse_args()
	print(ceil_log_2(int(sys.argv[1])))
