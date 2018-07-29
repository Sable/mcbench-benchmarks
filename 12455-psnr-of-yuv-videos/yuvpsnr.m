%   yuvpsnr computes the psnr between two YUV-Files.
%
%	yuvpsnr('Filename1','Filename1', width, height, format,parameter) reads
%	the specified files using width and height for resolution and format 
%   for YUV-subsampling. With parameter you can chose if you want to
%   compute the psnr between the y, the u, the v, or the yuv part of the
%   videos
%	
%	Filename1 --> Name of File one (e.g. 'Test1.yuv')
%   Filename2 --> Name of File two (e.g. 'Test2.yuv')
%   width    --> width of a frame  (e.g. 352)
%   height   --> height of a frame (e.g. 280)
%   format   --> subsampling rate ('400','411','420','422' or '444')
%   parameter -->chose the components of the video which are used to compute 
%                 the psnr ('y', 'u', 'v', 'yuv') 
%
%   example: psnr = yuvpsnr('Test1.yuv','Test2.yuv',352,288,'420','y');

function PSNR = yuvpsnr(File1,File2,width,height,format,parameter)

    %set factor for UV-sampling
    fwidth = 0.5;
    fheight= 0.5;
    if strcmp(format,'400')
        fwidth = 0;
        fheight= 0;
    elseif strcmp(format,'411')
        fwidth = 0.25;
        fheight= 1;
    elseif strcmp(format,'420')
        fwidth = 0.5;
        fheight= 0.5;
    elseif strcmp(format,'422')
        fwidth = 0.5;
        fheight= 1;
    elseif strcmp(format,'444')
        fwidth = 1;
        fheight= 1;
    else
        display('Error: wrong format');
    end
    %get Filesize and Framenumber
    filep = dir(File1); 
    fileBytes = filep.bytes; %Filesize1
    clear filep
    framenumber1 = fileBytes/(width*height*(1+2*fheight*fwidth)); %Framenumber1
    filep = dir(File1); 
    fileBytes = filep.bytes; %Filesize2
    clear filep
    framenumber2 = fileBytes/(width*height*(1+2*fheight*fwidth)); %Framenumber2
    if mod(framenumber1,1) ~= 0 | mod(framenumber2,1) ~= 0 | framenumber1~=framenumber2
        display('Error: wrong resolution, format, filesize or different video lengths');
    else
        h = waitbar(0,'Please wait ... ');
        for cntf = 1:framenumber1
            waitbar(cntf/framenumber1,h);
            %load data of frames
            YUV1 = loadFileYUV(width,height,cntf,File1,fheight,fwidth);
            YUV2 = loadFileYUV(width,height,cntf,File2,fheight,fwidth);
            %get MSE for single frames
            if parameter == 'y'
                mse(cntf) = sum(sum((double(YUV1(:,:,1))-double(YUV2(:,:,1))).^2))/(width*height);
            elseif parameter == 'u'
                mse(cntf) = sum(sum((double(YUV1(:,:,2))-double(YUV2(:,:,2))).^2))/(width*height);
            elseif parameter == 'v'
                mse(cntf) = sum(sum((double(YUV1(:,:,3))-double(YUV2(:,:,3))).^2))/(width*height);
            elseif parameter == 'yuv'
                mse(cntf) = sum((double(YUV1(:))-double(YUV2(:))).^2)/length(YUV1(:));
            end
        end
        %compute the mean of the mse vector
        msemean = (sum(mse)/length(mse));
        %compute the psnr 
        if msemean ~= 0
            PSNR = 10*log10((255^2)/msemean)
        else
            PSNR = Inf;
        end
        close(h);
    end


