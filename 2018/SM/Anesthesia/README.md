# Anesthesia benchmark model

This folder contains the resuls obtained to solve Benchmark 1 - Anesthesia model using 

1. SReachTools
2. FAUST^2

## SReachTools

SReachTools is part of this repeatability package as a git submodule.

For repeatability evaluation, please do the following:
1. Ensure the following the dependencies are met:
   1. MATLAB 2017 (tested)
   1. MPT3
   1. CVX
   1. MATLAB Global Optimization Toolbox
   1. MATLAB Statistical and Machine Learning Toolbox
2. Download SReachTools package by initializing the SReachTools submodule in the ARCH-COMP git repository, ```$ git submodule update --init```.
3. Open MATLAB and cd into the toolbox, ```>>> cd
<path_to_ARCHCOMP_git>/2018/SM/Anesthesia/SReachTools/```.
4. Add the toolbox to the path in MATLAB, ```>>> srtinit```.
5. Next, run in MATLAB the Live Editor file in ```SReachTools/examples/AutomatedAnesthesiaDelivery.mlx``` to obtain the
results.
