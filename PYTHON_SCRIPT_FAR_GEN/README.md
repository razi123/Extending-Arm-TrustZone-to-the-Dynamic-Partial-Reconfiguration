Run Create once using vivado 2019.1, 
I think the code will work with out any problem with 2018.3 also. 

https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_1/ug909-vivado-partial-reconfiguration.pdf
In the document look at page 102. It say that 2 CLBs that have a switch in the middle can be a pblock, 
also bram and the 5 clb together that has a switch in the middle can be one block. 
Same applies for DSP
