function H=prh(H)
%function H=prh(H)
%
% sets the current figure to print on full page in LANDSCAPE mode.
%
% By Michael Wu  --  waftingpetal@yahoo.com (Oct 2001)
%
% ====================

if ~exist('H','var');
  H = gcf;
end;

papMarg=0.1;
set(H,'PaperOrientation','landscape','PaperPosition',[0+papMarg, 0+papMarg, 11-2*papMarg, 8.5-2*papMarg]);


