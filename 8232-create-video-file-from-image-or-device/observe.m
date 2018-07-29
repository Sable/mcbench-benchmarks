%OBSERVE Create a video file, by continuously reading an image from a local
%   image file, an image file on the internet, a video device connected to
%   your computer or your computer screen.
%   IMG_CNT = OBSERVE(IMAGE_URL, INTERVAL_SEC, VIDEO_FILENAME_PATTERN, VIDEO_FPS,
%   VIDEO_CODEC_FOURCC, VIDEO_CODEC_QUALITY, LOG_TO_FILE)
%   loads the image present at the specified IMAGE_URL every INTERVAL_SEC
%   seconds and stores it in an avi file with name VIDEO_FILENAME_PATTERN.
%
%   There are three possible ways of capturing:
%  
%   1. Capturing from an image file on your computer or the internet:
%     If for example IMAGE_URL == 'c:\hello.png' then this image will be
%     used as video source for the capturing. Of course this only makes
%     sense if the content of the file changes during the capturing process.
%     You can also use an image url such as
%     'http://www.heavens-above.com/images/tinylogo.jpg'
%     to capture online webcams or weather satellite images.
%
%   2. Capturing from video devices connected directly to your computer:
%     If IMAGE_URL has the format 'vid:D,F' where D and F are numbers
%     defining a video device nr D and corresponding video format nr F,
%     that video input will be used for capturing.
%   
%     To get a list of available video devices and corresponding video
%     formats enter observe('vid?');
%
%   3. Capturing from the screen:
%     If IMAGE_URL has the format 'scr:X,Y,W,H' a screen section with the
%     specified position and size will be used as video source.
%     If no parameters are specified the entire screen serves as input.
%   
%   OBSERVE returns the # of images that were stored in the avi file.
%
%   The resulting avi file will have a framerate of VIDEO_FPS fps.
%   VIDEO_CODEC_FOURCC is the four character code of the video codec to be
%   used and VIDEO_CODEC_QUALITY is the "quality" (between 0 and 100)
%   of the video. If LOG_TO_FILE is true, a log file will be created.
%   If VIDEO_CODEC_FOURCC is 'MPG' and the mpgwrite function is available,
%   an MPEG1 video file will be created at the end of the observation.
%
%   Default values are:
%      IMAGE_URL              = 'vid:1'
%      INTERVAL_SEC           = 20
%      VIDEO_FILENAME_PATTERN = 'video####.avi'
%      VIDEO_FPS              = 15
%      VIDEO_CODEC_FOURCC     = 'IV50'
%      VIDEO_CODEC_QUALITY    = 100
%      LOG_TO_FILE            = true
%
%   If the parameter VIDEO_FILENAME_PATTERN contains one or more '#'
%   characters, a new video file will be created automatically.
%   The program ends, by closing the figure window.
%
function img_cnt = observe(image_url, interval_sec, video_filename_pattern, video_fps, video_codec_fourcc, video_codec_quality, log_to_file)

    img_cnt = 0;

    % codec image size granularity (change to e.g. 8 or 16 if codec complains)
    codec_img_size_granularity = 4;

    % parameter preprocessing (default value substitution)
    if nargin < 7, log_to_file = true; end
    if nargin < 6, video_codec_quality = 100; end
    if nargin < 5, video_codec_fourcc = 'IV50'; end
    if nargin < 4, video_fps = 15; end
    if nargin < 3, video_filename_pattern = 'video####.avi'; end
    if nargin < 2, interval_sec = 20; end
    if nargin < 1, image_url = 'vid:1'; end

    % show list of video devices and formats
    if beginswith(image_url, 'vid?')
        show_video_devices;
        return;
    end

    % get screen input if needed
    scr_input = false;
    if beginswith(image_url, 'scr')

        % get rectangle parameters --> x,y,width,height
        rect_params = sscanf(image_url,'scr:%d,%d,%d,%d');

        % java stuff... (thx to saurabh kumar for the code)
        robo    = java.awt.Robot;
        toolkit = java.awt.Toolkit.getDefaultToolkit();
        % if no or not enough parameters where specified...
        if length(rect_params)<2
            % use entire screen
            rectangle = java.awt.Rectangle(toolkit.getScreenSize());
        elseif length(rect_params)<4
            % use default width and height if only x and y where specified
            rectangle = java.awt.Rectangle(rect_params(1),rect_params(2),256,256);
        else
            % use specified parameters
            rectangle = java.awt.Rectangle(rect_params(1),rect_params(2),rect_params(3),rect_params(4));
        end
        scr_input = true;
    end    
    
    % get video input if video device is specified (instead of an image url)
    vid_input = [];
    if beginswith(image_url, 'vid:')

        % get video parameters
        vid_params1 = sscanf(image_url,'vid:%d:%d');    % <- just for compability the "old syntax" still works (but considered as deprecated)
        vid_params2 = sscanf(image_url,'vid:%d,%d');
        if length(vid_params1)>length(vid_params2)
            vid_params = vid_params1;
        else
            vid_params = vid_params2;
        end

        if length(vid_params)==1
            vdevice_nr = vid_params(1);
            vformat_nr = 0;
        elseif length(vid_params)==2
            vdevice_nr = vid_params(1);
            vformat_nr = vid_params(2);
        else
            logit('Invalid video device syntax. Correct is e.g. vid:1,15\r');
            return;
        end
        
        
        % get video input
        [vid_input, is_yuv] = get_video_input(vdevice_nr, vformat_nr);      
        if isempty(vid_input)
            logit('Video input could not be opened.\r');
            return;
        end
        set(vid_input, 'FramesPerTrigger', 1);
        set(vid_input, 'TriggerRepeat', Inf);
        triggerconfig(vid_input, 'manual');
        vid_src = getselectedsource(vid_input);

        % find and set minimum framerate for capturing (should give best picture quality)
        framerates = get_videosrc_framerates(vid_src);
        capture_framerate = min(framerates);
        logit('Video capture mode set to %d fps. Capturing with %d seconds interval\r',capture_framerate,interval_sec);
        set(vid_src, 'FrameRate', num2str(capture_framerate));
        start(vid_input);
    end

    % true if MPEG1 video file is to be created
    is_mpg = 0;
    if strcmpi(video_codec_fourcc, 'mpg')
        is_mpg = 1;
        video_codec_fourcc = 'IV50';
    end

    % determine filename and create avi file
    if ~endswith(video_filename_pattern, '.avi'), video_filename_pattern = strcat(video_filename_pattern, '.avi'); end
    filename = next_filename(video_filename_pattern);
    aviobj = avifile(filename, 'compression', video_codec_fourcc, 'fps', video_fps, 'quality', video_codec_quality);
    if log_to_file
        logfilename = strcat(getfilename_root(filename), '.log');
        log_fid = fopen(logfilename, 'w');
        logit('Logging to %s\r', logfilename);
    end
    logit('Video source   = %s\r', image_url);
    logit('Video filename = %s\r', filename);

    % observe...
    fig_handle = figure('Name',['Observation of ',image_url,' to ',filename]);
    t0 = clock;
    interval_cnt = 0;
    frame_size = [];
    
    while true
  
        % load image from url
        A = get_image;
        if isempty(A)
            logit('Image could not be loaded. Trying again');
        else
            % if first image captured...
            if isempty(frame_size)
                % store height and width of final video
                frame_size(1) = size(A,1);
                frame_size(2) = size(A,2);
            
                % apply image size granularity and check for zero dimensions
                frame_size = round(frame_size / codec_img_size_granularity)*codec_img_size_granularity;
                frame_size = frame_size + (frame_size==0);            
                logit('Final video size is %dx%d.\r', frame_size(2), frame_size(1) );          
            end

            % if image has changed dimensions 
            if (size(A,1) ~= frame_size(1) || size(A,2) ~= frame_size(2))
                A = imresize(A, [frame_size(1), frame_size(2)], 'bicubic');
            end
        end
    
        there_was_problem = false;
        while isempty(A)
            there_was_problem = true;
            logit('.');
            pause(2.0);
            A = get_image;
        
            % window closed???
            if ~ishandle(fig_handle)
                finalize_video;
                return;
            end
        end
        if there_was_problem, logit('\r'); end
    
        % add frame to avi file and show image
        img_cnt = img_cnt + 1;
        imshow(A);
        aviobj = addframe(aviobj, A);
        logit('%s - Image #%d captured.\r', datestr(now), img_cnt);
    
    
        % wait for next interval...
        et = etime(clock,t0);
        new_mod = mod(et, interval_sec);
        while true
            % window closed???
            if ~ishandle(fig_handle)
                finalize_video;
                return;
            end

            % interval end???
            et = etime(clock,t0);
            old_mod = new_mod;
            new_mod = mod(et, interval_sec);
            if new_mod < old_mod
                break;
            end
            pause(min(0.2, interval_sec-new_mod));
        end
    end

    % get uint8 rgb image from location
    function out = get_image()
        try
            if scr_input
                out = java2im(robo.createScreenCapture(rectangle));        
            elseif ~isempty(vid_input)
                trigger(vid_input);
                out = make_3channel_img(make_uint8_img(getdata(vid_input)));
                if is_yuv
                    out = ycbcr2rgb(out);   % convert to rgb
                end
            else
               [out, map] = imread(image_url);
               if ~isempty(map)
                   out = ind2rgb(out, map);
               else
                   out = make_3channel_img(make_uint8_img(out));
               end
            end
        catch
           out = []; 
        end
    end
    

    % nested function to finalize the video file
    function finalize_video
        % close avi file
        logit('%d images captured.\r', img_cnt);
        aviobj = close(aviobj);
        close;

        % close video input (if open)
        if ~isempty(vid_input)
            delete(vid_input);
            clear vid_input;
        end

        % if no image was captured...
        if img_cnt == 0
            logit('Deleting empty avi file.\r');
            delete(filename);
        else
            % create mpg file???
            if is_mpg
                % mpgwrite function not there?
                if ~exist('mpgwrite')
                    logit('AVI file can not be converted since the mpgwrite function is not available.\r');
                    logit('Download it from MATLAB Central File Exchange.\r');
                    return;
                end
        
                % create mpg_filename, read the created avi file and convert it to an MPEG1 video
                logit('Converting avi file to MPEG1 video. This may take a while...\r');
                mpg_filename = strcat(getfilename_root(filename), '.mpg');
                mov = aviread(filename);
                mpgwrite(mov, [], mpg_filename);

                % delete avi file (we dont need it anymore)
                logit('Deleting superfluous avi file.\r');
                delete(filename);
            end
        end
        
        % close logfile
        if log_to_file
            logit('Closing logfile.\r');
            fclose(log_fid);
            log_to_file = false;
        end
    end


    % nested function to log to log file and/or to screen
    function logit(format, varargin)
        if length(varargin)==0
            x = sprintf(format);
        elseif length(varargin)==1
            x = sprintf(format, varargin{1});
        elseif length(varargin)==2
            x = sprintf(format, varargin{1}, varargin{2});
        elseif length(varargin)==3
            x = sprintf(format, varargin{1}, varargin{2}, varargin{3});  
        elseif length(varargin)==4
            x = sprintf(format, varargin{1}, varargin{2}, varargin{3}, varargin{4});  
        elseif length(varargin)==5
            x = sprintf(format, varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5});  
        elseif length(varargin)==6
            x = sprintf(format, varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}, varargin{6});  
        else
            x = 'Too many input variables in varargin!';
        end

        % log to file
        if log_to_file
            if exist('log_fid')
                fprintf(log_fid, x);
                if endswith(format,'\r')
                    fprintf(log_fid, '\n');   % <- for notepad.exe 
                end
            end
        end

        % log to screen
        fprintf(x);
    end

