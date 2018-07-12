Modest Toolset dependencies:
- On Windows 10: none
- On Linux and Mac OS:
  Mono, version 5 or newer
  http://www.mono-project.com/download/stable/
  On Ubuntu and similar: package "mono-complete"

On Linux, after having installed the required dependencies, run the following commands to reproduce the results for version 4 of the heated tank benchmark as in the ARCH 2018 report:

unzip Modest.zip
mono Modest/modes.exe models/unheated-tank-4.modest -R Uniform --relative-width --width 0.05 -E "TIME_BOUND=500, C_FAIL=0" --rare FixedEffort --ifun-prop IDryOut 0 3 --levels StaticWidth 1 -O unheated-tank-4.dryout.replicated-results.txt -Y

This should take less than one minute of runtime and produces the output file
unheated-tank-4.dryout.replicated-results.txt
with the results that are also printed to stdout.

The other versions of the benchmark are included in files
- unheated-tank-1-3.modest (versions 1 and 3),
- unheated-tank-2.modest (version 2), and
- unheated-tank-4b.modest (variant of version 4 with different interpretation of the grace period)
in subfolder "Models". The files contain example command lines to reproduce the output that we obtained as included in the .txt files in subfolder "Results".
