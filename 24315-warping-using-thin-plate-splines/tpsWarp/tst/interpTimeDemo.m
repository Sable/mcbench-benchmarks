% Temporal interpolation of video sequence demo
%
% Dependencies: 
% 1. mmread, mmwrite, [mmplay] available at:
% http://www.mathworks.com/matlabcentral/fileexchange/8028
% http://www.mathworks.com/matlabcentral/fileexchange/15881
% http://www.mathworks.com/matlabcentral/fileexchange/15880
%
% Inputs:
% vidInFilename - input video filename
% lmFilename - data file containing landmark points (stationary region)
% NLPs - number of landmark points (non-rigid motion)
% numFrames - number of frames to be processed (need to match with
%             lmFilename)
%
% Output:
% inp.avi (input), avg.avi (averaging), wrp.avi (warping) video files
% erra.avi (error of averaging) and errw.avi (error of warping) video files
% Display of warped video, error and interpolated positions
% 
% Example:
% interpTimeDemo('..\data\MOV03798.MPG', 'MOV03798ext.mat',15, 25)
%
% Author: Fitzgerald J Archibald
% Date: 29-Apr-09

function interpTimeDemo(vidInFilename, lmFilename, NLPs, numFrames)
%% initialization
interp.method = 'invdist'; %'nearest'; %'none' % interpolation method
interp.radius = 5; % radius or median filter dimension
interp.power = 2; %power for inverse wwighting interpolation method

[mov, tmp]=mmread(vidInFilename,1:numFrames);
clear tmp;
numFrames = min(mov.nrFramesTotal,numFrames);

% load landmark points
load(lmFilename); % Xp, Yp
NPs = length(Xp(1,:)); % number of landmark points (all)
% Use landmarks points of 'numFrames' only
Xp=Xp(1:numFrames,:);
Yp=Yp(1:numFrames,:);

%% Warp to create missing frames (warping method)

% memory for interpolated points
Xsi = Xp; 
Ysi = Yp;

% Select subset of frames (landmark of selected frames)
% Drop landmarks in even frames
Xs = Xp(1:2:numFrames,:);
Ys = Yp(1:2:numFrames,:);

% interpolate landmark points for missing frame
xyref = 1:2:numFrames;
xyi = 1:numFrames;
Xsi=Xp;
Ysi=Yp;
for ix = 1:NPs,
    Xsi(:,ix) = interp1(xyref,Xs(:,ix),xyi,'*spline');
    Ysi(:,ix) = interp1(xyref,Ys(:,ix),xyi,'*spline');
end
clear Xs Ys

% Warp the frame to create missing frame (landmark point mapping to
% interpolatedd correspondence points)
movw = mov;
for ix = 2:2:numFrames,
    imgW = tpswarp(mov.frames(ix-1).cdata,[size(movw.frames(ix).cdata,2) size(movw.frames(ix).cdata,1)],[Xp(ix-1,:)' Yp(ix-1,:)'],[Xsi(ix,:)' Ysi(ix,:)'],interp); % thin plate spline warping
    movw.frames(ix).cdata = uint8(imgW);
end

%% Average to create missing frames (averaging method)
mova = mov;
numFrames_1 = numFrames;
if numFrames-2*floor(numFrames/2) == 0, % handle if numFrames is even number
    numFrames_1 = numFrames - 1;
    mova.frames(numFrames) = mov.frames(numFrames_1);
end
% averaging of odd numbered frames to create missing even numbered frames
for ix = 2:2:numFrames_1,
    mova.frames(ix).cdata = (mov.frames(ix-1).cdata*0.5+mov.frames(ix+1).cdata*0.5);
end

%% Write the data to output files
%videoList = mmwrite('','ListAviVideoEncoders'); % get available codecs
%videoList % display codec names

codec='Cinepak Codec by Radius';
conf.videoCompressor = codec;

%mmwrite('inp.mov',mov);
mmwrite('inp.avi',mov,conf);

%mmwrite('avg.mov',mova);
mmwrite('avg.avi',mova,conf);


%mmwrite('wrp.mov',movw);
mmwrite('wrp.avi',movw,conf);

%% Plot interpolation of landmark points
if 1    
    figure(2);
    subplot 211;
    plot(Xsi(:,1:NLPs)); hold on
    plot(Xp(:,1:NLPs),'*:'); hold off
    %plot(Xsi(:,1:NLPs)-Xp(:,1:NLPs));
    axis tight

    subplot 212;
    plot(Ysi(:,1:NLPs)); hold on
    plot(Yp(:,1:NLPs),'*:'); hold off
    %plot(Ysi(:,1:NLPs)-Yp(:,1:NLPs));
    axis tight
end

%% Display acquired landmark points
% Modify video to highlight position of landmark points
[mov, mova, movw]=dbgPoints(mov, mova, movw, Xp, Yp, Xsi, Ysi, NLPs);
%[mov, mova, movw]=dbgPoints(mov, mova, movw, Xp, Yp, Xsi, Ysi, NPs);

