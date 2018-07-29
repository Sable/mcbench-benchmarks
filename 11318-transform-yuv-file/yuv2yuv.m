%yuv2yuv can change the resolution and format of YUV-Files.
%	yuv2yuv('Filename_old',width_old,height_old,format_old,'Filename_new',w
%	idth_new,height_new,format_new) read one YUV-File with the
%	specified resolution and format and write it to a second YUV-File with
%	the specified resolution and format.
%	
%	Filename_old --> Name of original File (e.g. 'Test_old.yuv')
%   width_old    --> width of original frame  (e.g. 352) 
%   height_old   --> height of original frame (e.g. 280)
%   format_old   --> subsampling rate of original YUV-File('400','411','420','422' or '444')
%	Filename_new --> Name of new File (e.g. 'Test_new.yuv')
%   width_new    --> width of new frame  (e.g. 704) 
%   height_new   --> height of new frame (e.g. 560)
%   format_new   --> subsampling rate of new YUV-File('400','411','420','422' or '444')
%example: yuv2yuv('Test_old.yuv',352,288,'420','Test_new.yuv',704,560,'400')

function yuv2yuv(File_old,width_old,height_old,format_old,File_new,width_new,height_new,format_new)

    %set factor for UV-sampling
    [fwidth_old,fheight_old] = getformatfactor(format_old);
    [fwidth_new,fheight_new] = getformatfactor(format_new);
    %get Filesize and Framenumber of original File
    filep = dir(File_old); 
    fileBytes = filep.bytes; %Filesize
    clear filep
    framenumber = fileBytes/(width_old*height_old*(1+2*fheight_old*fwidth_old)); %Framenumber
    if mod(framenumber,1) ~= 0
        display('Error: wrong resolution, format or filesize');
    else
        fclose(fopen(File_new,'w')); %Init File
        h = waitbar(0,'Please wait ... ');
        %read YUV-Frames
        for cntf = 1:1:framenumber
            waitbar(cntf/framenumber,h);
            YUV     = loadFileYUV(width_old,height_old,cntf,File_old,fheight_old,fwidth_old);
            YUV_new = imresize(YUV,[height_new width_new],'bicubic');
            save_yuv(YUV_new,File_new,width_new,height_new,fheight_new,fwidth_new);
        end
        close(h);
    end
    
    
    
%get factor for YUV-subsampling
function [fwidth,fheight] = getformatfactor(format)
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
    
%Save YUV-Data to File
function save_yuv(data,video_file,BreiteV,HoeheV,HoehenteilerV,BreitenteilerV)

    %get Resolution od Data
    datasize = size(data);
    datasizelength = length(datasize);

    %open File
    fid = fopen(video_file,'a');

    %subsampling of U and V
    if datasizelength == 2 | HoehenteilerV == 0
        %4:0:0
        y(1:HoeheV,1:BreiteV) = data(:,:,1);
    elseif datasizelength == 3
        y(1:HoeheV,1:BreiteV) = double(data(:,:,1));
        u(1:HoeheV,1:BreiteV) = double(data(:,:,2));
        v(1:HoeheV,1:BreiteV) = double(data(:,:,3));
        if BreitenteilerV == 1
            %4:1:1
            u2 = u;
            v2 = v;
        elseif HoehenteilerV == 0.5
            %4:2:0
            u2(1:HoeheV/2,1:BreiteV/2) = u(1:2:end,1:2:end)+u(2:2:end,1:2:end)+u(1:2:end,2:2:end)+u(2:2:end,2:2:end);
            u2                         = u2/4;
            v2(1:HoeheV/2,1:BreiteV/2) = v(1:2:end,1:2:end)+v(2:2:end,1:2:end)+v(1:2:end,2:2:end)+v(2:2:end,2:2:end);
            v2                         = v2/4;
        elseif BreitenteilerV == 0.25
            %4:1:1
            u2(1:HoeheV,1:BreiteV/4) = u(:,1:4:end)+u(:,2:4:end)+u(:,3:4:end)+u(:,4:4:end);
            u2                       = u2/4;
            v2(1:HoeheV,1:BreiteV/4) = v(:,1:4:end)+v(:,2:4:end)+v(:,3:4:end)+v(:,4:4:end);
            v2                       = v2/4;
        elseif BreitenteilerV == 0.5 & HoehenteilerV == 1
            %4:2:2
            u2(1:HoeheV,1:BreiteV/2) = u(:,1:2:end)+u(:,2:2:end);
            u2                       = u2/2;
            v2(1:HoeheV,1:BreiteV/2) = v(:,1:2:end)+v(:,2:2:end);
            v2                       = v2/2;
        end
    end

    fwrite(fid,uint8(y'),'uchar'); %writes Y-Data

    if HoehenteilerV ~= 0
        %writes U- and V-Data if no 4:0:0 format
        fwrite(fid,uint8(u2'),'uchar');
        fwrite(fid,uint8(v2'),'uchar');
    end

    fclose(fid);
 