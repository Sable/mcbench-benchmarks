function blendMaskCell=drawBlenMaskCellArray(maskDim, isSavemask)
% A little service function written to allow the user to draw himself a bank of cutom
% masks, for future use, instead of drawing one each time "imagesFusion" is utilised.
% Especally handy if you iwsh to apply a custom regions to several image (reepating same
% experiment), or applying it to video's frames. 
% No documentation here, hoping you'll manage this one.
prevMaskMat=zeros(maskDim, 'uint8');

figH=figure;
imshow(prevMaskMat, []);
blendMaskCell={};
anotherROI='Another ROI';
iROI=0;
while strcmpi(anotherROI, 'Another ROI')
    text(0.5, 0.9, {'Select ROI by left clicking mouse', 'and moving the pointer around.',...
        'Release to finish.'}, 'FontSize', 16, 'Color', [1,0,0],...
        'HorizontalAlignment', 'center', 'Units', 'normalized');
    
    imfreehandH=imfreehand;
    currBlendMask=createMask(imfreehandH);
    iROI=iROI+1;
    prevMaskMat(currBlendMask)=iROI;
    blendMaskCell=cat(2, blendMaskCell, currBlendMask);
    delete(imfreehandH);
    imshow(prevMaskMat, []);
    
    anotherROI = questdlg({'Need to mark additional ROI? ',...
        'Press ''Another ROI'', to mark additional ROI.',...
        'Press ''Finish'' to finish drawing masks.'},...
        'ROI''s generation',...
        'Another ROI', 'Finish','Finish');
end
userSelection='No';
if exist('isSavemask', 'var')~=1
    userSelection = questdlg('Would you like to save the mask cell array?',...
       'Saving ROI''s', 'Yes', 'No', 'Yes');
elseif isSavemask
    userSelection='Yes';
end   

if strcmpi(userSelection, 'Yes')
    fileName = inputdlg('File name (including path)',...
       'Choose the file name to save generated masks', 1, {'myMask.mat'});
    save(fileName{1}, 'blendMaskCell');
end

close(figH);