figure(1);
for k = 1 : numFrames,
    subplot(1,3,1); imshow(mov.frames(k).cdata,[]);
    colormap(mov.frames(k).colormap);
    title(num2str(k));
    
    subplot(1,3,2); imshow(mova.frames(k).cdata,[]);
    colormap(mov.frames(k).colormap);
    title(num2str(k));
    
    subplot(1,3,3); imshow(movw.frames(k).cdata,[]);
    colormap(mov.frames(k).colormap);
    title(num2str(k));
    
    pause(0.03);
end

%% Display / write error
moverra = mova;
moverrw = movw;
figure(1); clf('reset');
for fm = 1:numFrames,
    moverra.frames(fm).cdata = abs(mova.frames(fm).cdata(:,:,:) - mov.frames(fm).cdata(:,:,:));
    moverrw.frames(fm).cdata = abs(movw.frames(fm).cdata(:,:,:) - mov.frames(fm).cdata(:,:,:));
    err1(fm)=sum(sum(sum( moverra.frames(fm).cdata )));
    err2(fm)=sum(sum(sum( moverrw.frames(fm).cdata )));

    subplot(2,2,1); imshow(moverra.frames(fm).cdata);
    colormap(mov.frames(fm).colormap);
    title(num2str(fm));
    
    subplot(2,2,2); imshow(moverrw.frames(fm).cdata);
    colormap(mov.frames(fm).colormap);
    title(num2str(fm));

    subplot 223;imhist(moverra.frames(fm).cdata(:,:,1))
    subplot 224;imhist(moverrw.frames(fm).cdata(:,:,1))

    pause(0.03);
end
mmwrite('erra.avi',moverra,conf);
mmwrite('errw.avi',moverrw,conf);

figure(3);  clf('reset');
bar([err1(2:2:end)' err2(2:2:end)']);
legend('fn1','fn2');
axis tight;

return

%% Mark landmark points for display
function [mov, mova, movw] = dbgPoints(mov, mova, movw, Xp, Yp, Xsi, Ysi, NPs)

len=8;
for fm = 1:mov.nrFramesTotal-1,
    for pt = 1:NPs,
        YpSt(fm,pt) = fix(max(1,Yp(fm,pt)-len));
        YpEd(fm,pt) = fix(min(mov.width,Yp(fm,pt)+len));
        XpSt(fm,pt) = fix(max(1,Xp(fm,pt)-len));
        XpEd(fm,pt) = fix(min(mov.height,Xp(fm,pt)+len));

        YsiSt(fm,pt) = fix(max(1,Ysi(fm,pt)-len));
        YsiEd(fm,pt) = fix(min(mov.width,Ysi(fm,pt)+len));
        XsiSt(fm,pt) = fix(max(1,Xsi(fm,pt)-len));
        XsiEd(fm,pt) = fix(min(mov.height,Xsi(fm,pt)+len));
    end
end


for fm = 1:mov.nrFramesTotal-1,
    for pt = 1:NPs,
        mov.frames(fm).cdata(fix(Xp(fm,pt)), YpSt(fm,pt):YpEd(fm,pt),:) = 0;
        mov.frames(fm).cdata(XpSt(fm,pt):XpEd(fm,pt), fix(Yp(fm,pt)),:) = 0;
        mov.frames(fm).cdata(fix(Xsi(fm,pt)), YsiSt(fm,pt):YsiEd(fm,pt),:) = 255;
        mov.frames(fm).cdata(XsiSt(fm,pt):XsiEd(fm,pt), fix(Ysi(fm,pt)),:) = 255;
    end
end
%mmplay(mov,'fullscreen')

for fm = 1:mov.nrFramesTotal-1,
    for pt = 1:NPs,
        mova.frames(fm).cdata(fix(Xp(fm,pt)), YpSt(fm,pt):YpEd(fm,pt),:) = 0;
        mova.frames(fm).cdata(XpSt(fm,pt):XpEd(fm,pt), fix(Yp(fm,pt)),:) = 0;
    end
end
%mmplay(mova,'fullscreen')

for fm = 1:mov.nrFramesTotal-1,
    for pt = 1:NPs,
        movw.frames(fm).cdata(fix(Xp(fm,pt)), YpSt(fm,pt):YpEd(fm,pt),:) = 0;
        movw.frames(fm).cdata(XpSt(fm,pt):XpEd(fm,pt), fix(Yp(fm,pt)),:) = 0;
        movw.frames(fm).cdata(fix(Xsi(fm,pt)), YsiSt(fm,pt):YsiEd(fm,pt),:) = 255;
        movw.frames(fm).cdata(XsiSt(fm,pt):XsiEd(fm,pt), fix(Ysi(fm,pt)),:) = 255;
    end
end
%mmplay(movw,'fullscreen')

return