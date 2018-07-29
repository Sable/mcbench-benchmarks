function eqcheck(sinp)

%   Equation Check, Equation Validator
%   By Siamak Faridani, Oct 28, 2006
%   faridani@gmail.com
%   for more info goto http://www.pitchup.com/eqcheck/


%function eqcheck gets a string and shows that as a pretty function
%Example
%     eqcheck('int(tan(x)+2*cos(x)/log(x)+sqrt(5*x),x=-infinity..infinity)');
% can be used for validation of the equations

%%Acknowledgments
%some parts of the code were taken from 'sexy'
%http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=11150&objectType=file
%also the idea is from
% http://www.mapleprimes.com/blog/lehalle/maple---matlab-graphical-interface

mytempstring=['latex(' sinp ')'];
a=['$$' maple(mytempstring) '$$'];


%Taken from the code 'sexy' by Naor Movshovitz
S=a;
S=strrep(S,'&','& \quad');
S=strrep(S,'{\it','\mathrm{');
h=msgbox(S,'Equation Check...');
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



