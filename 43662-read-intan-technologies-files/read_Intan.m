function [output,frequency_parameters,notes,spike_triggers,varargout] = read_Intan(fn,varargin)
% Adapted function to read intan files. Adapted from
% 'read_Intan_RHD2000file.m' as can be downloaded from the manufacuter's
% website: http://www.intantech.com/downloads.html

% This function requires user inputs, opens no dialogues and generates no
% command line output (except errors).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS:
% fn : Filename (including path if necessary)
% 'range' : declares that the following input is a range of data (in sec)
%           to load.
% 'ampch' : Lists the amplifier channnels to load
% 'auxch' : Lists the auxilary channels to load
% 'volt'  : Declares whether the voltage channel should be loaded or no
%           ('yes' or 'no')
% 'ADCch' : Lists the onboard ADC channels to load
% 'DIGch' : Lists the onboard digital channels to load
% 'tempch': Declares whether the temperature data should be loaded ('yes'
%           or 'no')
% 'notch' : Assign '50Hz' or '60Hz' to enable notch filtering. If left
%           undefined then no filter is applied.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
% The first output is always the overview of all outputs.
% The second output is always a structure with frequency settings
% The third output is always the notes structure
% The fourth output is always the spike_triggers structure
% Then the function will provide the requested output as data (in
% timeseries format) and channel information pairs. This is always in a fixed
% order:
% 1. amplifier channels
% 2. auxiliary channels
% 3. ADC channels
% 4. Digital channels
% 5. volts
% 6. temperature
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLES:
% [output,freqs,notes,spike_triggers,ampl_data,ampl_ch,aux_data,aux_ch]...
%    = read_Intan(fn,'auxch',[1 2 3],'ampch',[1]);
% This loads the three auxiliary streams, and channel 1 from the general
% amplifier. No range is specified, so the whole stream is loaded.
%
% [output


% [output,freqs,notes,ampl_data,ampl_channels,ADC_data,...
%   ADC_channels,temp_data,temp_ch] = read_Intan_new(fn,'ampch',...
%   [1 2 4 10:20],'tempch','yes','ADCch',[1 2],'range',[1 100.1]);
%
% 



% First we parse the variable inputs to check whether the list makes sense:
    p = inputParser;
    p.addRequired('Filename',@(fn) ischar(fn));
    p.addParamValue('notch','notchfreq',@(notchfreq)...
        strcmp(notchfreq,'50Hz') || strcmp(notchfreq,'60Hz'));
    p.addParamValue('range','rng',@(rng) length(rng)==2);
    p.addParamValue('ampch','chlist',@(chlist) ~isempty(chlist));
    p.addParamValue('auxch','aux',@(aux) ~isempty(aux));
    p.addParamValue('volt','Vch', @(Vch) ...
        strcmpi(Vch,'yes') || strcmpi(Vch,'no'));
    p.addParamValue('ADCch','ADC',@(ADC) ~isempty(ADC));
    p.addParamValue('DIGch','DIG',@(DIG) ~isempty(DIG)>0);
    p.addParamValue('tempch','temp',@(temp)...
        strcmpi(temp,'yes') || strcmpi(temp,'yes'));
    
    p.parse(fn,varargin{:,:})
    
% Now we assign the values defined in the inputs to the respective
% variables and set some defaults.
nrstreamsrequested = 0;
notchfreq = 0;
channellist = 0;
range = 0;
aux = 0;
supplyvolt = 0;
ADCchannels = 0;
digitalchannels = 0;
temperature = 0;
for arg=1:2:length(varargin)
    switch (varargin{arg})
        case 'notch'
            notchfreq = varargin{arg+1};
        case 'ampch'
            channellist = varargin{arg+1};
            nrstreamsrequested=nrstreamsrequested+1;
        case 'range'
            range = varargin{arg+1};
        case 'auxch'
            aux = varargin{arg+1};
            nrstreamsrequested=nrstreamsrequested+1;
        case 'volt'
            supplyvolt = 1;
            nrstreamsrequested=nrstreamsrequested+1;
        case 'ADCch'
            ADCchannels = varargin{arg+1};
            nrstreamsrequested=nrstreamsrequested+1;
        case 'DIGch'
            digitalchannels = varargin{arg+1};
            nrstreamsrequested=nrstreamsrequested+1;
        case 'tempch'
            temperature = 1;
            nrstreamsrequested=nrstreamsrequested+1;
    end
end
    
% The actual start of the file opening. Here we first open the file to gain
% access to the parts in it.
    fid = fopen(fn, 'r');
    s = dir(fn);
    filesize = s.bytes;
    
    % Check 'magic number' at beginning of file to make sure this is an Intan
    % Technologies RHD2000 data file.
    magic_number = fread(fid, 1, 'uint32');
    if magic_number ~= hex2dec('c6912702')
        error('Unrecognized file type.');
    end

    % Read version number.
    data_file_main_version_number = fread(fid, 1, 'int16');
    data_file_secondary_version_number = fread(fid, 1, 'int16');
    % Read information of sampling rate and amplifier frequency settings.
    sample_rate = fread(fid, 1, 'single');
    dsp_enabled = fread(fid, 1, 'int16');
    actual_dsp_cutoff_frequency = fread(fid, 1, 'single');
    actual_lower_bandwidth = fread(fid, 1, 'single');
    actual_upper_bandwidth = fread(fid, 1, 'single');
    
    desired_dsp_cutoff_frequency = fread(fid, 1, 'single');
    desired_lower_bandwidth = fread(fid, 1, 'single');
    desired_upper_bandwidth = fread(fid, 1, 'single');

    % Enables notch filtering if requested
    notch_filter_mode = fread(fid, 1, 'int16');
    notch_filter_frequency = 0;
    if strcmp(notchfreq,'50Hz')
        notch_filter_frequency = 50;
    elseif strcmp(notchfreq,'60Hz')
        notch_filter_frequency = 60;
    end

    desired_impedance_test_frequency = fread(fid, 1, 'single');
    actual_impedance_test_frequency = fread(fid, 1, 'single');
    
    % Place notes in data strucure
    notes = struct( ...
    'note1', fread_QString(fid), ...
    'note2', fread_QString(fid), ...
    'note3', fread_QString(fid) );
    
    % If data file is from GUI v1.1 or later, see if temperature sensor data
    % was saved.
    num_temp_sensor_channels = 0;
    if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 1) ...
        || (data_file_main_version_number > 1))
        num_temp_sensor_channels = fread(fid, 1, 'int16');
    end

    % Place frequency-related information in data structure.
    frequency_parameters = struct( ...
        'amplifier_sample_rate', sample_rate, ...
        'aux_input_sample_rate', sample_rate / 4, ...
        'supply_voltage_sample_rate', sample_rate / 60, ...
        'board_adc_sample_rate', sample_rate, ...
        'board_dig_in_sample_rate', sample_rate, ...
        'desired_dsp_cutoff_frequency', desired_dsp_cutoff_frequency, ...
        'actual_dsp_cutoff_frequency', actual_dsp_cutoff_frequency, ...
        'dsp_enabled', dsp_enabled, ...
        'desired_lower_bandwidth', desired_lower_bandwidth, ...
        'actual_lower_bandwidth', actual_lower_bandwidth, ...
        'desired_upper_bandwidth', desired_upper_bandwidth, ...
        'actual_upper_bandwidth', actual_upper_bandwidth, ...
        'notch_filter_frequency', notch_filter_frequency, ...
        'desired_impedance_test_frequency', desired_impedance_test_frequency, ...
        'actual_impedance_test_frequency', actual_impedance_test_frequency );
    % Define data structure for spike trigger settings.
    spike_trigger_struct = struct( ...
        'voltage_trigger_mode', {}, ...
        'voltage_threshold', {}, ...
        'digital_trigger_channel', {}, ...
        'digital_edge_polarity', {} );

    new_trigger_channel = struct(spike_trigger_struct);
    spike_triggers = struct(spike_trigger_struct);

    % Define data structure for data channels.
    channel_struct = struct( ...
        'custom_channel_name', {}, ...
        'native_channel_name', {}, ...
        'native_order', {}, ...
        'custom_order', {}, ...
        'board_stream', {}, ...
        'chip_channel', {}, ...
        'port_name', {}, ...
        'port_prefix', {}, ...
        'port_number', {}, ...
        'electrode_impedance_magnitude', {}, ...
        'electrode_impedance_phase', {} );

    new_channel = struct(channel_struct);

    % Create structure arrays for each type of data channel.
    amplifier_channels = struct(channel_struct);
    aux_input_channels = struct(channel_struct);
    supply_voltage_channels = struct(channel_struct);
    board_adc_channels = struct(channel_struct);
    board_dig_in_channels = struct(channel_struct);

    amplifier_index = 1;
    aux_input_index = 1;
    supply_voltage_index = 1;
    board_adc_index = 1;
    board_dig_in_index = 1;
    
    % Read signal summary from data file header.
    
    number_of_signal_groups = fread(fid, 1, 'int16');

    for signal_group = 1:number_of_signal_groups
        signal_group_name = fread_QString(fid);
        signal_group_prefix = fread_QString(fid);
        signal_group_enabled = fread(fid, 1, 'int16');
        signal_group_num_channels = fread(fid, 1, 'int16');
        signal_group_num_amp_channels = fread(fid, 1, 'int16');

        if (signal_group_num_channels > 0 && signal_group_enabled > 0)
            new_channel(1).port_name = signal_group_name;
            new_channel(1).port_prefix = signal_group_prefix;
            new_channel(1).port_number = signal_group;
            for signal_channel = 1:signal_group_num_channels
                new_channel(1).custom_channel_name = fread_QString(fid);
                new_channel(1).native_channel_name = fread_QString(fid);
                new_channel(1).native_order = fread(fid, 1, 'int16');
                new_channel(1).custom_order = fread(fid, 1, 'int16');
                signal_type = fread(fid, 1, 'int16');
                channel_enabled = fread(fid, 1, 'int16');
                new_channel(1).chip_channel = fread(fid, 1, 'int16');
                new_channel(1).board_stream = fread(fid, 1, 'int16');
                new_trigger_channel(1).voltage_trigger_mode = fread(fid, 1, 'int16');
                new_trigger_channel(1).voltage_threshold = fread(fid, 1, 'int16');
                new_trigger_channel(1).digital_trigger_channel = fread(fid, 1, 'int16');
                new_trigger_channel(1).digital_edge_polarity = fread(fid, 1, 'int16');
                new_channel(1).electrode_impedance_magnitude = fread(fid, 1, 'single');
                new_channel(1).electrode_impedance_phase = fread(fid, 1, 'single');

                if (channel_enabled)
                    switch (signal_type)
                        case 0
                            amplifier_channels(amplifier_index) = new_channel;
                            spike_triggers(amplifier_index) = new_trigger_channel;
                            amplifier_index = amplifier_index + 1;
                        case 1
                            aux_input_channels(aux_input_index) = new_channel;
                            aux_input_index = aux_input_index + 1;
                        case 2
                            supply_voltage_channels(supply_voltage_index) = new_channel;
                            supply_voltage_index = supply_voltage_index + 1;
                        case 3
                            board_adc_channels(board_adc_index) = new_channel;
                            board_adc_index = board_adc_index + 1;
                        case 4
                            board_dig_in_channels(board_dig_in_index) = new_channel;
                            board_dig_in_index = board_dig_in_index + 1;
                        otherwise
                            error('Unknown channel type');
                    end
                end

            end
        end
    end

    % Summarize contents of data file.
    num_amplifier_channels = amplifier_index - 1;
    num_aux_input_channels = aux_input_index - 1;
    num_supply_voltage_channels = supply_voltage_index - 1;
    num_board_adc_channels = board_adc_index - 1;
    num_board_dig_in_channels = board_dig_in_index - 1;

    % Determine how many samples the data file contains.

    % Each data block contains 60 amplifier samples.
    bytes_per_block = 60 * 4;  % timestamp data
    bytes_per_block = bytes_per_block + 60 * 2 * num_amplifier_channels;
    % Auxiliary inputs are sampled 4x slower than amplifiers
    bytes_per_block = bytes_per_block + 15 * 2 * num_aux_input_channels;
    % Supply voltage is sampled 60x slower than amplifiers
    bytes_per_block = bytes_per_block + 1 * 2 * num_supply_voltage_channels;
    % Board analog inputs are sampled at same rate as amplifiers
    bytes_per_block = bytes_per_block + 60 * 2 * num_board_adc_channels;
    % Board digital inputs are sampled at same rate as amplifiers
    if (num_board_dig_in_channels > 0)
        bytes_per_block = bytes_per_block + 60 * 2;
    end
    % Temp sensor is sampled 60x slower than amplifiers
    if (num_temp_sensor_channels > 0)
       bytes_per_block = bytes_per_block + 1 * 2 * num_temp_sensor_channels; 
    end

    % How many data blocks remain in this file?
    bytes_remaining = filesize - ftell(fid);
    num_data_blocks = bytes_remaining / bytes_per_block;

    num_amplifier_samples = 60 * num_data_blocks;
    num_aux_input_samples = 15 * num_data_blocks;
    num_supply_voltage_samples = 1 * num_data_blocks;
    num_board_adc_samples = 60 * num_data_blocks;
    num_board_dig_in_samples = 60 * num_data_blocks;

    record_time = num_amplifier_samples / sample_rate;

    % Pre-allocate memory for data.
    t_amplifier = zeros(1, num_amplifier_samples);

    amplifier_data = zeros(num_amplifier_channels, num_amplifier_samples);
    aux_input_data = zeros(num_aux_input_channels, num_aux_input_samples);
    supply_voltage_data = zeros(num_supply_voltage_channels, num_supply_voltage_samples);
    temp_sensor_data = zeros(num_temp_sensor_channels, num_supply_voltage_samples);
    board_adc_data = zeros(num_board_adc_channels, num_board_adc_samples);
    board_dig_in_data = zeros(num_board_dig_in_channels, num_board_dig_in_samples);
    board_dig_in_raw = zeros(1, num_board_dig_in_samples);
    % Read sampled data from file.

    amplifier_index = 1;
    aux_input_index = 1;
    supply_voltage_index = 1;
    board_adc_index = 1;
    board_dig_in_index = 1;

    for i=1:num_data_blocks
        t_amplifier(amplifier_index:(amplifier_index+59)) = fread(fid, 60, 'uint32');
        if (num_amplifier_channels > 0)
            amplifier_data(:, amplifier_index:(amplifier_index+59)) = fread(fid, [60, num_amplifier_channels], 'uint16')';
        end
        if (num_aux_input_channels > 0)
            aux_input_data(:, aux_input_index:(aux_input_index+14)) = fread(fid, [15, num_aux_input_channels], 'uint16')';
        end
        if (num_supply_voltage_channels > 0)
            supply_voltage_data(:, supply_voltage_index) = fread(fid, [1, num_supply_voltage_channels], 'uint16')';
        end
        if (num_temp_sensor_channels > 0)
            temp_sensor_data(:, supply_voltage_index) = fread(fid, [1, num_temp_sensor_channels], 'int16')';
        end
        if (num_board_adc_channels > 0)
            board_adc_data(:, board_adc_index:(board_adc_index+59)) = fread(fid, [60, num_board_adc_channels], 'uint16')';
        end
        if (num_board_dig_in_channels > 0)
            board_dig_in_raw(board_dig_in_index:(board_dig_in_index+59)) = fread(fid, 60, 'uint16');
        end

        amplifier_index = amplifier_index + 60;
        aux_input_index = aux_input_index + 15;
        supply_voltage_index = supply_voltage_index + 1;
        board_adc_index = board_adc_index + 60;
        board_dig_in_index = board_dig_in_index + 60;

    end

    % Make sure we have read exactly the right amount of data.
    bytes_remaining = filesize - ftell(fid);
    if (bytes_remaining ~= 0)
        %error('Error: End of file not reached.');
    end

    % Close data file.
    fclose(fid);


    % Extract digital input channels to separate variables.
    for i=1:num_board_dig_in_channels
       mask = 2^(board_dig_in_channels(i).native_order) * ones(size(board_dig_in_raw));
       board_dig_in_data(i, :) = (bitand(board_dig_in_raw, mask) > 0);
    end

    % Scale voltage levels appropriately.
    amplifier_data = 0.195 * (amplifier_data - 32768); % units = microvolts
    aux_input_data = 37.4e-6 * aux_input_data; % units = volts
    supply_voltage_data = 74.8e-6 * supply_voltage_data; % units = volts
    board_adc_data = 50.354e-6 * board_adc_data; % units = volts
    temp_sensor_data = temp_sensor_data / 100; % units = deg C

    % Check for gaps in timestamps.
    num_gaps = sum(diff(t_amplifier) ~= 1);
    if (num_gaps == 0)
    else
        fprintf(1, 'Warning: %d gaps in timestamp data found.  Time scale will not be uniform!\n', ...
            num_gaps);
    end

    % Scale time steps (units = seconds).
    t_amplifier = t_amplifier / sample_rate;
    t_aux_input = t_amplifier(1:4:end);
    t_supply_voltage = t_amplifier(1:60:end);
    t_board_adc = t_amplifier;
    t_dig_in = t_amplifier;
    t_temp_sensor = t_supply_voltage;

    % If notch filtering was requested, apply it here:
    if (notch_filter_frequency > 0)
        %disp(['Applying Notch Filter of ',notchfreq]);
        for i=1:num_amplifier_channels
            amplifier_data(i,:) = ...
                notch_filter(amplifier_data(i,:), sample_rate, notch_filter_frequency, 10);
        end
    end

    % Now that we have the whole file we select the parts we need.
    % First we select the datastreams requested, then select the data range
    % requested. With every step we check whether we do have the data in
    % the file actually. If something is requested, but not included in the
    % file, a warning is displayed in the commandline.
    
    if nrstreamsrequested==0    %Nothing specified, all output requested
        % Output order:
        % amplifier channels => auxiliary channels => ADC channels => Digital
        % channels => volts => temperature
        output = {...
            'ampch' [1:size(amplifier_data,1)] ...
            'auxch' [1:size(aux_input_data,1)] ...
            'ADCch' [1:size(board_adc_data,1)] ...
            'DIGch' [1:size(board_dig_in_data,1)] ...
            'volt' 'yes' ...
            'tempch' 'yes'...
            };
    else
        output = cell(1,1);
        i=1;
        if sum(cellfun(@isequal,varargin,repmat({'ampch'},size(varargin))))
            output{1,i} = 'ampch';
            output{1,i+1} = channellist;
            i=i+2;
        end
        if sum(cellfun(@isequal,varargin,repmat({'auxch'},size(varargin))))
            output{1,i} = 'auxch';
            output{1,i+1} = aux;
            i=i+2;
        end
        if sum(cellfun(@isequal,varargin,repmat({'ADCch'},size(varargin))))
            output{1,i} = 'ADCch';
            output{1,i+1} = ADCchannels;
            i=i+2;
        end
        if sum(cellfun(@isequal,varargin,repmat({'DIGch'},size(varargin))))
            output{1,i} = 'DIGch';
            output{1,i+1} = digitalchannels;
            i=i+2;
        end
        if sum(cellfun(@isequal,varargin,repmat({'volt'},size(varargin))))
            output{1,i} = 'volt';
            output{1,i+1} = supplyvolt;
            i=i+2;
        end
        if sum(cellfun(@isequal,varargin,repmat({'tempch'},size(varargin))))
            output{1,i} = 'tempch';
            output{1,i+1} = temperature;
            i=i+2;
        end
    end
    for arg=1:2:length(output)
        switch (output{arg})
            case 'ampch'
                if size(amplifier_data,1)>0
                    amplifier_channels = amplifier_channels(1,output{arg+1});
                    amplifier_data = amplifier_data(output{arg+1},:);
                    ts_amp = timeseries;
                    ts_amp.time = t_amplifier;
                    ts_amp.data = amplifier_data';
                    if range ~=0
                        ts_amp = selecttime(ts_amp,range);
                    end
                    ts_amp.DataInfo.Units = 'uV';
                    ts_amp.TimeInfo.Units = 'seconds';
                    varargout{arg} = ts_amp;
                    varargout{arg+1} = amplifier_channels;
                else
                    disp('WARNING: No amplifier channels found in file!')
                end
            case 'auxch'
                if size(aux_input_data,1)>0
                    aux_input_channels = aux_input_channels(1,output{arg+1});
                    aux_input_data = aux_input_data(output{arg+1},:);
                    ts_aux = timeseries;
                    ts_aux.time = t_aux_input;
                    ts_aux.data = aux_input_data';
                    if range~=0
                        ts_aux = selecttime(ts_aux,range);
                    end
                    ts_aux.DataInfo.Unit = 'uV';
                    ts_aux.TimeInfo.Units = 'seconds';
                    varargout{arg} = ts_aux;
                    varargout{arg+1} = aux_input_channels;
                else
                    disp('WARNING: No auxiliary inputs found in file!')
                end
            case 'ADCch'
                if size(board_adc_data,1)>0
                    board_adc_channels = board_adc_channels(1,output{arg+1});
                    board_adc_data = board_adc_data(output{arg+1},:);
                    ts_board_adc = timeseries;
                    ts_board_adc.time = t_board_adc;
                    ts_board_adc.data = board_adc_data';
                    if range ~=0
                        ts_board_adc = selecttime(ts_board_adc,range);
                    end
                    ts_board_adc.DataInfo.Unit = 'uV';
                    ts_board_adc.TimeInfo.Units = 'seconds';
                    varargout{arg} = ts_board_adc;
                    varargout{arg+1} = board_adc_channels;
                else
                    disp('WARNING: No board ADC channels found in file!');
                end
            case 'DIGch'
                if size(board_dig_in_data,1)>0
                    board_dig_in_channels = board_dig_in_channels(1,output{arg+1});
                    board_dig_in_data = board_dig_in_data(output{arg+1},:);
                    ts_dig_in = timeseries;
                    ts_dig_in.time = t_amplifier;
                    ts_dig_in.data = board_dig_in_data';
                    if range ~=0
                        ts_dig_in = selecttime(ts_dig_in,range);
                    end
                    ts_dig_in.TimeInfo.Units = 'seconds';
                    varargout{arg} = ts_dig_in;
                    varargout{arg+1} = board_dig_in_channels;
                else
                    disp('WARNING: No board digital in channels found in file!');
                end
            case 'volt'
                if size(supply_voltage_data,1)>0
                    ts_volt = timeseries;
                    ts_volt.time = t_supply_voltage;
                    ts_volt.data = supply_voltage_data';
                    if range ~=0
                        ts_volt = selecttime(ts_volt,range);
                    end
                    ts_volt.TimeInfo.Units = 'seconds';
                    varargout{arg} = ts_volt;
                    varargout{arg+1} = supply_voltage_channels;
                else
                    disp('WARNING: No supply voltage data found in file!');
                end
            case 'tempch'
                if size(temp_sensor_data,1)>0
                    ts_temp = timeseries;
                    ts_temp.time = t_temp_sensor;
                    ts_temp.data = temp_sensor_data';
                    if range ~= 0
                        ts_temp = selecttime(ts_temp,range);
                    end
                    ts_temp.TimeInfo.Units = 'seconds';
                    varargout{arg} = ts_temp;
                    varargout{arg+1} = '1';
                else
                    disp('WARNING: No temperature data found in file!');
                end
        end
    end
 
