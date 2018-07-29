function tree_output = eval_cartree(Data,RETree)
 
%Evaluates the tree output

tree_output = mx_eval_cartree(Data,RETree.nodeCutVar,RETree.nodeCutValue,RETree.childnode,RETree.nodelabel);