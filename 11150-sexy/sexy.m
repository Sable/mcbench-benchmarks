function sexy(s)
%SEXY   Display a symbolic expression in human readable form.
% SEXY(S) displays the symbolic expression S in a small figure window,
% using standard mathematical notation.
%
% Examples:
%   syms x t positive
%   f=taylor(cos(x));
%   sexy(f)
%   f=int(exp(-t)*t^(x-1),t,0,inf);
%   sexy(f)
%
% Required toolboxes: Symbolic Math
%
% See also ...\symbolic\pretty.

% Author: Naor Movshovitz
% May 2006

if ~isa(s,'sym')
    error('Argument must be of class ''sym''.')
end

S=['$',latex(s),'$'];
S=strrep(S,'&','& \quad');
S=strrep(S,'{\it','\mathrm{');
h=msgbox(S,'Sexy');
h1=get(h,'children');
h2=h1(1);
h3=get(h2,'children');
if isempty(h3)
    h2=h1(2); h3=get(h2,'children');
end
set(h3,'visible','off')
set(h3,'interpreter','latex')
set(h3,'string',S)
set(h3,'fontsize',12)
w=get(h3,'extent');
W=get(h,'position');
W(3)=max(w(3)+10,125);
W(4)=w(4)+40;
set(h,'position',W)
h4=h1(2);
if ~strcmp(get(h4,'tag'),'OKButton'), h4=h1(1); end
o=get(h4,'position');
o(1)=(W(3)-o(3))/2;
set(h4,'position',o)
set(h3,'visible','on')
