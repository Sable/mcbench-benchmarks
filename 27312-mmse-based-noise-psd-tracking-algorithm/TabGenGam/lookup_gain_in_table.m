function [gains]=lookup_gain_in_table(G,a_post,a_priori,a_post_range,a_priori_range,step);
% function [gains]=lookup_gain_in_table(G,a_post,a_priori,a_post_range,a_priori_range,step);
% This function selects the right gain value from the table G, given
% vectors with a priori and a posteriori SNRs
%
% INPUT variables:
% G: Matrix with gain values for speech DFT or magnitude estimation,
% evaluated at all combinations of a priori and a posteriori SNR in the
% input variables Rksi and Rgam. 
% 
%
% a_priori: Array of "a priori" SNR (SNRprior) values for which values
% have to be selected from the gain table   NOTE: The values must be in dBs.
% a_post: Array of "a posteriori" SNR (SNRpost) values for which values
% have to be selected from the gain table  NOTE: The values must be in dBs.
%
% a_post_range: The range of "a posteriori" SNR values
%
% a_priori_range: The range of "a priori" SNR values
%
% step: step is the stepsize in db's in the table
%
% OUTPUT variables:
% gains: Matrix with gain values that are selected from the gain table G
% 
%
% Copyright 2007: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 22-11-2007.




a_prioridb=round(10*log10(a_priori)/step)*step;
a_postdb=round(10*log10(a_post)/step)*step;
[Ia_post]=min(max(min(a_post_range),a_postdb), max(a_post_range));
Ia_post=Ia_post-min(a_post_range)+1;
Ia_post=Ia_post/step;
[Ia_priori]=min(max(min(a_priori_range),a_prioridb), max(a_priori_range));
Ia_priori=Ia_priori-min(a_priori_range)+1;
Ia_priori=Ia_priori/step;

gains=G(Ia_priori+(Ia_post-1)*length(G(:,1))); 


 