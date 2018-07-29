%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QualityGuidedUnwrap2D implements 2D quality guided path following phase
% unwrapping algorithm.
%
% Technique adapted from:
% D. C. Ghiglia and M. D. Pritt, Two-Dimensional Phase Unwrapping:
% Theory, Algorithms and Software. New York: Wiley-Interscience, 1998.
% 
% Inputs: 1. Complex image in .mat double format
%         2. Binary mask (optional)          
% Outputs: 1. Unwrapped phase image
%          2. Phase quality map
%
% This code can easily be extended for 3D phase unwrapping.
% Posted by Bruce Spottiswoode on 22 December 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% REPLACE WITH YOUR IMAGES
load 'IM.mat'                               %Load complex image
im_mask=ones(size(IM));                     %Mask (if applicable)
%%

im_mag=abs(IM);                             %Magnitude image
im_phase=angle(IM);                         %Phase image
im_unwrapped=zeros(size(IM));               %Zero starting matrix for unwrapped phase
adjoin=zeros(size(IM));                     %Zero starting matrix for adjoin matrix
unwrapped_binary=zeros(size(IM));           %Binary image to mark unwrapped pixels

%% Calculate phase quality map
im_phase_quality=PhaseDerivativeVariance(im_phase);   

%% Identify starting seed point on a phase quality map
minp=im_phase_quality(2:end-1, 2:end-1); minp=min(minp(:));
maxp=im_phase_quality(2:end-1, 2:end-1); maxp=max(maxp(:));
figure; imagesc(im_phase_quality,[minp maxp]), colormap(gray), axis square, axis off; title('Phase quality map'); 
uiwait(msgbox('Select known true phase reference phase point. Black = high quality phase; white = low quality phase.','Phase reference point','modal'));
[xpoint,ypoint] = ginput(1);                %Select starting point for the guided floodfill algorithm

%% Unwrap
colref=round(xpoint); rowref=round(ypoint);
im_unwrapped(rowref,colref)=im_phase(rowref,colref);                        %Save the unwrapped values
unwrapped_binary(rowref,colref,1)=1;
if im_mask(rowref-1, colref, 1)==1 adjoin(rowref-1, colref, 1)=1; end       %Mark the pixels adjoining the selected point
if im_mask(rowref+1, colref, 1)==1 adjoin(rowref+1, colref, 1)=1; end
if im_mask(rowref, colref-1, 1)==1 adjoin(rowref, colref-1, 1)=1; end
if im_mask(rowref, colref+1, 1)==1 adjoin(rowref, colref+1, 1)=1; end
im_unwrapped=GuidedFloodFill(im_phase, im_unwrapped, unwrapped_binary, im_phase_quality, adjoin, im_mask);    %Unwrap

figure; imagesc(im_mag), colormap(gray), axis square, axis off; title('Magnitude image'); 
figure; imagesc(im_phase), colormap(gray), axis square, axis off; title('Wrapped phase'); 
figure; imagesc(im_unwrapped), colormap(gray), axis square, axis off; title('Unwrapped phase'); 
