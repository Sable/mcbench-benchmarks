% Small technical example.
% Shows how to call for the computation of central moments and invariants.
%
disp('Small technical example.');
disp('Shows how to call for the computation of central moments and invariants.');
disp('FOR MORE INFORMATION:  help momentsupto3');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---INSERT YOUR IMAGE HERE-----------------------------------------------------
if exist('imread','file') == 2
  Orig = double(imread('zenithgray.TIF','tiff'));
else
  load zenithgray; Orig = zenithgray; clear zenithgray;
end
%
%------------------------------------------------------------------------------
[mass, mus, orthos, sims, simorthos] = momentsupto3(Orig);
disp([' Mass ' num2str(mass,'%+12.4e')]);
disp(' 2nd & 3rd order central moments ');
disp(num2str(mus,'%+12.4e'));
disp(' Invariants w.r.t. orthogonal transforms ');
disp(num2str(orthos,'%+12.4e'));
disp(' Invariants w.r.t. similitude transforms ');
disp(num2str(sims,'%+12.4e'));
disp(' Invariants w.r.t. both similitude and orthogonal transforms ');
disp(num2str(simorthos,'%+12.4e'));
