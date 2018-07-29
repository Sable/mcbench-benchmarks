% ImReadNtf
% see also: nitfread, nitfinfo
function Img=ImReadNtf(NtfFnp)
% Copyright (c) 2013 by OU AEC and Curtis Cohenour (cohenour@ohio.edu), and Dave Lucking of UDRI. All Rights Reserved.
% 20130607 Jcc (Curtis Cohenour) original
% this file will read a compressed jpeg 2000 file.
% Modify to any other file type by changing the header search string and temporary file extenstion
%% set temp save file name. 
% TmpNtfJp2='R:\Temp\TmpNtf.jp2';
TmpNtfJp2='TmpNtf.jp2';
%% Read the Ntf file
fid=fopen(NtfFnp);
NtfRaw=fread(fid,'uint8=>uint8');
fclose(fid)
%% Look for Jpeg 2 header 00 00 00 0c 6a 50 
Hdr=uint8([hex2dec('00') hex2dec('00') hex2dec('00') hex2dec('0c') hex2dec('6a') hex2dec('50') ]');
[lNtfRaw,wNtfRaw]=size(NtfRaw);
for i=1:lNtfRaw
    b=i+5;
    kNtfRaw=NtfRaw(i:b,:); % get a 6 byte segment
    fHdr1=kNtfRaw==Hdr;    % check to see which bytes match
    fHdr2=all(fHdr1);      % check to see if all bytes match
    if fHdr2
        iHdr=i;            % Yes save location
        break              % ... and break
    end
end
%% write image to a temporary file
fid=fopen(TmpNtfJp2, 'w');
fwrite(fid, NtfRaw(iHdr:end));
fclose(fid)
%% read image using matlab imread
[Img xmap]=imread(TmpNtfJp2);
% %% debug plot
% figure(900)
% imagesc(Img);
% colormap gray
% %% try image cut from ntf
