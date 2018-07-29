function [data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf(filename,SecLoad,reshape)

% this function loads at least "SecLoad" seconds of EEG data from the
% specified bdf-file "filename". If all available data is needed, specify
% 'all' instead of "SecLoad" like this:
% [...] = eeg_read_bdf('test.bdf','all');
% EEg data is read from the first sample.
% "reshape" ('y' or 'n') specifies whether data must be reshaped (ActiveTwo
% by BioSemi 65 electrodes)... according to author's humble understanding.
%
% The outputs are:
% "data" - EEG data of size numChan by SecLoad*fs
% "numChan" - number of EEG channel (including the status channel)
% "labels" - EEG electrode labels
% "txt" - a string containg information about the subject entered wile
% recorging EEG
% "fs" - sampling frequency, Hz
% "gain" - gain factor, times
% "ChanDim" - Physical dimension of the EEG channels (for instance, uV)
% "prefiltering" - information about filters used during EEG recording
% 
% Note: for some reason, bdf format specifies separate sets of "fs",
% "gain", "ChanDim", and "prefiltering" for every EEG channel. This
% function returns these values for the first channel (electrode) only!
%
% Copyleft by Gleb Tcheslavski, gleb@vt.edu

if ~exist(filename,'file')
  error(['Specified file ' filename ' does not exist in MATLAB path.']);
end

idx = [1 34 5 40 13 50 21 58 27 64 7 42 15 52 23 60 38 48 31 47 32 18 55 10 45 16 53 8 43 33 37 30 26 63 3 36 2 35 25 62 4 39 12 49 20 57 6 41 9 44 14 51 17 54 22 59 19 56 11 46 24 61 28 29 65];

fid = fopen(filename);

fseek(fid,130,'bof');
txt = cellstr(char(fread(fid,54,'10*char'))');                 %user text

fseek(fid,236,'bof');
numRec = str2double(deblank(char(fread(fid,7,'1*char'))));     %number of data records

fseek(fid,244,'bof');
RecDur = str2double(deblank(char(fread(fid,3,'1*char'))));     %duration of a data record, sec

fseek(fid,252,'bof');
numChan = str2double(deblank(char(fread(fid,3,'1*char'))));     %number of EEG channels

fseek(fid,256,'bof');
labels = cellstr(deblank(char(fread(fid,[7,numChan],'7*char',9)')));     %EEG labels
if reshape == 'y'
    labels = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','T7','T8','P7','P8','Fz','Cz','Pz','Fcz','Cpz','Cp3','Cp4'...
        'Fc3' 'Fc4' 'Tp7' 'Tp8' 'Ft7' 'Ft8' 'Fpz' 'Afz' 'Poz' 'Po3' 'Po4' 'Af3' 'Af4' 'Af7' 'Af8' 'Po7' 'Po8' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2'...
        'F5' 'F6' 'Fc5' 'Fc6' 'C5' 'C6' 'Cp5' 'Cp6' 'P5' 'P6' 'Cp1' 'Cp2' 'Fc1' 'Fc2' 'P9' 'P10' 'Iz' 'Oz' 'Status'};
end

fseek(fid,256+numChan*136,'bof');
prefiltering = cellstr(char(fread(fid,25,'10*char'))');              %filters applied - need to check from this point

fseek(fid,256+numChan*96,'bof');
ChanDim = cellstr(deblank(char(fread(fid,5,'5*char'))'));           %Physical dimention of the channels (uV, for instance)

fseek(fid,256+numChan*216,'bof');
numSam = str2double(deblank(char(fread(fid,4,'1*char'))));          %number of samples in each record

fs = numSam/RecDur;                                                 %sampling frequency

fseek(fid,256+numChan*104,'bof');
Pmin = str2double(deblank(char(fread(fid,8,'1*char'))));            %physical min

fseek(fid,256+numChan*112,'bof');
Pmax = str2double(deblank(char(fread(fid,8,'1*char'))));            %physical max

fseek(fid,256+numChan*120,'bof');
Dmin = str2double(deblank(char(fread(fid,8,'1*char'))));            %digital min

fseek(fid,256+numChan*128,'bof');
Dmax = str2double(deblank(char(fread(fid,8,'1*char'))));            %digital max

gain = (Pmax-Pmin)/(Dmax-Dmin);                                      %gain factor

if SecLoad == 'all'                                                 %if all data needs to be loaded...
    RecsLoad = numRec;
else
    RecsLoad = ceil(SecLoad/RecDur);                                    %determine how many records need to be loaded
    if RecsLoad > numRec
        RecsLoad = numRec;
    end;
end

fseek(fid,256*(numChan+1),'bof');                                  %positions the pointer to the beginning of data
data = [];
for ind = 1:RecsLoad
    aux = fread(fid,[RecDur*numSam,numChan],'bit24')';
    if reshape == 'y'
        aux = aux(idx,:);
    end;
    data = [data, aux];
end;

fclose(fid);