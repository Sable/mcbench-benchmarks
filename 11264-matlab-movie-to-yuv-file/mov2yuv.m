%mov2yuv creates a Matlab-Movie from a YUV-File.
%	mov2yuv('Filename',mov, format) writes the specified file
%	using format for YUV-subsampling.
%	
%	Filename --> Name of File (e.g. 'Test.yuv')
%   mov      --> Matlab-Movie
%   format   --> subsampling rate ('400','411','420','422' or '444')
%
%example: mov2yuv('Test.yuv',mov,'420');

function mov2yuv(File,mov,format)

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
    %get Resolution and Framenumber
    resolution = size(mov(1).cdata);
    framenumber = size(mov); 
    framenumber = framenumber(2);

    fclose(fopen(File,'w')); %Init File
    h = waitbar(0,'Please wait ... ');
    %write YUV-Frames
    for cntf = 1:1:framenumber
        waitbar(cntf/framenumber,h);
        YUV = rgb2ycbcr(mov(cntf).cdata);
        save_yuv(YUV,File,resolution(2),resolution(1),fheight,fwidth);
    end
    close(h);


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
