function printshop(figthis, figtxt, f, dops, dotiff, mask, fmin, fmax)
%------------------------------------------------------------------------------
%
% Creates and files an image of gridfunction f as desired.
%
%   figthis   name of picture to be
%   figtxt    title of picture 
%   f         gridfunction to be shown
%   dops      0 no action
%             1 show .epsc imagefile
%             2 show and file .epsc imagefile
%             3 show .eps imagefile
%             4 show and file .eps imagefile
%             5 show and file .pdf imagefile
%   dotiff    0 no action 
%             1 file .tif file in current directory
%             2 file .tif file in directory /ufs/$USER/tmp/
%               Nota Bene: this option only for Unix/Linux platforms and 
%                          dependent on the environment. Either do NOT use
%               this option or adapt it to your personal environment.
%   mask      gridfunction with values 0 or 1 to mask f, may be empty [].
%   fmin      (optional) enforced mimimum of f by scaling: black
%   fmax      (optional) enforced maximum of f by scaling: white
%
%
% Design and implementation by:
% Dr. Paul M. de Zeeuw <Paul.de.Zeeuw@cwi.nl>  http://homepages.cwi.nl/~pauldz/
% Last Revision: November 27, 2006.
%  2001-2003 Stichting CWI, Amsterdam
%------------------------------------------------------------------------------
%
disp([' printshop - processsing ' figthis ' entitled: ' figtxt]);
if nargin == 6
  fmini = min(min(f));
  fmaxi = max(max(f));
  disp([' printshop - minimum of f ' num2str(fmini) ...
                    ' maximum of f ' num2str(fmaxi)]);
elseif nargin == 8
  fmini = fmin;
  fmaxi = fmax;
  disp([' printshop - ENFORCED minimum of f ' num2str(fmini) ...
                    ' ENFORCED maximum of f ' num2str(fmaxi)]);  
else
  error(' printshop - number of arguments should be either 6 or 8 ')
end
%
if fmaxi == fmini
  fmaxi = fmini + max([ 1 abs(0.1*fmini)]);
  disp([' printshop - ENFORCED maximum of f ' num2str(fmaxi)]);
end
%
[n, m] = size(f);
disp([' printshop - dimensions f ' num2str(n) '  ' num2str(m)]);
clear n; clear m;
%
if dops  <=0
  disp(' printshop - shows no image nor writes postscript file ')
elseif dops  <=2
  if exist('imagesc','file') == 2
    if isempty(mask)
      fmasked = f;
    else
      if ~all(size(mask) == size(f))
        error(' printshop - dimensions of f and mask do not match ')
      end
      white = fmaxi;
      fmasked = mask .* f + white * (~mask);
      disp(' printshop - gridfunction f is masked ');
    end
%
    figure;
    imagesc(fmasked, [fmini fmaxi]);
    axis equal;
    axis tight;
    axis off;
    drawnow;
    if dops ==2
      disp(' printshop - writes postscript file ')
      print(gcf,'-depsc',figthis);
    else
      disp(' printshop - writes no postscript file ')
    end
    if ~isempty(figtxt)
      title(figtxt);
    end
  else
    disp(' printshop - WARNING cannot find procedure IMAGESC ')
  end
elseif dops  <=5
  if exist('imshow','file') == 2
    if isempty(mask)
      fmasked = f;
    else
      if ~all(size(mask) == size(f))
        error(' printshop - dimensions of f and mask do not match ')
      end
      white = fmaxi;
      fmasked = mask .* f + white * (~mask);
      disp(' printshop - gridfunction f is masked ');
    end
%
    figure;
    imshow(fmasked, [fmini fmaxi]);
    drawnow;
  else
%   disp(' printshop - WARNING cannot find procedure IMSHOW ')
    h=fmaxi-fmini;
    black=1;
    white=256;
    if h > 0
      sca = (white-black)/h;
    else
      sca = 1.0;
    end
    ftmp= sca*(f-fmini)+black;
    D=(ftmp>white);
    ftmp=white*D+(~D).*ftmp;
    D=(ftmp<black);
    ftmp=black*D+(~D).*ftmp;
    clear D;
    if ~isempty(mask)
      ftmp = mask .* ftmp + white * (~mask);
      disp(' printshop - gridfunction f is masked ');
    end
    map=gray(white);
    colormap(map);
%   disp(' printshop - WARNING new colormap has been set ')
    image(ftmp);
    axis equal;
    axis tight;
    axis off;
    drawnow;
    clear ftmp;
  end
  if dops ==4
    disp(' printshop - writes postscript file ')  
    print(gcf,'-deps',figthis);
  elseif dops ==5
    disp(' printshop - writes pdf file ')  
%   print(gcf,'-dpdf','-r0',figthis);
    print(gcf,'-dpdf',figthis);
%   print(gcf,'-dpdf','-r90',figthis);
  else
    disp(' printshop - writes neither pdf nor postscript file ')  
  end
  title(figtxt);  
else
  disp(' printshop - WARNING dops undefined ')
end
clear fmasked;
%
if dotiff <= 0
  disp(' printshop - writes no tif file ')
elseif dotiff <= 2
  if exist('imwrite','file') == 2
    if dotiff == 1
      direc='';  
    else     
      [fail, direc] = unix('echo -e "/ufs/$USER/tmp/\c"');
      if fail
        error(' printshop - cannot evaluate unix variable $USER ')
      end
      [fail,isnot]=unix('[ -d /ufs/$USER/tmp/ ]; echo -e "$?\c"');
      if fail || isnot ~= '0'
        error([' printshop - with active dotiff the directory ' direc ...
               ' should exist but does not '])
      else
        clear fail; clear isnot;
      end
    end    
    filen=[direc figthis];
%
    h=fmaxi-fmini;
    black=1;
    white=256;
    if h > 0
      sca = (white-black)/h;
    else
      sca = 1.0;
    end
    ftmp= sca*(f-fmini)+black;
    D=(ftmp>white);
    ftmp=white*D+(~D).*ftmp;
    D=(ftmp<black);
    ftmp=black*D+(~D).*ftmp;
    clear D;
    if ~isempty(mask)
      ftmp = mask .* ftmp + white * (~mask);
      disp(' printshop - gridfunction f is masked ');
    end
    disp([' printshop - writes tif file towards ' filen '.tif'])
%   tiffwrite(ftmp, gray(white), filen); OBSOLETE!
    imwrite(ftmp, gray(white), [filen '.tif'], 'tiff');
    clear ftmp;
  else
    disp(' printshop - WARNING cannot find procedure IMWRITE ')
  end
else
  disp(' printshop - WARNING dotiff undefined ')  
end
disp(' printshop - done ')
%------------------------------------------------------------------------------
