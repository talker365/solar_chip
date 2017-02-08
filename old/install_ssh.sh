#!/bin/bash

# Push files to CHIP...
expect push.exp ipt_MASQUERADE.ko /tmp/. root chip.local chip
expect push.exp nf_nat_masquerade_ipv4.ko /tmp/. root chip.local chip
expect push.exp routine /tmp/. root chip.local chip

# Begin installation on the CHIP...
expect begin.exp "bash /tmp/routine" root chip.local chip

