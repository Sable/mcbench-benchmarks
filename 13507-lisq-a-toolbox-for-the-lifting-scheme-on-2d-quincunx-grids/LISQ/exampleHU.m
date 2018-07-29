% An elaborate example.
% It demonstrates how (little) the vector of invariants based on 
% central moments depends on either rotation or similitude transforms.
% This example requires the Image Processing Toolbox.
%
disp('An elaborate example.');
disp('It demonstrates how (little) the vector of invariants based on ');
disp('central moments depends on either rotation or similitude transforms.');
disp('This example requires the Image Processing Toolbox.');
disp('FOR MORE INFORMATION:  help momentsupto3');
disp(' ');
disp('See also the report http://repository.cwi.nl:8888/cwi_repository/docs/IV/04/04178D.pdf');
disp('Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>');
disp(' (C) 1998-2006 Stichting CWI, Amsterdam, The Netherlands');
disp(' ');
%---INSERT THE IMAGE ----------------------------------------------------------
%
Orig=double(imread('mvine_maple08.jpg','jpg'));
%
%------------------------------------------------------------------------------
disp(' * The original image is loaded * ');
disp(' ');
printshop('original','Unrotated original', Orig, 3, 0, []);
%
[dummy1, dummy2, dummy3, dummy4, huvec] = momentsupto3(Orig);
disp([' Vector of invariants based on central moments ' num2str(huvec,'%+12.4e ')]);
disp(' ');
%
if exist('imrotate','file') ~= 2
  error(' Cannot find the Image Processing Toolbox ');
else
  d = 10;
  s = 360/d;
  disp(' * The image is rotated and dimensions might be changed too * ');
  for r = 1:(d-1)
    rs = r*s;
    Orig_rotated = imrotate(Orig, -rs, 'bilinear', 'loose');
    figtxt = ['rotated' num2str(rs)];
    rotatetxt = [ 'The original is rotated ' num2str(-rs) ' degrees'];
    disp(' ');
    printshop(figtxt, rotatetxt, Orig_rotated, 3, 0, []);
    [dummy1, dummy2, dummy3, dummy4, huvec] = momentsupto3(Orig_rotated);
    disp([' Vector of invariants based on central moments ' num2str(huvec,'%+12.4e ')]);
  end
end
%
