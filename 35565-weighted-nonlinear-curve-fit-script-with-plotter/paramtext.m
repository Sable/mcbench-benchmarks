% function [parameters] = paramtext(fitstr,c,cerr,c2doF,strings)
%
% fitstr:     Ueberschrift der Fitdaten.
% c:          Liste der Parameter.
% cerr:       Unsicherheiten der Parameter.
% c2doF:      Reduziertes Chi^2.
% strings:    Evtl. Namen der Parameter.
%
% parameters: String, der die Ausgabe so enthaelt, wie ich sie gerne haette.         

function [parameters] = paramtext(fitstr,c,cerr,nr,c2doF,Q,strings)

  n = length(c);                                % Anzahl der Parameter.
  if nargin<7,                                  % Test, ob Namen der Param. angegeben.
     strings = cell(n,1);
     for i=1:n,
	   strings(i) = cellstr(sprintf('c_{%d}',i-1));
     end
  end;

nr = floor(log10(abs(cerr)))-nr+1;
clog = floor(log10(abs(c)));
cprint    = abs(round(c./(10.^(nr)))./10.^(-nr+clog));


for i=1:n
    if floor(log10(cprint(i)))~=0 && cprint(i)~=0
    cprint(i)=cprint(i)/10^(floor(log10(cprint(i))));
    clog(i)=clog(i)+floor(log10(cprint(i)));    
    end
end

cerrprint = round(cerr./(10.^(nr)))./10.^(-nr+clog);

  bracketl = num2str(zeros(n,1));                 % Reservieren.
  signum   = num2str(zeros(n,1));
  bracketr = num2str(zeros(n,1));
  exponent = cell(n,1);

  
  for i = 1:n,                                    % Never touch a running system!
     if c(i)<0,
        bracketl(i) = '(';
	    signum(i)   = '-';
     else
        bracketl(i) = ' ';
        signum(i)   = '(';
     end;
     if clog(i)~=0,
	    bracketr(i) = ')';
        if clog(i)==1,
	       exponent(i) = cellstr(' $\times$ 10');
        else
                exponent(i) = cellstr(sprintf(' $\\times$ $10^{%d}$',clog(i)));
        end;
     else
        bracketl(i) = ' ';
        if signum(i)   == '(',
            signum(i)   = ' ';
        end
	    bracketr(i) = ' ';
        exponent(i) = cellstr(' ');
     end
  end
  for i=1:n
      if -nr(i)+clog(i)>0
          nrstr{i}=num2str(-nr(i)+clog(i));
      else
          nrstr{i}=num2str(0);
      end
  end
  if ischar(fitstr)

      lfitstr=1;
  elseif iscell(fitstr)
      lfitstr=length(fitstr);
  elseif isempty(fitstr)
      lfitstr=0;
  end

  parameters = cell(1,n+3+lfitstr);                     % Reservieren.

  if ischar(fitstr)
      parameters(1)   = cellstr(fitstr);            % Ueberschrift.
  elseif iscell(fitstr)

      parameters(1:lfitstr)=fitstr;

  end

  for i=1:n,
      parameters(i+lfitstr) = strcat(strings(i), sprintf([' = ' bracketl(i) signum(i) '%1.',nrstr{i},'f $\\pm$ %1.',nrstr{i},'f'],[cprint(i),cerrprint(i)]), bracketr(i), exponent(i));
  end

  parameters(n+1+lfitstr) = cellstr('');
  parameters(n+2+lfitstr) = cellstr(['$\chi^2$/doF' sprintf('= %0.2f',c2doF)]); % Red. Chi^2
  parameters(n+3+lfitstr) = cellstr(['p' sprintf(' = %0.2f',Q)]); 		            % Prob.

end
