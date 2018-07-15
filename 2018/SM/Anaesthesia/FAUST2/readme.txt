Repeatability package for FAUST2
Nathalie Cauchi, July 2018.

Please run the main.m file within Matlab in the same folder containing FAUST2 folder. 
The script for the anaesthesia benchmark (main.m with a specific N and epislon value)  will output the results both as plots and will save them in the form of FAUST_Anes.mat.
For different time horizons and error bounds (epsilon), please run main(N,epsilon). 
In the report we have used:

(A) N = 1, epsilon = 0.2;

and

(B) N= 5, epsilon = 0.4;

In both cases, the synthesised policy is computed and is stored in the .mat file using a variable called 'OptimPol'
