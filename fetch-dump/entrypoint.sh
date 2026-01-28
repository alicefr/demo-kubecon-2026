#!/bin/bash

dump=$(ls /data/*.memory.dump)
strings $dump |grep "DUMPED DATA" && true || echo "nothing found"
