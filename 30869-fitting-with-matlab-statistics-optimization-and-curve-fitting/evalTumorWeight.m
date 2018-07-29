function yPred = evalTumorWeight(t , p)
%Copyright (c) 2011, The MathWorks, Inc.

persistent m1 dose var cs

% Load model information only once
if isempty(m1)
    
    sbioloadproject('Tumor_Growth.sbproj', 'm1')
    dose    = m1.Doses   ;
    var     = sbiovariant('Iteration Variant');
    cs      = getconfigset(m1) ; 
    sbioaccelerate(m1, cs , var , dose)
end

set(var, 'Content', ...
    {{ 'parameter' , 'L0'  , 'Value' , p(1) } , ...
    {  'parameter' , 'L1'  , 'Value' , p(2) } , ...
    {  'parameter' , 'k1'  , 'Value' , p(3) } , ...
    {  'parameter' , 'k2'  , 'Value' , p(4) }}) ;

data = sbiosimulate(m1, cs , var , dose) ;

% Get tumor weight at t (seconds)
data  = resample(data , t*24*3600)  ;

% Get total tumor weight
[~, yPred] = selectbyname(data, 'w') ;