% read YUV-data from file
function YUV = loadFileYUV(width,heigth,Frame,fileName,Teil_h,Teil_b)
    % get size of U and V
    fileId = fopen(fileName,'r');
    width_h = width*Teil_b;
    heigth_h = heigth*Teil_h;
    % compute factor for framesize
    factor = 1+(Teil_h*Teil_b)*2;
    % compute framesize
    framesize = width*heigth;
      
    fseek(fileId,(Frame-1)*factor*framesize, 'bof');
    % create Y-Matrix
    YMatrix = fread(fileId, width * heigth, 'uchar');
    YMatrix = int16(reshape(YMatrix,width,heigth)');
    % create U- and V- Matrix
    if Teil_h == 0
        UMatrix = 0;
        VMatrix = 0;
    else
        UMatrix = fread(fileId,width_h * heigth_h, 'uchar');
        UMatrix = int16(UMatrix);
        UMatrix = reshape(UMatrix,width_h, heigth_h).';
        
        VMatrix = fread(fileId,width_h * heigth_h, 'uchar');
        VMatrix = int16(VMatrix);
        VMatrix = reshape(VMatrix,width_h, heigth_h).';       
    end
    % compose the YUV-matrix:
    YUV(1:heigth,1:width,1) = YMatrix;
    
    if Teil_h == 0
        YUV(:,:,2) = 127;
        YUV(:,:,3) = 127;
    end
    % consideration of the subsampling of U and V
    if Teil_b == 1
        UMatrix1(:,:) = UMatrix(:,:);
        VMatrix1(:,:) = VMatrix(:,:);
    
    elseif Teil_b == 0.5        
        UMatrix1(1:heigth_h,1:width) = int16(0);
        UMatrix1(1:heigth_h,1:2:end) = UMatrix(:,1:1:end);
        UMatrix1(1:heigth_h,2:2:end) = UMatrix(:,1:1:end);
 
        VMatrix1(1:heigth_h,1:width) = int16(0);
        VMatrix1(1:heigth_h,1:2:end) = VMatrix(:,1:1:end);
        VMatrix1(1:heigth_h,2:2:end) = VMatrix(:,1:1:end);
    
    elseif Teil_b == 0.25
        UMatrix1(1:heigth_h,1:width) = int16(0);
        UMatrix1(1:heigth_h,1:4:end) = UMatrix(:,1:1:end);
        UMatrix1(1:heigth_h,2:4:end) = UMatrix(:,1:1:end);
        UMatrix1(1:heigth_h,3:4:end) = UMatrix(:,1:1:end);
        UMatrix1(1:heigth_h,4:4:end) = UMatrix(:,1:1:end);
        
        VMatrix1(1:heigth_h,1:width) = int16(0);
        VMatrix1(1:heigth_h,1:4:end) = VMatrix(:,1:1:end);
        VMatrix1(1:heigth_h,2:4:end) = VMatrix(:,1:1:end);
        VMatrix1(1:heigth_h,3:4:end) = VMatrix(:,1:1:end);
        VMatrix1(1:heigth_h,4:4:end) = VMatrix(:,1:1:end);
    end
    
    if Teil_h == 1
        YUV(:,:,2) = UMatrix1(:,:);
        YUV(:,:,3) = VMatrix1(:,:);
        
    elseif Teil_h == 0.5        
        YUV(1:heigth,1:width,2) = int16(0);
        YUV(1:2:end,:,2) = UMatrix1(:,:);
        YUV(2:2:end,:,2) = UMatrix1(:,:);
        
        YUV(1:heigth,1:width,3) = int16(0);
        YUV(1:2:end,:,3) = VMatrix1(:,:);
        YUV(2:2:end,:,3) = VMatrix1(:,:);
        
    elseif Teil_h == 0.25
        YUV(1:heigth,1:width,2) = int16(0);
        YUV(1:4:end,:,2) = UMatrix1(:,:);
        YUV(2:4:end,:,2) = UMatrix1(:,:);
        YUV(3:4:end,:,2) = UMatrix1(:,:);
        YUV(4:4:end,:,2) = UMatrix1(:,:);
        
        YUV(1:heigth,1:width) = int16(0);
        YUV(1:4:end,:,3) = VMatrix1(:,:);
        YUV(2:4:end,:,3) = VMatrix1(:,:);
        YUV(3:4:end,:,3) = VMatrix1(:,:);
        YUV(4:4:end,:,3) = VMatrix1(:,:);
    end
    YUV = uint8(YUV);
    fclose(fileId);