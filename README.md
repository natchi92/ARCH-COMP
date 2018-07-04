This repository contains the participant files for the ARCH Verification Competition: https://cps-vo.org/group/ARCH/FriendlyCompetition.

The repository is organized by the year of the competition, followed by categories, followed by specific tools participating in a given category. For example, in the affine category (AFF) for 2017, one may find the execution instructions and results for the HyDRA tool at 2017\AFF\hydra\ (https://gitlab.com/goranf/ARCH-COMP/tree/master/2017/AFF/hydra).

Repeatability Evaluation:

To ease repeatability and facilitate the exchange of benchmarks for the competition, participants should submit their repeatability evaluation packages as pull requests to this repository.

More details on a forking repository management workflow are here: https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow

The basic process to submit your repeatability evaluation benchmarks and executables is:

1. Fork this repository to your own gitlab account: https://gitlab.com/goranf/ARCH-COMP.git
2. Commit changes to your fork (if you already made changes to the main repository line, just copy/paste the source files in the new fork and commit them)
3. Push changes to your fork
4. Issue pull request, we will review it and then approve if it looks good

As there may be some concerns regarding large files (e.g., if you're using a virtual machine for your repeatability package), licenses for your tools or dependencies, compiling your tool if it has external libraries, etc., please contact the evaluation chair Taylor Johnson with questions: http://www.taylortjohnson.com/?m=contact

Eventually, we hope this process will facilitate being able to clone this repository, then executing a single script to install all tools, then another to execute everything against all benchmarks to reproduce the competition results.