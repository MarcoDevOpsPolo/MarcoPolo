#!/usr/bin/env python3

import optparse # for handling command line arguments (positional parameters), flags
import math
import sys # for sys.argv
import re # regex

def ceil_log_2(n):
	'''Returns the ceiling of the 2 based logarithm of n'''
	return math.ceil(math.log2(n))

def validate_binary_format(binIP):
	'''Validates wheter a string is in the valid binary format in python'''
	binStrPattern=re.compile("^0b[01]+$")	# starts with 0b, followed by 0 or 1 until end of line
	if not binStrPattern.match(str(binIP)):
	  raise TypeError("provided value: "+str(binIP)+" is not in binary format")
	return True

def bin_ipv4_to_octets(binIP):
	'''Converts a number from valid python binary format to IPv4 octets string
	e.g.:
	'0b0000001010000000001111111100000000' -> '10.0.255.0' '''
	if not validate_binary_format(binIP):
	  raise TypeError("binary IPv4 address "+str(binIP)+" is not in required format")
	binStr32=convert_to_32_bit_bin_str(binIP)
	return str(int(binStr32[0:8],2))+"."+str(int(binStr32[8:16],2))+"."+str(int(binStr32[16:24],2))+"."+str(int(binStr32[24:32],2))


def generate_n_zeros_str(n):
	'''generate a string with n zeroes in it'''
	s=''
	for i in range(n):
	  s+='0'
	return s
	 
def convert_to_32_bit_bin_str(binIP):
	'''Converts a number from valid python binary format to a 32 char long string that represents a binary number.
	e.g.:
	'0b1010' -> '0000000000000000000000000000001010' '''
	if not validate_binary_format(binIP):
	  raise TypeError("binary IPv4 address "+str(binIP)+" is not in required format")
	binStr32=binIP[2:]
	if len(binStr32)>32:
	  if len(binStr32)-binStr32.find('1')>32:
	    raise TypeError("in provided "+str(binIP)+" the valuable part is longer than 32 bits")
	  else:
		binStr32=binStr32[binStr32.find('1'):]
	if len(binStr32)<32:
	  binStr32=generate_n_zeros_str(32-len(binStr32))+binStr32
	return binStr32


if __name__ == '__main__':
	parser = optparse.OptionParser()
	opts, args = parser.parse_args()
	#print(ceil_log_2(int(sys.argv[1])))
	binary_ipv4_to_octets(sys.argv[1])
