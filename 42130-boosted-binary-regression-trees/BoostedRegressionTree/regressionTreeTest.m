function [ output ] = regressionTreeTest( input, Tree )
%REGRESSIONTREETEST Summary of this function goes here
%   Detailed explanation goes here
    
    i=1;
    while true
        if input( Tree(i).idx ) < Tree(i).thr
            i = Tree(i).left;
        else
            i = Tree(i).right;
        end
        
        if Tree(i).type == 1
            output = Tree(i).output;
            break;
        end       
    end
end

