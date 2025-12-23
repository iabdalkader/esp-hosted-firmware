#!/usr/bin/python3

import argparse

parser = argparse.ArgumentParser(description='Combine ESP-Hosted firmware binaries')
parser.add_argument('target', help='Target name (e.g., portenta_c33)')
parser.add_argument('version', help='ESP-Hosted version (e.g., v1.0.0.0.0)')
args = parser.parse_args()

basePath = "esp-hosted/esp_hosted_fg/esp/esp_driver/network_adapter/"

bootloaderData = open(basePath + "build/bootloader/bootloader.bin", "rb").read()
partitionData = open(basePath + "build/partition_table/partition-table.bin", "rb").read()
networkData = open(basePath + "build/network_adapter.bin", "rb").read()

# 0x0 bootloader.bin 0x8000 partition-table.bin 0x10000 network_adapter.bin

# calculate the output binary size, app offset
outputSize = 0x10000 + len(networkData)
if (outputSize % 1024):
	outputSize += 1024 - (outputSize % 1024)

# allocate and init to 0xff
outputData = bytearray(b'\xff') * outputSize

# copy data: bootloader, partitions, app
for i in range(0, len(bootloaderData)):
	outputData[0x0000 + i] = bootloaderData[i]

for i in range(0, len(partitionData)):
	outputData[0x8000 + i] = partitionData[i]

for i in range(0, len(networkData)):
	outputData[0x10000 + i] = networkData[i]

outputFilename = f"{args.target}-{args.version}.bin"

# write out
with open(outputFilename, "w+b") as f:
	f.seek(0)
	f.write(outputData)

print(f"✅ Built: {outputFilename}")
