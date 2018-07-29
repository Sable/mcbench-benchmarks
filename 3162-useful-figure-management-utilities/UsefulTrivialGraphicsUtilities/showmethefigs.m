function showmethefigs(N)
%SHOWMETHEFIGS     Allow user to cycle between all figures by hitting any key
%
% INPUT: (optional)
%   N = number of times to cycle through
%     Default = 1
%      -1 - Effectively infinite loop. 
%           Break with ctrl-C (I know it ain't pretty)
%   N can also be a vector, specifying the figure numbers in
%    the order to be viewed

% Scott Hirsch
% shirsch@mathworks.com

figs=sort(get(0,'Children'));		%ordered list of figures

if nargin==0
   N=1;
end;
if length(N)>1
   figs=N;
   N=1;
elseif N<0
   N=99999;
end;

   
for jj=1:N
   for ii=1:length(figs)
      if ishandle(figs(ii))
      figure(figs(ii))
      pause
      end;
   end
end

