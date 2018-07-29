function sac_sun2pc_mat(filename)
% function sac_sun2pc_mat('filename')
%
% reads the SAC binary files from the SUN platform and creates a .mat file
%    that consists of 
%    1. a structure, H, that contains all the header information and 
%    2. a vector, X, that contains the waveform.
%
% The input file 'filename' must be either a sac file with extension .sac
%   or a path. In the latter case all sac files in this path are converted.
% The path must be the full path, i.e., 'C:\Data\920611_001538_00_405'. 
%   The mat files are saved in the folder, in which the original .sac file
%   exists.
%
% The SAC format files and names of variables are based on documentation, I
%   have found in the internet. Some SAC Header variables that are 'not 
%   currently used' (according to the documentations, I found) are in comments, 
%   whereas others are ommitted.
%
% This file has been tested (not thoroughly, though) using Matlab 6.5 but should 
%   be working on all other previous Matlab 6 or 5 versions as well.
% 
% Note that the file is NOT guaranteed to work perfectly, so please check
%   your results.
%
% Please send any comments or corrections to csar@auth.gr
% 
% SAC_SUN2PC_MAT written by C. D. Saragiotis on August 14th, 2003


F = 4-1; % float byte-size minus 1;
K = 8-1; % alphanumeric byte-size minus 1
L = 4-1; % long integer byte-size minus 1;

if isdir(filename)
    dirName = filename;
    dirContents = dir(filename);
    items = size(dirContents,1);
    eval(['cd ' filename])
    for j=1:items
        if length(dirContents(j).name)>4
            if sum(lower(dirContents(j).name(length(dirContents(j).name)-3:length(dirContents(j).name)))=='.sac')==4
                disp(dirContents(j).name)
                sourceFileId = fopen(dirContents(j).name,'rb');
                [X,H] = readSacFile(sourceFileId,F,K,L);
                st = fclose(sourceFileId);
                eval(['save ' dirContents(j).name(1:length(dirContents(j).name)-4) ' X H']);
                clear X,H;
            end
        end
    end
else 
    if sum(lower(filename(length(filename)-3:length(filename)))=='.sac')==4
            sourceFileId = fopen(filename,'rb');
            [X,H] = readSacFile(sourceFileId,F,K,L);
            st = fclose(sourceFileId);
            eval(['save ' filename(1:length(filename)-4) ' X H']);
    else
        error('The extension of the filename must be ''.sac'' or ''.SAC''. Try again...')
    end
end

function [data,header] = readSacFile(fid,F,K,L)

header = readSacHeader(fid,F,K,L);
npts = header(1).NPTS;
data = readSacData(fid,npts,F+1)';
   


function hdr = readSacHeader(fileId,F,K,L)
% hdr = readSacHeader(FID)
% sacReadAlphaNum reads the SAC-format header fields and returns most of them. 
%    It doesnot return the UNUSED and INTERNAL fields and those fields 
%    'not currently' according to documentation. Most of the fields not returned are 
%    placed in comments.
%    
%    The output variable, 'hdr' is a structure, whose fields are the fields
%    of the standard SAC header. For example hdr(1).NPTS returns the number
%    of points per data component.
%    
%    Created by C. D. Saragiotis, August 5th, 2003
headerBytes = 632;
chrctr = fread(fileId,headerBytes,'uchar');
chrctr = chrctr(:)';
hdr = struct([]);
% SAC header defaults
%INTERNAL4 = 6;
%INTERNAL5 = 0;
%INTERNAL6 = 0;
%UNUSED27 = 'FALSE';

