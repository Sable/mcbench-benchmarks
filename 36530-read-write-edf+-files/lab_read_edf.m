% lab_read_edf() - read eeg data in EDF+ format.
%
% Orignal Code-file:
% Jeng-Ren Duann, CNL/Salk Inst., 2001-12-21
%
% Modifications:
% 03-21-02 editing hdr, add help -ad 
% 09-17-12 FHatz Neurology Basel (Support for edf+)
%
% Usage: 
%    >> [data,header] = read_edf(filename);
%
% Input:
%    filename - file name of the eeg data
% 
% Output:
%    data   - eeg data in (channel, timepoint)
%    header - structured information about the read eeg data
%      header.events - events (structure: .POS .DUR .TYP)
%      header.numtimeframes - length of EEG data
%      header.samplingrate = samplingrate
%      header.numchannels - number of channels
%      header.numauxchannels - number of non EEG channels (only ECG channel is recognized)
%      header.channels - channel labels
%      header.year - timestamp recording
%      header.month - timestamp recording
%      header.day - timestamp recording
%      header.hour - timestamp recording
%      header.minute - timestamp recording
%      header.second - timestamp recording
%      header.ID - EEG number
%      header.technician - responsible investigator or technician
%      header.equipment - used equipment
%      header.subject.ID - local patient identification
%      header.subject.sex - M or F
%      header.subject.name - patients name
%      header.subject.year - birthdate
%      header.subject.month - birthdate
%      header.subject.day - birthdate
%      header.aux - auxillary channels / samplingrates auf auxillary channels
%      header.hdr - original header

function [data,header,cfg] = lab_read_edf(filename,cfg)

if ~exist('cfg','var')
    cfg = [];
end

if nargin < 1
    help readedf;
    return;
end;
    
fp = fopen(filename,'r','ieee-le');
if fp == -1,
  error('File not found ...!');
end

