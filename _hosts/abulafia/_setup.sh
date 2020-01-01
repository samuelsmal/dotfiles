#! /bin/bash

N_STEPS=1

# headphone audio fix
echo "(1/$N_STEPS) applying headphone fix"
bash ../_system-fixes/headphone_white_noise_fix/_setup.sh
