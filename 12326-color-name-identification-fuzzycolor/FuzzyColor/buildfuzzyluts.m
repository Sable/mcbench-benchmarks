function FuzzyColorData = buildfuzzyluts(colorname)
% Does a visual experiment to establish binary luts for any color
% If colorname already exists in the existing color name dataset,
% then its lut will be replaced with the new one built here.
%
% buildfuzzyluts has you create a polygon using ginput and mouse
% clicks in each plane of a 3-d array of colors. When you are
% done with the current polygon, hit the enter key to terminate
% ginput. A new page of the color array will pop up, with the
% last polygon overlaid on it for reference.
%
% Any colors in the array that are inside the polygon will be set
% to true - to identify colors of that colorname. Remember, there
% are 52 pages in this 3-d array of colors, so you will need to
% establish 52 polygons. If there are no colors with the given
% colorname, then just hit the enter key.
%
% Once you are past the region of the array where you have found
% some colors in the array, but then have find no more in a slice,
% since the colorname region is assumed to be contiguous, I can
% stop requesting input on further slices, so I do.
%
% If you are satisfied with the new colorname lut, then execute
% the Matlab command 
%
% save FuzzyColorData FuzzyColorData
%
% to overwrite the old database. (Its not a bad idea to back up
% the old database, just in case you are unhappy with the result.)
% After you have saved the new database array, you must then
% execute the Matlab command
%
% clear functions
%
% This will reset the persistent variable in fuzzycolor to enable
% it to recognize your enhanced database.
%
% A good test of your new color name, 'cyan' for example, is
% 
% colors = sortrows(rand(100000,3));
% isc = fuzzycolor(colors,'cyan');
% displaycolorpatches(colors(isc>0.99,:))

% establish the fuzzy color struct
load FuzzyColorData

% build the factorial array of colors
[rnodes,gnodes,bnodes] = meshgrid(FuzzyColorData.rnodes, ...
   FuzzyColorData.gnodes,FuzzyColorData.bnodes);

% Is this a new color?
k = find(ismember(FuzzyColorData.colornames,colorname));
if isempty(k)
  ncolors = FuzzyColorData.ncolors + 1;
else
  ncolors = k;
end

% loop over each slice of these arrays.
n = length(FuzzyColorData.rnodes);
LUT = zeros(n,n,n);
cpoly0 = [];
for i = 1:n
  % build the red/green values for this slice
  RG = reshape([rnodes(:,:,i),gnodes(:,:,i)],[n*n,2]);
  
  % do the actual experiment for this slice
  bluelevel = FuzzyColorData.bnodes(i);
  
  close all
  figure
  title(['Colorname = ',colorname,' , Blue level = ',num2str(bluelevel)])
  xlabel 'Red'
  ylabel 'Green'
  
  % display the patches
  for j = 1:(n-1)
    for k = 1:(n-1)
      xp = [FuzzyColorData.rnodes(j);FuzzyColorData.rnodes(j); ...
            FuzzyColorData.rnodes(j+1);FuzzyColorData.rnodes(j+1)];
      yp = [FuzzyColorData.gnodes(k);FuzzyColorData.gnodes(k+1); ...
            FuzzyColorData.gnodes(k+1);FuzzyColorData.gnodes(k)];
      colorspec = [xp,yp,repmat(bluelevel,4,1)];
      colorspec = reshape(colorspec,[1,4,3]);
      patch(xp,yp,colorspec);
    end
  end
  
  % add the last polygon
  hold on
  if ~isempty(cpoly0)
    plot(cpoly(:,1),cpoly(:,2),'k-')
  end
  
  set(gcf,'renderer','zbuffer')
  
  % set the axes to just outside the [0,1]x[0,1] square
  axis([-.05,1.05,-.05,1.05])
  hold off
  
  % get a polygon that contains all colors of the given name.
  cpoly = ginput;
  
  % did we pass over the color in question?
  if isempty(cpoly) && ~isempty(cpoly0)
    break
  elseif ~isempty(cpoly)
    % make sure it is a complete polygon
    cpoly = [cpoly;cpoly(1,:)];
    
    cpoly0 = cpoly;
    
    % populate the lut from this polygon
    in = inpolygon(RG(:,1),RG(:,2),cpoly(:,1),cpoly(:,2));
    LUT(:,:,i) = reshape(double(in),[n,n,1]);
    
  end
  
end

% stuff the results back into the color struct
FuzzyColorData.ncolors = max(ncolors,FuzzyColorData.ncolors);
FuzzyColorData.colornames{ncolors} = colorname;
FuzzyColorData.colorlut{ncolors} = LUT;

% List the set of nodes that were flagged
k = find(LUT);
[rnodes(k),gnodes(k),bnodes(k)]

% All done. Display the set of patches identified
allcolors = [rnodes(:),gnodes(:),bnodes(:)];
displaycolorpatches(allcolors(LUT>=0.5,:))

end % end of mainline



