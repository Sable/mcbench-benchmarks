function UpdateSliceOMatic(X,hSlico)
% This should get the data you want:

% Copyright 2004-2010 The MathWorks, Inc.

if nargin<2
  hSlico=gcf;
else                %%RAB%%
  figure(hSlico)    %%RAB%%
end

D = getappdata(hSlico,'sliceomatic');
D.data = X;
setappdata(hSlico,'sliceomatic',D)

% Get axes children objects that are surfaces
ch = findobj('Type','Surface');

% If no slice then no need to update data in the image

if isempty(ch)
    return
end

% Loop thorugh slices
for i=1:length(ch)
    mySlice = ch(i);
   
    % Get the X, Y, Z Data
    XData = get(mySlice,'XData');
    YData = get(mySlice,'YData');
    ZData = get(mySlice,'ZData');
    
    % Find out which one doesn't change by finding the differene in X,Y,Z values 
    diffxyz = [all(diff(XData(:))==0) all(diff(YData(:))==0) all(diff(ZData(:))==0)];
    [nodiff, i] = max(diffxyz);
    
    % Make updates to appropriate slice
    switch i
        case 1
            slice = round(XData(1));
            set(mySlice,'CData',squeeze(X(:,slice,:)))
        case 2
            slice = round(YData(1));
            set(mySlice,'CData',squeeze(X(slice,:,:)))
        case 3
            slice = round(ZData(1));
            set(mySlice,'CData',squeeze(X(:,:,slice)))
    end
    
end


% % The subroutine is attached. It takes the 3D image matrix as its input. So
% % if using sliceomatic you would do the following:
% % 
% % 1. Read Images
% % 2. Manipulate
% % 3. Call sliceomatic(ImageData)
% % 4. Make some changes (i.e. ImageData(ImageData<100)=0
% % 5. call mySubRoutine(ImageData)
% % 
% % Everything should be updated and it runs fast
% % 
% % --L--
% % 
% % -----Original Message-----
% % From: Robert Bemis 
% % Sent: Friday, February 20, 2004 2:26 PM
% % To: Laurens Schalekamp
% % Subject: movtext
% % 
% % Please enjoy file: movtext
% % courtesy of rbemis@mathworks.com
