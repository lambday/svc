Support Vector Clustering (SVC) toolbox
=======================================
This SVC toolbox was written by Dr. Daewon Lee under supervision by Prof. Jaewook Lee. The toolbox is implemented by the Matlab and based on the statistical pattern recognition toolbox (stprtool) in parts of kernel computation and efficient QP solving. At first, you should add the stprtool in your Matlab path. Our SVC toolbox includes the complete graph (CG) based (original SVC), the proximity graph based, and also dynamical system based methods.

Download from
=============
https://sites.google.com/site/daewonlee/research/svctoolbox

Installation instructions for GNU Octave on GNU/Linux platform
==============================================================
This version includes Statistical Pattern Recognition Toolbox (stprtool) Version 2.12, 12 within it downloaded from [here](http://cmp.felk.cvut.cz/cmp/software/stprtool/dwstprtool.html).

To install SVC with STPRTool

1. Add strptool to path:
-----------------------
Edit `~/.octaverc` and add `addpath(genpath("path/to/strptool/"));`.
2. Generate mexfiles for strptool
---------------------------------
From svc root directory run `./install.sh`