end % end of observe



% returns a new filename for pattern if there is one
% otherwise returns pattern itself.
function out = next_filename(pattern)
    % save pattern ending and strip it off
    pattern_ending = getfilename_ending(pattern);
    pattern = getfilename_root(pattern);

    % get position of all # chars
    pos = strfind(pattern, '#');
    if isempty(pos)
        out = strcat(pattern, pattern_ending);
        return
    end

    % find position and length of (first) ###-field
    num_pos = pos(1);
    num_len = 1;
    for i=2:length(pos)
        if (pos(i)-pos(i-1))>1
            break
        end
        num_len = num_len + 1;    
    end
    prefix = pattern(1:num_pos-1);
    suffix = pattern(num_pos+num_len:length(pattern));

    % find a new filename with binary search
    i=1;
    low_bound = 0;
    while true
        if videofile_exists([prefix, extnum(i, num_len), suffix])
            low_bound = i;
            i=i*2;
            if low_bound>=10^num_len
                out = strcat(pattern, pattern_ending); % no filename left!
                return;
            end
        else
            a = low_bound + 1;
            b = min(i - 1, 10^num_len-1);
            while a<=b
                m = (a+b)/2;
                if videofile_exists([prefix, extnum(m, num_len), suffix])
                    a=m+1;
                else
                    b=m-1;
                end
            end

            if a==10^num_len
                out = strcat(pattern, pattern_ending);
            else
                out = [prefix, extnum(a, num_len), suffix, pattern_ending];
            end
            return;
        end
    end
