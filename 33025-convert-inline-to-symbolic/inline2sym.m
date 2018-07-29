%%This program converts an inline expression into a symbolic expression, so
%you can use it on many Matlab operators that inline expression dosen't
%work.
%
%Usage:
%      Inputs:          
%             fi=an inline function made with different names for each
%             variable
%           
%      Output:
%            f0=the same function fi, but converted into a symbolic function 
%
%Example:
%  
% Create an inline object that can't be simbolic differenciated
%      fi=inline('x^2+3*y-z^4','x','y','z')
%      f0=inline2sym(fi)
% Now the expresion can be differenciated
%      syms x;diff(f0,x)
%
%
%This function is written by :
%                             Héctor Corte
%                             Battery Research Laboratory
%                             University of Oviedo
%                             Department of Electrical, Computer, and Systems Engineering
%                             Campus de Viesques, Edificio Departamental 3 - Office 3.2.05
%                             PC: 33204, Gijón (Spain)
%                             Phone: (+34) 985 182 559
%                             Fax: (+34) 985 182 138
%                             Email: cortehector@uniovi.es
function f0=inline2sym(fi)

str=argnames(fi);
[fil,~]=size(str);
Zax=str{1};
eval(['syms ',str{1}])

if fil>1
    for m=2:fil
        eval(['Zax=[''',Zax,',',char(str{m}),'''];']);  
        eval(['syms ',str{m}])
    end 
end
eval(['f0=fi(',Zax,');']);
