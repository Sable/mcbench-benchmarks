function [varargout] = PLOT_3D_stl_patch(coordVERTICES,varargin)
% PLOT_3D_stl_patch  Plot an stl triangular mesh using patch
%==========================================================================
% FILENAME          PLOT_3D_stl_patch.m
% AUTHOR            Adam H. Aitkenhead
% INSTITUTION       The Christie NHS Foundation Trust
% CONTACT           adam.aitkenhead@physics.cr.man.ac.uk
% DATE              29th March 2010
% PURPOSE           Plot an stl triangular mesh using patch
%
% USAGE             PLOT_3D_stl_patch(coordVERTICES)
%           ..or..  PLOT_3D_stl_patch(coordVERTICES,coordNORMALS)
%           ..or..  [handlePATCH] = PLOT_3D_stl_patch(coordVERTICES,coordNORMALS)
%
%   coordVERTICES - An Nx3x3 array defining the vertex positions for
%                   each facet, with: 
%                      1 row for each facet
%                      3 cols for the x,y,z coordinates
%                      3 pages for the three vertices
%
%   coordNORMALS  - An Nx3 array defining the normal vectors for each
%                   facet, with:
%                      1 row for each facet
%                      3 cols for the x,y,z components
%
%   handlePATCH   - The handle to the patch object.
%==========================================================================

%==========================================================================
% VERSION  USER  CHANGES
% -------  ----  -------
% 100412   AHA   Original version
% 101130   AHA   Also plot the normals, if required.
%==========================================================================

%================================
% PREPARE THE DATA
%================================

xco = squeeze( coordVERTICES(:,1,:) )';
yco = squeeze( coordVERTICES(:,2,:) )';
zco = squeeze( coordVERTICES(:,3,:) )';

if nargin==2
  coordNORMALS = varargin{1};
end


colourPATCHedge = 'b';
colourPATCHface = 'c';
colourNORMALS   = 'r';

%================================
% PLOT THE FACETS
%================================

[hpat] = patch(xco,yco,zco,colourPATCHedge,'EdgeColor',colourPATCHedge,'FaceColor',colourPATCHface);
axis equal tight

%================================
% PLOT THE NORMALS
%================================

if nargin==2
  hold on
  
    for loopN = 1:size(coordNORMALS,1)
    
      costart = mean(coordVERTICES(loopN,:,:),3);
      coend = costart + coordNORMALS(loopN,:);
      plot3([costart(1),coend(1)],[costart(2),coend(2)],[costart(3),coend(3)],'r','LineWidth',2);
    
    end
  
  hold off
end

%================================
% PREPARE THE OUTPUT ARGUMENTS
%================================

if nargout == 1
  varargout(1) = {hpat};
end