% Read floats
hdr(1).DELTA  = sacReadFloat(chrctr(1:1+F)); % increment between evenly spaced samples
hdr(1).DEPMIN = sacReadFloat(chrctr(5:5+F)); % MINimum value of DEPendent variable
hdr(1).DEPMAX = sacReadFloat(chrctr(9:9+F)); % MAXimum value of DEPendent variable
% (not currently used) SCALE  = sacReadFloat(chrctr(13:13+F)); % Mult SCALE factor for dependent variable
hdr(1).ODELTA = sacReadFloat(chrctr(17:17+F)); % Observd increment if different than DELTA
hdr(1).B      = sacReadFloat(chrctr(21:21+F)); % Begining value of the independent variable
hdr(1).E      = sacReadFloat(chrctr(25:25+F)); % Ending value of the independent variable
hdr(1).O      = sacReadFloat(chrctr(29:29+F)); % event Origin time
hdr(1).A      = sacReadFloat(chrctr(33:33+F)); % first Arrival time

% Tn: user-defined Time-picks or markers n=1,2,...,9
% T(1)=T0, T(2)=T1, etc

% x = vec2mat(chrctr,F+1);
% X = sacReadFloat(x); 

hdr(1).T0 = sacReadFloat(chrctr(41:41+F)); hdr(1).T1 = sacReadFloat(chrctr(45:45+F)); 
hdr(1).T2 = sacReadFloat(chrctr(49:49+F)); hdr(1).T3 = sacReadFloat(chrctr(53:53+F)); 
hdr(1).T4 = sacReadFloat(chrctr(57:57+F)); hdr(1).T5 = sacReadFloat(chrctr(61:61+F)); 
hdr(1).T6 = sacReadFloat(chrctr(65:65+F)); hdr(1).T7 = sacReadFloat(chrctr(69:69+F)); 
hdr(1).T8 = sacReadFloat(chrctr(73:73+F)); hdr(1).T9 = sacReadFloat(chrctr(77:77+F)); 

hdr(1).F      = sacReadFloat(chrctr(81:81+F)); % Fini of event time

% RESPn: instrument RESPonse parameters n=1,2,...,9
% RESP(1)=RESP0, RESP(2)=RESP1, etc
% (not currently used) i = 85:F+1:121; RESP(1:10,1) = sacReadFloat(chrctr(i:i+F)); 

hdr(1).STLA   = sacReadFloat(chrctr(125:125+F)); % STation LAttitude
hdr(1).STLO   = sacReadFloat(chrctr(129:129+F)); % STation LOngtitude
hdr(1).STEL   = sacReadFloat(chrctr(133:133+F)); % STation ELevation
% (not currently used) STDP   = sacReadFloat(chrctr(137:137+F)); % STation DePth below surface 

hdr(1).EVLA   = sacReadFloat(chrctr(141:141+F)); % EVent LAttitude
hdr(1).EVLO   = sacReadFloat(chrctr(145:145+F)); % EVent LOngtitude
% (not currently used) EVEL   = sacReadFloat(chrctr(149:149+F)); % EVent ELevation
hdr(1).EVDP   = sacReadFloat(chrctr(153:153+F)); % EVent DePth below surface

% USERn: USER-defined-variable storage area, n=1,2,...,9
% user(1)=USER0, user(2)=USER1, etc
hdr(1).USER0 = sacReadFloat(chrctr(161:161+F)); hdr(1).USER1 = sacReadFloat(chrctr(165:165+F)); 
hdr(1).USER2 = sacReadFloat(chrctr(169:169+F)); hdr(1).USER3 = sacReadFloat(chrctr(173:173+F)); 
hdr(1).USER4 = sacReadFloat(chrctr(177:177+F)); hdr(1).USER5 = sacReadFloat(chrctr(181:181+F)); 
hdr(1).USER6 = sacReadFloat(chrctr(185:185+F)); hdr(1).USER7 = sacReadFloat(chrctr(189:189+F)); 
hdr(1).USER8 = sacReadFloat(chrctr(193:193+F)); hdr(1).USER9 = sacReadFloat(chrctr(197:197+F)); 

hdr(1).DIST   = sacReadFloat(chrctr(201:201+F)); % station to event DISTance (km)
hdr(1).AZ     = sacReadFloat(chrctr(205:205+F)); % event to station AZimuth (degrees)
hdr(1).BAZ    = sacReadFloat(chrctr(209:209+F)); % station to event AZimuth (degrees)
hdr(1).GCARC  = sacReadFloat(chrctr(213:213+F)); % station to event Great Circle ARC length (degrees)

