function [roi, im] = mmROI

% 1) Goal: Interactively process MULTIPLE images with MULTIPLE ROIs
% (so-called mmROI), which returns ROI mean, std, min, max, median, area
% and center(X,Y), and plots the mean/std values along the image series. 
%
% 2) Usage: [roi, im] = mmROI; (please don't forget to add a semicolon ";"
% at the end of this command. Otherwise, all image data will be showing on
% screen!) 
%    a) The statistic data are in roi structures, which may be save into a
%       text file (optional). If you want to see the details, you may type,
%       for example, roi.mean to show all mean values; roi.mean(1, 1, 1)
%       to display the mean value of the 1st image, the 1st ROI and the red
%       color; roi.std(3, 1, :) to show std values of all image 1, the 1st
%       ROI and the blue color, etc.
%    b) The image data are in a stack (im). You may use immovie(im) to play
%       a movie or montage(im) to show all images in one figure. 
%  
% 3) Limitation: all images MUST have exactly identical size. Otherwise, an
% error will take place and the program will be terminated. The reason is
% that all image data were loaded into a stack matrix, im(:,:,:,imNumber). 
% 
% 4) This can be treated as an upgraded version of previous multiple ROI
% program for a single image (mathworks file excahnge ID: 4462). The most
% important feature of this new mmROI is that it permits to open multiple
% images and to process multiple ROIs interactively. I believe that it is
% much more valuable to those who are interested in studying the dynamic
% phenomenon via the image techniques. 
% 
% 5) The multiple file opening is based on javax.swing.JFileChooser, so
% this mmROI program should work for matlab with jave version 1.3.1 or
% newer (although it was created on Matlab, v6.5.1, R13SP1). If it dose not
% work for an older version of matlab, you may download "uigetfiles.dll"
% (mathworks file exchange ID: 331) into your matlab directory, and
% substitute those codes in charge of file opening as stated in the
% program.
% 
% 8) An input dialog box will pop up, asking you to input the total number
% of ROIs (default value 1), and to select a working image (Figure No. XX)
% in which you are going to draw your ROIs (default is set to the 1st
% image). These ROIs will be applied to all images opened. Some users may
% want to draw different ROIS in each images, you may easily modify the
% program by yourself (If you need help, you may contact me). 
%
% 7) ROI selection is based upon ROIPOLY, therefore, image process toolbox
% is needed. Use normal button clicks to add vertices to the polygon.
% Pressing <BACKSPACE> or <DELETE> removes the previously selected vertex.
% A shift-click, right-click, or double-click adds a final vertex to the
% selection and then starts the fill; pressing <RETURN> finishes the
% selection without adding a vertex. For more details, please see HELP
% ROIPOLY.
%
% 8) ROI statistic data were calculated by using IMPIXEL, please see HELP
% IMPIXEL if necessary. If you don't have IMPIXEL in your image process
% toolbox, you may modified the corresponding codes according to my
% previous program ROI.m (Mathwork file exchange ID: 4462).
% 
% 9) ROI coordinates were automatically saved into a text file in your
% current directory ("roiXY.txt"). I think this maybe be needed if you want
% to process further the images with exactly identical ROI polygon, such as
% poly2mask, etc. If you want to keep it, please find roiXY.txt, and backup
% before performing any new mmROI. Otherwise, it will be overwriten. 
% 
% 10) The ROI mean/std values were plotted along the image series. Each ROI
% has a new plot with three lines that are corresponding to red, green and
% blue color, respectively. 
%  
% Shanrong Zhang
% Department of Radiology
% University of Washington
%
% email: zhangs@u.washington.edu
%
% update info (04/15/2005): fix bug so that it is usable on Version R14SP2

% Multiple file selections based upon javax.swing.JFileChooser 
import com.mathworks.mwswing.MJFileChooser;
import com.mathworks.toolbox.images.ImformatsFileFilter;  

filechooser = javax.swing.JFileChooser(pwd);
filechooser.setMultiSelectionEnabled(true);
filechooser.setFileSelectionMode(filechooser.FILES_ONLY);

