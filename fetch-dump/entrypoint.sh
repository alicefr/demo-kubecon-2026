#!/bin/bash

dump=$(ls /data/*.memory.dump)
strings $dump |grep secretpassword && true || echo "nothing found"