return


function new = selecttime(old,range)
% Enter a timeseries and a range.
% Returns a new timeseries according to range.
% Range should be a 1x2 matrix with [start end]
new = timeseries;
data = old.data(old.time>range(1,1),:);
time = old.time(old.time>range(1,1));
data = data(time<range(1,2),:);
time = time(time<range(1,2));
new.data = data;
new.time = time;


return

function a = fread_QString(fid)

% a = read_QString(fid)
%
% Read Qt style QString.  The first 32-bit unsigned number indicates
% the length of the string (in 16-bit unicode characters).  If this
% number equals 0xFFFFFFFF, the string is null.

a = '';
length = fread(fid, 1, 'uint32');
if length == hex2num('ffffffff')
    return;
end
% convert length from bytes to 16-bit unicode words
length = length / 2;

for i=1:length
    a(i) = fread(fid, 1, 'uint16');
end

return


function s = plural(n)

    % s = plural(n)
    % 
    % Utility function to optionally plurailze words based on the value
    % of n.

    if (n == 1)
        s = '';
    else
        s = 's';
    end

return

function out = notch_filter(in, fSample, fNotch, Bandwidth)

    % out = notch_filter(in, fSample, fNotch, Bandwidth)
    %
    % Implements a notch filter (e.g., for 50 or 60 Hz) on vector 'in'.
    % fSample = sample rate of data (in Hz or Samples/sec)
    % fNotch = filter notch frequency (in Hz)
    % Bandwidth = notch 3-dB bandwidth (in Hz).  A bandwidth of 10 Hz is
    %   recommended for 50 or 60 Hz notch filters; narrower bandwidths lead to
    %   poor time-domain properties with an extended ringing response to
    %   transient disturbances.
    %
    % Example:  If neural data was sampled at 30 kSamples/sec
    % and you wish to implement a 60 Hz notch filter:
    %
    % out = notch_filter(in, 30000, 60, 10);

    tstep = 1/fSample;
    Fc = fNotch*tstep;

    L = length(in);

    % Calculate IIR filter parameters
    d = exp(-2*pi*(Bandwidth/2)*tstep);
    b = (1 + d*d)*cos(2*pi*Fc);
    a0 = 1;
    a1 = -b;
    a2 = d*d;
    a = (1 + d*d)/2;
    b0 = 1;
    b1 = -2*cos(2*pi*Fc);
    b2 = 1;
    out = zeros(size(in));
    out(1) = in(1);  
    out(2) = in(2);
    % (If filtering a continuous data stream, change out(1) and out(2) to the
    %  previous final two values of out.)

    % Run filter
    for i=3:L
        out(i) = (a*b2*in(i-2) + a*b1*in(i-1) + a*b0*in(i) - a2*out(i-2) - a1*out(i-1))/a0;
    end
return