% Parse formats from IMFORMATS 
formats = imformats;
nformats = length(formats);
desc = cell(nformats,1);
[desc{:}] = deal(formats.description);
ext = cell(nformats,1);
[ext{:}] = deal(formats.ext);

% Create a filter that includes all extensions
ext_all = cell(0);
for i = 1:nformats
    ext_i = ext{i};
    ext_all(end+1: end+numel(ext_i)) = ext_i(:);
end

[ext{end+1,1}] = ext_all;
[desc{end+1,1}] = 'All image files'; 

% Make a vector of String arrays
extVector = java.util.Vector(nformats);
for i = 1:nformats+1
    extVector.add(i-1,ext{i})
end

% Push formats into ImformatsFileFilter so instances of 
% ImformatsFileFilter will be based on IMFORMATS.
ImformatsFileFilter.initializeFormats(nformats,desc,extVector);

% Create all_images_filter
all_images_filter = ... 
ImformatsFileFilter(ImformatsFileFilter.ACCEPT_ALL_IMFORMATS);
filechooser.addChoosableFileFilter(all_images_filter); 

% Add one ChoosableFileFilter for each format in IMFORMATS
for i = 1:nformats
    filechooser.addChoosableFileFilter(ImformatsFileFilter(i-1))
end

% Put accept all files at end
accept_all_filter = filechooser.getAcceptAllFileFilter;
filechooser.removeChoosableFileFilter(accept_all_filter);
filechooser.addChoosableFileFilter(accept_all_filter);

% Make default be all_images_filter
filechooser.setFileFilter(all_images_filter);
returnVal = filechooser.showOpenDialog(com.mathworks.mwswing.MJFrame);


if (returnVal == MJFileChooser.APPROVE_OPTION)
    pathname = [char(filechooser.getCurrentDirectory.getPath), ...
                java.io.File.separatorChar];
    selectedfiles = filechooser.getSelectedFiles;
    imNumber = size(selectedfiles);
    for n = 1:imNumber
        filenames(n) = selectedfiles(n).getName;
    end
    filenames = char(filenames);
else
    pathname = pwd;
    filenames = 0;
end

if filenames == 0;
    return;
end

