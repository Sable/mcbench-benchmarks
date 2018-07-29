function [h_air,air_info] = load_air(airpar)
%--------------------------------------------------------------------------
% Load room impulse responses from the AIR database
%--------------------------------------------------------------------------
% Details of the measured room impulse responses can be found in the
% corresponding papers:
% (1)
% M. Jeub, M. Schaefer, and P. Vary
% "A Binaural Room Impulse Response Database for the Evaluation of
% Dereverberation Algorithms", in Proc. of 16th International Conference on
% Digital Signal Processing (DSP), Santorini, Greece, 2009
% (2)
% M. Jeub, M. Schaefer, H. Krueger, C. Nelke, C. Beaugeant, and P. Vary:
% "Do We Need Dereverberation for Hand-Held Telephony?,"
% in Proc. of International Congress on Acoustics (ICA), Sydney, Australia,
% Aug. 2010
% 
% Details of the latest recordings at the Aula Carolina are available
% on the IND website http://www.ind.rwth-aachen.de/air
%--------------------------------------------------------------------------
% SYNTAX: [h_air,air_info] = load_air(airpar)
%
% INPUT:
%   airpar          Parameter struct:
%       fs          Sampling frequency
%       rir_type    Type of impulse response
%                   '1': binaural (with/without dummy head)
%                         acoustical path: loudspeaker -> microphones
%                         next to the pinna
%                   '2': dual-channel (with mock-up phone)
%                        acoustical path: artificial mouth of dummy head
%                        -> dual-microphone mock-up at HHP or HFRP
%       room        Room type
%                   1,2,..,11:  'booth','office','meeting','lecture',
%                                'stairway','stairway1','stairway2',
%                                'corridor','bathroom','lecture1',
%                                'aula_carolina'
%                   Available rooms for (1) binaural: 1,2,3,4,5,11
%                                       (2) phone: 2,3,4,6,7,8,9,10
%       channel     Select channel
%                   '0': right; '1': left
%       head        Select RIR with or without dummy head
%                   (for 'rir_type=1' only)
%                   '0': no dummy head; '1': with dummy head
%       phone_pos   Position of mock-up phone (for 'rir_type=2' only)
%                   '1': HHP (Hand-held), '2': HFRP (Hands-free)
%       rir_no      RIR number (increasing distance, for 'rir_type=1' only)
%                       Booth:    {0.5m, 1m, 1.5m}
%                       Office:   {1m, 2m, 3m}
%                       Meeting:  {1.45m, 1.7m, 1.9m, 2.25m, 2.8m}
%                       Lecture:  {2.25m, 4m, 5.56m, 7.1m, 8.68m, 10.2m}
%                       Stairway: {1m, 2m, 3m}
%                       Aula Carolina: {1m, 2m, 3m, 5m, 15m, 20m}
%       azimuth     Azimuth angle (0° left, 90° frontal, 180° right)
%                       for 'rir_type=1' & 'room=5' -> 0:15:180
%                       for 'rir_type=1' & 'room=11'& distance=3 ->0:45:180
%
% OUTPUT:
%       h_air       Impulse response
%       air_info    Additional information about the loaded RIR
%--------------------------------------------------------------------------
% (c) 2009-2011 RWTH Aachen University, Germany,
%     Marco Jeub, jeub@ind.rwth-aachen.de
%--------------------------------------------------------------------------
% Version history:
% 03.01.09 - First official release (MJ)
% 03.08.10 - Update for mock-up phone RIRs (MJ)
% 05.07.11 - Integration of Aula Carolina measurements room=11 (MJ)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Check for input arguments
%--------------------------------------------------------------------------
if nargin < 1, error('load_air: not enough input arguments');end;

%--------------------------------------------------------------------------
% Compose file name for load routine
%--------------------------------------------------------------------------
switch airpar.rir_type
    case 1
        rir_string = 'binaural';
    case 2
        rir_string = 'phone';
        % Phone Position
        switch airpar.phone_pos
            case 1
                pos_string = 'hhp';
            case 2
                pos_string = 'hfrp';
        end;
    otherwise
        error('load_air: RIR type not supported / does not exist');
end;
switch airpar.room
    case 1
        room_string = 'booth';
    case 2
        room_string = 'office';
    case 3
        room_string = 'meeting';
    case 4
        room_string = 'lecture';
    case 5
        room_string = 'stairway';
    case 6
        room_string = 'stairway1';
    case 7
        room_string = 'stairway2';
    case 8
        room_string = 'corridor';
    case 9
        room_string = 'bathroom';
    case 10
        room_string = 'lecture1';
    case 11
        room_string = 'aula_carolina';
    otherwise
        error('load_air: room type not supported / does not exist');
end;
% Compose file name
if airpar.rir_type == 1 % binaural
    switch airpar.room
        case 5  % 'stairway1' with varying azimuth angles
            file_name=['air_binaural_',room_string,'_',...
                num2str(airpar.channel),'_',num2str(airpar.head)...
                ,'_',num2str(airpar.rir_no),'_',num2str(airpar.azimuth)];
        case 11 % Aula Carolina
            if ~isfield(airpar,'mic_type')
                airpar.mic_type = 3;
            end;
            file_name=['air_binaural_',room_string,'_',...
                num2str(airpar.channel),'_',num2str(airpar.head)...
                ,'_',num2str(airpar.rir_no),'_',num2str(airpar.azimuth),'_',num2str(airpar.mic_type)];
        otherwise
            file_name=['air_binaural_',room_string,'_',...
                num2str(airpar.channel),'_',num2str(airpar.head)...
                ,'_',num2str(airpar.rir_no)];
    end;
else % phone
    file_name=['air_phone_',room_string,'_',pos_string,'_',...
        num2str(airpar.channel)];
end;
%--------------------------------------------------------------------------
% load RIR
%--------------------------------------------------------------------------
file_name = [file_name,'.mat'];
if ~(exist(file_name,'file'))
    error('load_air: file <%s> does not exist\n',file_name);
end;
load(file_name);
%--------------------------------------------------------------------------
% Transpose
%--------------------------------------------------------------------------
if size(h_air,1)~=1
    h_air = h_air';
end;
%--------------------------------------------------------------------------
% Resample if necessary
%--------------------------------------------------------------------------
if air_info.fs ~= airpar.fs
    h_air=resample(h_air,airpar.fs,air_info.fs);
    air_info.fs=airpar.fs;
end;
%--------------------------------------------------------------------------