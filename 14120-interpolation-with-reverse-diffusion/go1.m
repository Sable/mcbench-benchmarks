% Interpolation with reverse diffusion. Example
%
% run this script and select one or multiple images. Results are saved
% in tif 16 bits format.
%
% Olivier Salavado, Case Western Reserve University, Feb-07
% From paper:
% Olivier  Salvado, Claudia M. Hillenbrand, and David L. Wilson, 
% “Partial Volume Reduction by Interpolation with Reverse Diffusion,” 
% International Journal of Biomedical Imaging, 
% vol. 2006, Article ID 92092, 13 pages, 2006. doi:10.1155/IJBI/2006/92092
%
% available online at: 
% http://www.hindawi.com/GetArticle.aspx?doi=10.1155/IJBI/2006/92092&e=cta




clf
clear all


%% get the data form dicom file
[fname,pname] = uigetfiles('*.*','Select files to be corrected')


%% get the options
option = PVcorr2D; 
option.tol = 0.001;
p.ordmax = 5;
p.ordmin = 4;
Ratio = 2;
Scale = 1;
option

%% loop over all the files and correct them
tic
for k=1:length(fname),
    
    % --- read the image
    filename = fname(k);
    filename = filename{1};
    
    % --- get the image i n the sequence
    I = single(dicomread([pname filename]));
    
    % --- scale image
    Imax = max(I(:));
    Imin = min(I(:));
    Is = (I-Imin)/(Imax-Imin);
    imshow(Is,[0 1])
        
    % --- interpolate
    [Ic] = PVcorr2D(Is,Ratio,option);
    
    % --- restore scaling
    Ir = Ic*(Imax-Imin) + Imin;
    
    % --- display
    subplot(121)
    imagesc(I), title('original'),axis image
    subplot(122)
    imagesc(Ir), title('interpolated x2'),axis image
    drawnow
    
    % --- save images
    imwrite(uint16(Ir),[pname 'c_' filename(1:end-3) 'tif'],'tif')
end
toc
