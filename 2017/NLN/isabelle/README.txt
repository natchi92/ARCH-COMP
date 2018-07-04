Isabelle/HOL-ODE-Numerics:

This package includes:

- isabelle_hol_ode_numerics.ML
- ARCH_NLN_Gen.thy


The .ML file is the Standard ML code generated from the formally verified algorithm in Isabelle/HOL. 
We use Isabelle/jEdit as IDE for ML: it already packages all the dependencies. The setup for the
 examples of the ARCH-NLN competition can be found in the ARCH_NLN_Gen.thy file.


Installation/Requirements:
==========================
- Download Isabelle2016-1 from https://isabelle.in.tum.de/
- Installation and and Requirements (Isabelle runs on most operating systems simply out of the box)
  are detailed on https://isabelle.in.tum.de/installation.html

Short instructions
==================

1) open ARCH_NLN_Gen.thy in Isabelle's IDE, wait for "Isabelle build" to finish
2) scroll to the bottom of the file
3) wait until all violet marks disappear
4) inspect timings via menu "Plugins -> Isabelle -> Timing Panel"
5) in gnuplot:
  - plot "vanderpol.out" using 1:2:3:4:5 with vectors nohead lc rgb variable notitle
  - plot "laubloomis001.out" using 1:2:3:4:5 with vectors nohead lc rgb variable notitle
  - plot "laubloomis010.out" using 1:2:3:4:5 with vectors nohead lc rgb variable notitle


Detailed instructions
======================

1)- Open the Isabelle/jEdit Prover IDE:
    - on Linux: .../Isabelle2016-1/Isabelle2016-1
    - on Windows: The installer starts the Isabelle/jEdit Prover IDE automatically for the first time.
                  It also creates a desktop alias to the main executable for later use.
    - on Mac OS: open Isabelle2016-1.app
  - Open ARCH_NLN_Gen.thy in the IDE:
    - In the Menu: File->Open
  - A Popup Window "Isabelle build" appears on first start, wait for it to finish and
    close automatically.

2) 3)
ARCH_NLN_Gen.thy contains commands that compile and run the examples. The IDE automatically
processes everything up to the current visible commands. A violet background means that the command
is being processed, light red background means not yet processed, and white background means
processing has finished.

Scroll down "ARCH_NLN_Gen.thy" until you reach

"""
subsection \<open>Van der Pol\<close>

ML \<open>...
"""

This command sets up the Van der Pol system, runs it and output logging information to file
  "vanderpol.out".

Similarly, the last two commands
"ML_val \<open>run_laub_loomis "laubloomis001.out" ..."
"ML_val \<open>run_laub_loomis "laubloomis010.out" ..."
run the Laub Loomis benchmark.


4) The log files can be plotted using gnuplot by entering the following commands in the gnuplot prompt:

plot "vanderpol.out" using 1:2:3:4:5 with vectors nohead lc rgb variable notitle
plot "laubloomis001.out" using 1:2:3:4:5 with vectors nohead lc rgb variable notitle
plot "laubloomis010.out" using 1:2:3:4:5 with vectors nohead lc rgb variable notitle

5) Open the "Timing Panel" via the menu: "Plugins -> Isabelle -> Timing Panel"
  This panel lists timing information for individual commands. You can click on an item in the list
  and the cursor will jump to the corresponding command.