hdr(1).DEPMEN = sacReadFloat(chrctr(225:225+F)); % MEaN value of DEPendent variable
hdr(1).CMPAZ  = sacReadFloat(chrctr(229:229+F)); % CoMPonent AZimuth (degrees clockwise from north)
hdr(1).CMPINC = sacReadFloat(chrctr(233:233+F)); % CoMPonent INCident angle (degrees from vertical)

% Read long integers
hdr(1).NZYEAR = sacReadLong(chrctr(281:281+L)); % GMT YEAR
hdr(1).NZJDAY = sacReadLong(chrctr(285:285+L)); % GMT julian DAY
hdr(1).NZHOUR = sacReadLong(chrctr(289:289+L)); % GMT HOUR
hdr(1).NZMIN  = sacReadLong(chrctr(293:293+L)); % GMT MINute
hdr(1).NZSEC  = sacReadLong(chrctr(297:297+L)); % GMT SECond
hdr(1).NZMSEC = sacReadLong(chrctr(301:301+L)); % GMT MilliSECond

hdr(1).NPTS   = sacReadLong(chrctr(317:317+L)); % Number of PoinTS per data component

% Some SAC defaults
hdr(1).IFTYPE = 'TIME SERIES FILE'; % File TYPE
%IFTYPE  = sacReadLong(chrctr(341:341+L)) % File TYPE
hdr(1).IDEP = 'UNKNOWN'; % type of DEPendent variable
%IDEP    = sacReadLong(chrctr(345:345+L)) % type of DEPendent variable
hdr(1).IZTYPE = 'BEGIN FILE (B)'; % reference time equivalence
%IZTYPE  = sacReadLong(chrctr(349:349+L)) % reference time equivalence

% (not currently used) IINST  = sacReadLong(chrctr(357:357+L)) % type of recording INSTrument

%% Again read floats
% (not currently used) ISTREG = sacReadFloat(chrctr(361:361+F)); % STation geographic REGion
% (not currently used) IEVREG = sacReadFloat(chrctr(365:365+F)); % EVent geographic REGion
% (not currently used) IQUAL  = sacReadFloat(chrctr(373:373+F)); % QUALity of data
% (not currently used) ISYNTH = sacReadFloat(chrctr(377:377+F)); % SYNTHetic data flag

% SAC defaults
hdr(1).IEVTYPE = 'IUNKN';
%IEVTYPE= sacReadFloat(chrctr(369:369+F)); % EVent TYPE
hdr(1).LEVEN = 'TRUE';  % true, if data are EVENly spaced (required)
%LEVEN= sacReadFloat(chrctr(421:521+F)); % true, if data are EVENly spaced (required)
hdr(1).LPSPOL = 'FALSE'; % true, if station components have a PoSitive POLarity
%LPSPOL= sacReadFloat(chrctr(425:425+F)); % true, if station components have a PoSitive POLarity
hdr(1).LOVROK = 'FALSE'; % true, if it is OK to OVeRwrite this file in disk
%LOVROK= sacReadFloat(chrctr(429:429+F)); % true, if it is OK to OVeRwrite this file in disk
hdr(1).LCALDA = 'TRUE'; % true, if DIST, AZ, BAZ and GCARC are to be calculated from station and event coordinates
%LCALDA= sacReadFloat(chrctr(433:433+F)); % true, if DIST, AZ, BAZ and GCARC are to be calculated from station and event coordinates

