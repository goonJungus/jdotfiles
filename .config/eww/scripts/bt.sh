#!/bin/bash
if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then echo on; else echo off; fi
