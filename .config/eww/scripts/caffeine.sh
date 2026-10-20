#!/bin/bash
if pgrep -f "systemd-inhibit.*[C]affeine" > /dev/null; then echo on; else echo off; fi
