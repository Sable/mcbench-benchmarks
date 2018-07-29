function CloneFig(inFigNum,OutFigNum)
% this program copies a figure to another figure
% example: CloneFig(1,4) would copy Fig. 1 to Fig. 4
% Matt Fetterman, 2009
% pretty much taken from Matlab Technical solutions:
% http://www.mathworks.com/support/solutions/en/data/1-1UTBOL/?solution=1-1UTBOL
hf1=figure(inFigNum);
hf2=figure(OutFigNum);
clf;
compCopy(hf1,hf2);

function compCopy(op, np)
%COMPCOPY copies a figure object represented by "op" and its % descendants to another figure "np" preserving the same hierarchy.

ch = get(op, 'children');
if ~isempty(ch)
nh = copyobj(ch,np);
for k = 1:length(ch)
compCopy(ch(k),nh(k));
end
end;
return;