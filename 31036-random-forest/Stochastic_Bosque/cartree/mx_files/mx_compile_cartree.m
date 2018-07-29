%Compiles the necessary mex files for the CARTrees

present_path = cd;

mxD = which('mx_eval_cartree.c');
cd(mxD(1:end-17))

mex -O best_cut_node.cpp GBCR.cpp GBCP.cpp GBCC.cpp

mex mx_eval_cartree.c

cd(present_path)
