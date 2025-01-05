#!/usr/bin/env python3

import optparse  # for handling command line arguments (positional parameters), flags
import math
import sys  # for sys.argv
import re  # regex


def ceil_log_2(n):
    """Returns the ceiling of the 2 based logarithm of n"""
    return math.ceil(math.log2(n))


def validate_binary_format(binIP):
    """Validates wheter a string is in the valid binary format in python"""
    binStrPattern = re.compile(
        r"^0b[01]+$"
    )  # starts with 0b, followed by 0 or 1 until end of line
    if not binStrPattern.match(str(binIP)):
        raise TypeError("provided value: " + str(binIP) + " is not in binary format")
    return True


def bin_ipv4_to_octets(binIP):
    """Converts a number from valid python binary format to IPv4 octets string
    e.g.:
    '0b0000001010000000001111111100000000' -> '10.0.255.0'"""
    if not validate_binary_format(binIP):
        raise TypeError(
            "binary IPv4 address " + str(binIP) + " is not in required format"
        )
    binStr32 = convert_to_32_bit_bin_str(binIP)
    return (
        str(int(binStr32[0:8], 2))
        + "."
        + str(int(binStr32[8:16], 2))
        + "."
        + str(int(binStr32[16:24], 2))
        + "."
        + str(int(binStr32[24:32], 2))
    )


def validate_octet_pattern(octetStr):
    """octet validation"""
    looseIPv4Pattern = re.compile(
        r"^(\d{1,3}\.){3}\d{1,3}$"
    )  # Any string that has 3 dots separating 1-3 digits packs. Not full validation, e.g. 999.999.999.999 goes through.
    if not looseIPv4Pattern.match(str(octetStr)):
        raise TypeError(
            "provided value: " + str(octetStr) + " is not in octet ipv4 format!"
        )
    return True


def octets_to_bin_ipv4(octetStr):
    """converts from octet ipv4 to python binary string
    e.g.:
    '10.10.255.0' -> '0b000000101000000010101111111100000000'"""
    validate_octet_pattern(octetStr.strip())
    octets = octetStr.split(".")
    binStr = ""
    for i in octets:
        part = bin(int(i))[2:]
        if len(part) > 8:
            raise ValueError("the given octet (" + str(i) + ") is larger than 255!")
        if len(part) < 8:
            part = generate_n_zeros_str(8 - len(part)) + part
        binStr += part
    return "0b" + binStr


def generate_n_zeros_str(n):
    """generate a string with n zeroes in it"""
    if n < 1:
        return ""
    s = ""
    for i in range(n):
        s += "0"
    return s


def convert_to_32_bit_bin_str(binIP):
    """Converts a number from valid python binary format to a 32 char long string that represents a binary number.
    e.g.:
    '0b1010' -> '0000000000000000000000000000001010'"""
    if not validate_binary_format(binIP):
        raise TypeError(
            "binary IPv4 address " + str(binIP) + " is not in required format"
        )
    binStr32 = binIP[2:]
    if len(binStr32) > 32:
        if len(binStr32) - binStr32.find("1") > 32:
            raise TypeError(
                "in provided "
                + str(binIP)
                + " the valuable part is longer than 32 bits"
            )
        else:
            binStr32 = binStr32[binStr32.find("1") :]
    if len(binStr32) < 32:
        binStr32 = generate_n_zeros_str(32 - len(binStr32)) + binStr32
    return binStr32


def allocate_cidr(batchSizes=[2], start="10.0.0.0", ipclass="A", mask=8, minimal=True):
    """Allocate CIDR ranges by given parameters.
    Invoke validation process.
    Parameters:
    batcheSizes: Array of integers, contains the minimum required ammount of addresses per subnet. Number of elements also determines the number of subnets that will be created.
    start: The first address of the first subnet. Mask not required in all cases, could lead to clash.
    ipclass: the class of the main network. Class A: 10.*.*.*, Class B: 172.16.*.*-172.31.*.*, Class C: 192.168.*.* NOT IMPLEMENTED YET
    mask: the mask of the main network.
    minimal: Generates the smallest possible networks based on the given data. OTHER OPTION NOT IMPLEMENTED YET.
    """
    """
	calculate required network sizes
	sort them by size, ascending
	Convert start to bin.
	Fill network sizes? I guess?
	"""
    batches = []
    for i in batchSizes:
        batch = {"size": i, "requiredFreeMaskingSize": ceil_log_2(i)}
        batches.append(batch)
    batches.sort(key=lambda x: x["requiredFreeMaskingSize"], reverse=True)

    i = 0
    while i < len(batches):
        if i == 0:
            batches[i]["startIP"] = start
        else:
            prevStart = batches[i - 1]["startIP"]
            binPrevStart = octets_to_bin_ipv4(prevStart)
            intPrevStart = int(binPrevStart, 2)
            intThisStart = intPrevStart + 2 ** batches[i - 1]["requiredFreeMaskingSize"]
            binThisStart = bin(intThisStart)
            batches[i]["startIP"] = bin_ipv4_to_octets(binThisStart)
        batches[i]["mask"] = 32 - batches[i]["requiredFreeMaskingSize"]
        i += 1
    return batches


def print_cidr_only(batches):
    for i in batches:
        print(str(i["startIP"]) + "/" + str(i["mask"]))


if __name__ == "__main__":
    parser = optparse.OptionParser()
    opts, args = parser.parse_args()
    print_cidr_only(allocate_cidr(batchSizes=[80, 10000, 30, 916]))