end


% true, if the avi or mpg file exists
function yes = videofile_exists(filename_root)
    yes = exist(strcat(filename_root, '.avi')) | exist(strcat(filename_root, '.mpg'));
end


% make a uint8 image from img
function out = make_uint8_img(img)
    if (islogical(img))
        out = uint8(img)*255;
    elseif (~isinteger(img))
        out = uint8(img*255);
    else
        out = uint8(img);
    end
end

% make 3 channel image
function out = make_3channel_img(img)
    if ndims(img) == 2
        out = zeros(size(img,1), size(img,2), 3, 'uint8');
        out(:,:,1) = img;
        out(:,:,2) = img;
        out(:,:,3) = img;
    else
        out = img;
    end
end


% show available video devices and corresponding video formats
function show_video_devices
    vid_devices_info = imaqhwinfo('winvideo');
    num_vid_devices = size(vid_devices_info.DeviceInfo, 2);

    if num_vid_devices==0
        fprintf('No video device available.\r');
    end

    for i=1:num_vid_devices
        recent_device = imaqhwinfo('winvideo', i);
        num_recent_formats = size(recent_device.SupportedFormats, 2);
     
        fprintf('Device %d\t = %s\r', i, char(recent_device.DeviceName));    
        for j=1:num_recent_formats
            fprintf('\tFormat %d\t = %s\r', j, char(recent_device.SupportedFormats(j)));
        end
    end
