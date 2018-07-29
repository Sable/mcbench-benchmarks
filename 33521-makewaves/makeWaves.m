function makeWaves()
%makeWaves converts DAQ channels to individual WAV files.

        %Set up waitbar
        h = waitbar(0,'Converting raw DAQ to WAV files', 'WindowStyle','modal');
        set(h,'CloseRequestFcn','')
        
        %Waitbar in try-catch so it doesn't lock up function
        try
            %Setup conversion of DAQ input into WAV files
            [daqname,daqpath] = uigetfile('.daq');
            cd(daqpath);
            daqinfo = daqread(daqname,'info');
            fs = daqinfo.ObjInfo.SampleRate;
            nchannels = 9; %Should be generalized for variety of DAQs
        
            %Convert DAQ input to WAV files
            %[pathstr, name, ext] = fileparts(daqname);
            [pathstr, name] = fileparts(daqname);
            br = load('butterResult.mat');
            b = br.b; a = br.a; %3rd order band pass butterworth filter
            for i = 1:nchannels
                waitbar(i/(nchannels+1),h);
                wavdata = daqread(daqname,'Channels',i);
                wavdata = filter(b,a,wavdata); %band pass between 100 & 500 Hz
                wavdata = (wavdata/max(abs(wavdata)))*(1 - 1/32768); %Normalize
                %Matlab 2010 uses a slightly different wavwrite function in which
                %all values up to but not including one can be written, so the
                %values must be normalized to the value just below one.
                    if (i ~= nchannels)
                        wavNames{i}=fullfile(pathstr,sprintf('%s_%d.wav',name,i));
                    else
                        wavNames{i}=fullfile(pathstr,sprintf('%s_mic.wav',name));
                    end
                wavwrite(wavdata,fs,wavNames{i})
            end
            
            %Close off the wait bar.
            delete(h)
    
        %Catch any exceptions during audio wrapup.
        catch ex %#ok<NASGU>
       
        %Close off the wait bar.
        delete(h);
        
        %Show a warning.
        uiwait(msgbox(['Error during WAV conversion. The WAV files may have '...
        'become corrupted, but the DAQ file should still be usable for data extraction.'],...
        'Audio Wrapup','modal'))
        end
end