hdr.intro = setstr(fread(fp,256,'uchar')');
hdr.length = str2num(hdr.intro(185:192));
hdr.records = str2num(hdr.intro(237:244));
hdr.duration = str2num(hdr.intro(245:252));
hdr.channels = str2num(hdr.intro(253:256));
hdr.channelname = setstr(fread(fp,[16,hdr.channels],'char')');
hdr.transducer = setstr(fread(fp,[80,hdr.channels],'char')');
hdr.physdime = setstr(fread(fp,[8,hdr.channels],'char')');
hdr.physmin = str2num(setstr(fread(fp,[8,hdr.channels],'char')'));
hdr.physmax = str2num(setstr(fread(fp,[8,hdr.channels],'char')'));
hdr.digimin = str2num(setstr(fread(fp,[8,hdr.channels],'char')'));
hdr.digimax = str2num(setstr(fread(fp,[8,hdr.channels],'char')'));
hdr.prefilt = setstr(fread(fp,[80,hdr.channels],'char')');
hdr.numbersperrecord = str2num(setstr(fread(fp,[8,hdr.channels],'char')'));

if isempty(hdr.length)
    disp('   Abort edf-read: no valid edf-file')
    data = [];
    header = [];
    return
end
fseek(fp,hdr.length,-1);
data = fread(fp,'int16');
fclose(fp);
clearvars fp

header.hdr = hdr;
header.samplingrate = hdr.numbersperrecord(1) / hdr.duration;
header.numchannels = hdr.channels;
header.numauxchannels = 0;
header.channels = hdr.channelname;
tmp = textscan(hdr.intro(89:168),'%s');
tmp = tmp{1,1};
[header.year, header.month, header.day] = datevec(tmp(2,1));
header.hour = str2num(hdr.intro(177:178));
header.minute = str2num(hdr.intro(180:181));
header.second = str2num(hdr.intro(183:184));
header.ID = tmp{3,1};
header.technician = tmp{4,1};
header.equipment = tmp{5,1};
tmp = textscan(hdr.intro(9:88),'%s');
tmp = tmp{1,1};
header.subject.ID = tmp{1,1};
header.subject.sex = tmp{2,1};
header.subject.name = tmp{4,1};
if ~strcmp(tmp(3,1),'X')
    [header.subject.year, header.subject.month, header.subject.day] = datevec(tmp(3,1));
end
clearvars tmp

% reshape data
data = reshape(data,sum(hdr.numbersperrecord),hdr.records);

% Look for annotations
m = size(hdr.channelname,1);
header.events.TYP = [];
header.events.POS = [];
header.events.DUR = [];
header.events.OFF = [];
while strcmp(hdr.channelname(m,1:15),'EDF Annotations')
    header.numchannels = header.numchannels -1;
    header.channels = header.channels(1:end-1,:);
    eventstmp = data((end - hdr.numbersperrecord(m) + 1):end,:);
    data = data(1:end-hdr.numbersperrecord(m),:);
    for i = 1:hdr.records
        eventsall(i,:) = typecast(int16(eventstmp(:,i)),'uint8')';
        tmp = find(eventsall(i,:) == 20);
        numberstops = tmp(eventsall(i,tmp+1) == 0);
        eventsall(i,eventsall(i,:) == 32) = 95;
        eventsall(i,eventsall(i,:) == 20) = 32;
        eventsall(i,eventsall(i,:) == 21) = 32;
        if numberstops > 0
            tmp = textscan(native2unicode(eventsall(i,1:numberstops(1))),'%s');
            tmp = tmp{1,1};
            time_stamp(i) = str2double(tmp(1,1))*header.samplingrate + 1;
        end
        if size(numberstops,2) > 1
            for j = 2:size(numberstops,2)
                tmp = textscan(native2unicode(eventsall(i,numberstops(1,j-1)+2:numberstops(1,j))),'%s');
                tmp = tmp{1,1};
                header.events.POS = [header.events.POS int64(str2double(tmp(1,1))*header.samplingrate)];
                header.events.OFF = [header.events.OFF int64(0)];
                if str2double(tmp(2,1)) > 0
                    header.events.DUR = [header.events.DUR int64(str2double(tmp(2,1))*header.samplingrate)];
                    header.events.TYP = [header.events.TYP tmp(3,1)];
                else
                    header.events.DUR = [header.events.DUR 1];
                    header.events.TYP = [header.events.TYP tmp(2,1)];
                end
            end
        end
    end
    clearvars i j tmp eventstmp eventsall numberstops
    m = m - 1;
end

if size(header.events.POS,2) > 1
    tmp = cat(1,header.events.POS,(1:size(header.events.POS,2)));
    tmp = sortrows(tmp',1)';
    header.events.POS = header.events.POS(1,tmp(2,:));
    header.events.DUR = header.events.DUR(1,tmp(2,:));
    header.events.OFF = header.events.OFF(1,tmp(2,:));
    header.events.TYP = header.events.TYP(1,tmp(2,:));
    clearvars tmp
end

if isempty(header.events.TYP)
    header = rmfield(header,'events');
end

auxchannel = 0;
while m > 1 && ~(sum(hdr.numbersperrecord(1:m)) == hdr.numbersperrecord(1)*m)
    header.numchannels = header.numchannels -1;
    header.channels = header.channels(1:end-1,:);
    header.aux{auxchannel+1,1} = reshape(data((end - hdr.numbersperrecord(j) + 1):end,:),[1 (hdr.numbersperrecord(j)*size(data,2))]);
    header.aux{auxchannel+1,2} = hdr.numbersperrecord(j) / hdr.duration;
    data = data(1:end-hdr.numbersperrecord(j),:);
    m = m - 1;
    auxchannel = auxchannel + 1;
end

data = reshape(data,hdr.numbersperrecord(1),m,hdr.records);
if exist('time_stamp','var')
    tmp = zeros(m,max(time_stamp) + hdr.numbersperrecord(1) -1);
    time_stamp = round(time_stamp);
    for i=1:hdr.records,
        tmp(:,time_stamp(i):(time_stamp(i)+ hdr.numbersperrecord(1)-1)) = data(:,:,i)';
    end
    data = tmp;
    clearvars tmp
else
    data = permute(data,[2 1 3]);
    data = reshape(data,m,hdr.numbersperrecord(1)*hdr.records);
end

% Scale data
Scale = (hdr.physmax-hdr.physmin)./(hdr.digimax-hdr.digimin);
DC = hdr.physmin - Scale .* hdr.digimin;
Scale = Scale(1:size(data,1),:);
DC = DC(1:size(data,1),:);
tmp = find(Scale < 0);
Scale(tmp) = ones(size(tmp));
DC(tmp) = zeros(size(tmp));
clearvars tmp
data = (sparse(diag(Scale)) * data) + repmat(DC,1,size(data,2));

% Look for extra channel (ECG)
if strcmp(header.channels(end,1:3),'ECG')
    header.numauxchannels = 1;
    header.numdatachannels = header.numchannels -1;
else
    header.numdatachannels = header.numchannels;
end
header.numtimeframes = size(data,2);
header.version=[];
header.millisecond=0;
