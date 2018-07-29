function boundaries=EWT_Boundaries_Completion(boundaries,NT)

%======================================================================
% function boundaries=EWT_Boundaries_Completion(boundaries,NT)
%
% This function permits to complete the boundaries vector to get a 
% total of NT boundaries by equally splitting the last band (highest
% frequencies)
%
% Inputs:
%   -boundaries: the boundaries vector you want to complete
%   -NT: the total number of boundaries wanted
%
% Output:
%   -boundaries: the completed boundaries vector
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%======================================================================

Nd=NT-length(boundaries);
deltaw=(pi-boundaries(end))/(Nd+1);
for k=1:Nd
   boundaries = [boundaries boundaries(end)+deltaw];
end