end


% get video input from vdevice_nr and vformat_nr
function [vid_input, is_yuv] = get_video_input(vdevice_nr, vformat_nr)
    % find # of video devices
    vid_devices_info = imaqhwinfo('winvideo');
    num_vid_devices = size(vid_devices_info.DeviceInfo, 2);

    % check if vdevice_nr is ok
    if vdevice_nr < 1
        fprintf('Invalid video device nr. Video device nr has to be > 0.\r');
        vid_input = [];
    elseif vdevice_nr > num_vid_devices
        fprintf('Invalid video device nr. Only %d video device(s) available.\r', num_vid_devices);
        vid_input = [];
    else
        vid_device = imaqhwinfo('winvideo', vdevice_nr);
        % use DefaultFormat if vformat_nr is invalid
        if vformat_nr<1 | vformat_nr>size(vid_device.SupportedFormats, 2)
            vformat_str = char(vid_device.DefaultFormat);
        else
            vformat_str = char(vid_device.SupportedFormats(vformat_nr));
        end
        
        vid_input = videoinput('winvideo', vdevice_nr, vformat_str);
        is_yuv = ~beginswith(vformat_str, 'RGB');
    end
end


function framerates = get_videosrc_framerates(vid_src)
    pi = propinfo(vid_src, 'FrameRate');
    framerates=[];
    for i=1:length(pi.ConstraintValue)
        framerates=[framerates,str2num(pi.ConstraintValue{i})];
    end
end


% example: extnum(123, 5) = '00123'
function x = extnum(nr, digits)
    x = num2str(nr);
    x = [repmat('0', 1, digits-length(x)),x];
end

% example: getfilename_root('Hello.txt') = 'Hello'
function out = getfilename_root(filename)
    K = strfind(filename, '.');
    if isempty(K)
        out = filename;
    else
        out = filename(1:(K(size(K,2))-1));
    end
end

% example: getfilename_ending('Hello.txt') = '.txt'
function out = getfilename_ending(filename)
    K = strfind(filename, '.');
    if isempty(K)
        out = '';
    else
        out = filename((K(size(K,2))):size(filename,2));
    end
end

% true if text begins with an_start
function yes = beginswith(text, an_start)
    K = strfind(text, an_start);
    yes = 0;
    if ~isempty(K)
        if K(1)==1
            yes = 1;
        end
    end
end

% true if text ends with an_end
function yes = endswith(text, an_end)
    K = strfind(text, an_end);
    if isempty(K)
        yes = 0;
        return;
    end
    if K(length(K))==length(text)-length(an_end)+1
        yes = 1;
    else
        yes = 0;
    end
end

% convert java jimage object to matlab rgb image
function out = java2im(jimage)
    w = int32(jimage.getWidth());
    h = int32(jimage.getHeight());

    tmp = zeros(w, h, 'int32');
    pg = java.awt.image.PixelGrabber(jimage, 0, 0, w, h, tmp(:), 0, w);
    pg.grabPixels();
    tmp = pg.getPixels();
    tmp = reshape(typecast(tmp(:), 'uint32'), w, h)';

    out = zeros(h, w, 3, 'uint8');
    out(:,:,3) = bitand(tmp, 255);
    out(:,:,2) = bitand(bitshift(tmp, -8), 255);
    out(:,:,1) = bitand(bitshift(tmp, -16), 255);        
end