% Read alphanumeric data
hdr(1).KSTNM  = sacReadAlphaNum(chrctr(441:441+K)); % STation NaMe
hdr(1).KEVNM  = sacReadAlphaNum(chrctr(449:449+2*(K+1)-1)); % EVent NaMe
hdr(1).KHOLE  = sacReadAlphaNum(chrctr(465:465+K)); % HOLE identification, if nuclear event
hdr(1).KO     = sacReadAlphaNum(chrctr(473:473+K)); % event Origin time identification
hdr(1).KA     = sacReadAlphaNum(chrctr(481:481+K)); % first Arrival time identification
% 
% % KTn: user-defined Time pick identifications, n=1,2,...,9
% % KT0=KT(1), KT1=kt(2), etc
% i = 489:F+1:561; kt(1:10,1) = sacReadFloat(chrctr(i:i+K)); 
% hdr(1).KT0 = kt(1); hdr(1).KT1 = kt(2); hdr(1).KT2 = kt(3); hdr(1).KT3 = kt(4); hdr(1).KT4 = kt(5); 
% hdr(1).KT5 = kt(6); hdr(1).KT6 = kt(7); hdr(1).KT7 = kt(8); hdr(1).KT8 =
% kt(9); hdr(1).KT9 = kt(10); 

hdr(1).KF     = sacReadAlphaNum(chrctr(569:569+K)); % Fini identification
hdr(1).KUSER0 = sacReadAlphaNum(chrctr(577:577+K)); % USER-defined variable storage area
hdr(1).KUSER1 = sacReadAlphaNum(chrctr(585:585+K)); % USER-defined variable storage area
hdr(1).KUSER2 = sacReadAlphaNum(chrctr(593:593+K)); % USER-defined variable storage area
hdr(1).KCMPNM = sacReadAlphaNum(chrctr(601:601+K)); % CoMPonent NaMe
hdr(1).KNETWK = sacReadAlphaNum(chrctr(609:609+K)); % name of seismic NETWorK
hdr(1).KDATRD = sacReadAlphaNum(chrctr(617:617+K)); % DATa Recording Date onto the computer
hdr(1).KINST  = sacReadAlphaNum(chrctr(625:625+K)); % generic name of recording INSTrument


function X = readSacData(fid,N,F)
% function data = readSacData('filename',NPTS,floatByteSize)
headerBytes = 632;
% Syntax: [A, COUNT] = FREAD(FID,SIZE,PRECISION)
chrctr = fread(fid,N*F,'uchar');
x = vec2mat(chrctr,F);
X = sacReadFloat(x); 
%    if rem(i,1000)==0, disp(i),end


function lNumber = sacReadLong(cb)
% reads long integers (4 bytes long)
% cb is the character buffer
cb = cb(:);
lNumber = (256.^(3:-1:0))*cb;
if lNumber == -12345, lNumber = []; end

function fNumber = sacReadFloat(cb)
% reads floats (4 bytes long)
% cb is the character buffer
C = size(cb,1);
stringOfBitSequence = [dec2bin(cb(:,1),8) dec2bin(cb(:,2),8) dec2bin(cb(:,3),8) dec2bin(cb(:,4),8)];
bitSequence = stringOfBitSequence=='1';
fSign = -2*bitSequence(:,1)+1;
fExp = bitSequence(:,2:9)*(2.^(7:-1:0)') - 127;
fMantissa = [ones(C,1) bitSequence(:,10:32)]*(2.^(0:-1:-23)');
fNumber = fSign.*fMantissa.*(2.^fExp);
isZeroCheck = sum(bitSequence')'==0;
fNumber = fNumber.*(~isZeroCheck);
if fNumber == -12345, fNumber = ' '; end


function alphaNum = sacReadAlphaNum(cb)
% reads alphanumeric data (8 or 16 bytes long). If it cb is empty, it returns a ' ' 
% cb is the character buffer
K = max(size(cb));
alphaNumTemp = char(cb);
if K == 8
    if alphaNumTemp == '-12345  ' 
        alphaNum = ' ';
    else
        alphaNum = alphaNumTemp;
    end
else
    if K == 16
        if alphaNumTemp == '-12345   -12345 ' 
            alphaNum = ' ';
        else
            alphaNum = alphaNumTemp;
        end
    end
end

