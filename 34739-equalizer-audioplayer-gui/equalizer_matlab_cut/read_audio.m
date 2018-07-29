function read_audio(fln)
global s Fs


if exist(fln,'file')~=0

    ainfo=mmfileinfo(fln);
    frmt=ainfo.Audio.Format;
    if strcmpi(ainfo.Audio.Format,'PCM')
        [s Fs]=wavread(fln);
    else

        [video, audio] = mmread(fln);
        clear video;
        Fs=audio.rate;
        
        recalculate_filter;


        s=audio.data;
    end

    dt=1/Fs;
    clear audio;
    
    % convert mono to stereo by repeat:
    if size(s,2)==1
        s=[s  s];
    end
    
    % convert many-channels stereo to 2-channels stereo:
    if size(s,2)>2
        s=s(:,1:2);
    end
    
    %sound(s(1:150000,:),Fs);
    
else
    error('file not exist');
end
