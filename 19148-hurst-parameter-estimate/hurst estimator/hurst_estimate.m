function H = hurst_estimate(sequence,method,isplot,opt)
%
% 'hurst_estimate' estimate the hurst parameter of a given sequence with
%     an appointed method. The algorithms of the methods can be found in
%     Murad's Taqqu, Vadim Teverovsky and Walter Willinger's paper
%     "Estimators for long-range dependence: an empirical study" or other
%     related papers.
% Inputs:
%     sequence: the input sequence for estimate
%     method: the name of a function which used to estimate the hurst
%             parameter of the sequence,e.g.
%               'aggvar': use aggvar function to estimate.
%               'RS': use RS function to estimate.
%               'per': use per function to estimate.
%     isplot: whether display the plot. without a plot if isplot equal to 0
%     opt: a optional parameter for some methods
% Outputs:
%     H: the estimated hurst coeffeient of the input sequence
% Examples:
%     H = hurst_estimate('peng',sequence,1);
%

%  Author: Chu Chen 
%  Version 1.0,  03/10/2008
%  chen-chu@163.com
%

if nargin == 2
    isplot = 0;
    H = feval(method,sequence,isplot);
elseif nargin == 3
    H = feval(method,sequence,isplot);
elseif nargin == 4
    H = feval(method,sequence,isplot,opt);
end