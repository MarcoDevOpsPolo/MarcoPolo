#!/usr/bin/env python3

import optparse # for handling command line arguments (positional parameters)
import math
import sys # for sys.argv
import re # regex

def ceil_log_2(n):
	return math.ceil(math.log2(n))

def binary_ipv4_to_octets(binIP):
	binStrPattern=re.compile("^0b[01]+$")	# starts with 0b, followed by 0 or 1 until end of line
	if not binStrPattern.match(str(binIP)):
	  raise TypeError(str(binIP)+" provided is not in binary format")
	print("great success")


if __name__ == '__main__':
	parser = optparse.OptionParser()
	opts, args = parser.parse_args()
	#print(ceil_log_2(int(sys.argv[1])))
	binary_ipv4_to_octets(sys.argv[1])