% If you have downloaded "uigetfiles.m" (witten by me based on java
% interface) in your directory, the above codes can be substituted by only
% one line: 
%
% [filenames, pathname] = uigetfiles;
%
% Alternatively, if you had downloaded "uigetfiles.dll and uigtefiles.m" (MEX written in C
% language), you may substitute the above codes by one line: 
%
% [filenames, pathname] = uigetfiles('*.*, 'Please Select image files');
% filenames = char(filenames); % to converte cell array into char array

for imIndex = 1:imNumber
    im(:,:,:,imIndex) = imread([pathname, filenames(imIndex,:)]);
    figure; 
    imHandle = imshow(im(:,:,:,imIndex));
    title(filenames(imIndex,:));
    axis image;
    axis off;
end

prompt = {'Total ROI Number:', 'Perform ROI selection on which image (Figure No. XX):'};
dlg_title = 'Inputs for mmROI function';
num_lines = 1;
def = {'1','1'};
inputs  = str2num(char(inputdlg(prompt, dlg_title, num_lines, def)));

roiNumber = inputs(1);
workingImage = inputs(2);

% generate a jet colormap according to roiNumber
clrMap = jet(roiNumber);
rndprm = randperm(roiNumber);

hold on;

tfid = fopen('roiXY.txt', 'w+');
   
for roiIndex = 1:roiNumber
    figure(workingImage);
    [x, y, BW, xi, yi] = roipoly;
    xmingrid = max(x(1), floor(min(xi)));
    xmaxgrid = min(x(2),  ceil(max(xi)));
    ymingrid = max(y(1), floor(min(yi)));
    ymaxgrid = min(y(2),  ceil(max(yi)));
    xgrid = xmingrid : xmaxgrid;
    ygrid = ymingrid : ymaxgrid;
    [X, Y] = meshgrid(xgrid, ygrid);
    inPolygon = inpolygon(X, Y, xi, yi);
    Xin = X(inPolygon);
    Yin = Y(inPolygon);
    
    % Save each roi coordinates into a text file "roiXY.txt", so that one
    % can easily use "poly2mask" for further regional image process with
    % exactly identical ROIs created here. 
    fprintf(tfid, 'ROI "%s":\n', num2str(roiIndex));
    fprintf(tfid, 'Xi = \t');
    fprintf(tfid, '%10.2f\t', xi);
    fprintf(tfid, '\n');
    fprintf(tfid, 'Yi = \t');
    fprintf(tfid, '%10.2f\t', yi);
    fprintf(tfid, '\n');
    
    roi.area(:,roiIndex) = polyarea(xi,yi);
    roi.center(:,roiIndex) = [mean(Xin(:)), mean(Yin(:))];

    for imIndex = 1:imNumber
        roi.mean(:,roiIndex,imIndex)   =    mean(impixel(x,y,im(:,:,:,imIndex),xi,yi));
        roi.std(:,roiIndex,imIndex)    =     std(impixel(x,y,im(:,:,:,imIndex),xi,yi));
        roi.min(:,roiIndex,imIndex)    =     min(impixel(x,y,im(:,:,:,imIndex),xi,yi));
        roi.max(:,roiIndex,imIndex)    =     max(impixel(x,y,im(:,:,:,imIndex),xi,yi));
        roi.median(:,roiIndex,imIndex) =  median(impixel(x,y,im(:,:,:,imIndex),xi,yi));
        
        figure(imIndex);
        hold on; 
        plot(xi,yi,'Color',clrMap(rndprm(roiIndex), :),'LineWidth',1);
        text(roi.center(1,roiIndex), roi.center(2,roiIndex), num2str(roiIndex),...
             'Color', clrMap(rndprm(roiIndex), :), 'FontWeight','Bold');
    end
end

fclose(tfid);

% Save ROIs to a file (optional)
SaveOutput = questdlg('Do you want to save ROI outputs ?');
switch SaveOutput
    case 'Yes'
        [outFilename, outPathname] = uiputfile('*.txt', 'Please select an output file');
        if outFilename == 0
            disp('  Cancel by user !');
        else
            ofid = fopen([outPathname outFilename], 'w+');
            fprintf(ofid, '%-20s\t %-25s\n', 'Date\time = ', datestr(now));
            fprintf(ofid, '\n');        
            fprintf(ofid, 'Images used in this ROI process: \n');
            fprintf(ofid, '\t"%s"\n', pathname(1,:));
            fprintf(ofid, '     Index\t\tfilenames \n');
            for imIndex = 1:1:imNumber
                fprintf(ofid, '%10.0f\t\t', imIndex);
                fprintf(ofid, '%-100s\n', filenames(imIndex,:));
            end
        end
    otherwise
        outFilename = 0;
end

warning off MATLAB:colon:operandsNotRealScalar;
imIndex = 1:imNumber; 

% Plot of mean/std values along the image series. Each ROI plots as a new
% figure with three lines of red, green and blue, respectively.
for roiIndex=1:roiNumber
    redMean     = reshape(roi.mean(1,roiIndex,:),   [1, imNumber]);
    redStd      = reshape(roi.std(1,roiIndex,:),    [1, imNumber]);
    redMin      = reshape(roi.min(1,roiIndex,:),    [1, imNumber]);
    redMax      = reshape(roi.max(1,roiIndex,:),    [1, imNumber]);
    redMedian   = reshape(roi.median(1,roiIndex,:), [1, imNumber]);
    
    greenMean   = reshape(roi.mean(2,roiIndex,:),   [1, imNumber]);
    greenStd    = reshape(roi.std(2,roiIndex,:),    [1, imNumber]);
    greenMin    = reshape(roi.min(2,roiIndex,:),    [1, imNumber]);
    greenMax    = reshape(roi.max(2,roiIndex,:),    [1, imNumber]);
    greenMedian = reshape(roi.median(2,roiIndex,:), [1, imNumber]);
    
    blueMean    = reshape(roi.mean(3,roiIndex,:),   [1, imNumber]);
    blueStd     = reshape(roi.std(3,roiIndex,:),    [1, imNumber]);
    blueMin     = reshape(roi.min(3,roiIndex,:),    [1, imNumber]);
    blueMax     = reshape(roi.max(3,roiIndex,:),    [1, imNumber]);
    blueMedian  = reshape(roi.median(3,roiIndex,:), [1, imNumber]);
    
    figure;
    title(sprintf('MEAN/STD plot of ROI "%s" along the image series', num2str(roiIndex)));
    xlabel('The image Series');
    ylabel('Mean/Std of ROI');
    hold on;
    errorbar(  redMean,   redStd, '-or');
    errorbar(greenMean, greenStd, '-sg');
    errorbar( blueMean,  blueStd, '-db');

    % write ROI statistics into file (optional)
    if outFilename ~= 0
        fprintf(ofid, '\n');        
        fprintf(ofid, 'ROI "%s" statistic data: \n\n', num2str(roiIndex));
        
        fprintf(ofid, '%20s\t', 'ROI Area = ');
        fprintf(ofid, '%10.2f\t', roi.area(:,roiIndex));
        fprintf(ofid, '\n');        
        
        fprintf(ofid, '%20s\t', 'ROI center (X,Y) = ');
        fprintf(ofid, '%10.2f\t', roi.center(:,roiIndex));
        fprintf(ofid, '\n\n');        
                
        fprintf(ofid, '%20s\t', 'Image Index = ');
        fprintf(ofid, '%10.0f\t', imIndex);
        fprintf(ofid, '\n\n');
        
        fprintf(ofid, '%20s\t', 'redMean = ');
        fprintf(ofid, '%10.2f\t', redMean);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'greenMean = ');
        fprintf(ofid, '%10.2f\t', greenMean);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'blueMean = ');
        fprintf(ofid, '%10.2f\t', blueMean);
        fprintf(ofid, '\n\n');
        
        fprintf(ofid, '%20s\t', 'redStd = ');
        fprintf(ofid, '%10.2f\t', redStd);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'greenStd = ');
        fprintf(ofid, '%10.2f\t', greenStd);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'blueStd = ');
        fprintf(ofid, '%10.2f\t', blueStd);
        fprintf(ofid, '\n\n');        
        
        fprintf(ofid, '%20s\t', 'redMin = ');
        fprintf(ofid, '%10.2f\t', redMin);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'greenMin = ');
        fprintf(ofid, '%10.2f\t', greenMin);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'blueMin = ');
        fprintf(ofid, '%10.2f\t', blueMin);
        fprintf(ofid, '\n\n');
        
        fprintf(ofid, '%20s\t', 'redMax = ');
        fprintf(ofid, '%10.2f\t', redMax);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'greenMax = ');
        fprintf(ofid, '%10.2f\t', greenMax);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'blueMax = ');
        fprintf(ofid, '%10.2f\t', blueMax);
        fprintf(ofid, '\n\n');
        
        fprintf(ofid, '%20s\t', 'redMedian = ');
        fprintf(ofid, '%10.2f\t', redMedian);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'greenMedian = ');
        fprintf(ofid, '%10.2f\t', greenMedian);
        fprintf(ofid, '\n');
        
        fprintf(ofid, '%20s\t', 'blueMedian = ');
        fprintf(ofid, '%10.2f\t', blueMedian);
        fprintf(ofid, '\n\n');
    end  
end

if outFilename ~= 0
    disp(sprintf('Done! ROI statistic data were output to "%s",', outFilename));
    disp('ROI coordinates (X,Y) were saved in "roiXY.txt",');
    disp('but the images were not saved yet!');
    fclose(ofid);
else
    disp('Done, ROI coordinates (X,Y) were saved in "roiXY.txt",');
    disp('but their statistics and the images were not saved!');
end

% end of code
