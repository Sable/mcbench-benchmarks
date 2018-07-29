function [Channels,FileInfo]=importfamos(FullRawData)
%__________________________________________________________________________
% The sequnce importfamos.m was produced to convert imc raw data(*.raw;
% *.dat) to matlab data. Here, struct is used to manage the channel
% information.
%
% For more information of FAMOS file format, please see the
% manufacturer's website: http://www.imc-berlin.de
%
% Corresponding to Data Structure in Matlab, the channels are stored
% as struct struct: Channel + name (channel name)
%                           + comment 
%                           + data (channel Value) 
%                           + length 
%                           + yUnit 
%                           + t0 
%                           + dt(sampling period) 
%                           + xUnit
% Version history:
% Version 1 (2011.1.19); Current version only can deal with analog rawdata
% from imc devices. The digital and group function is ongoning and will be
% released in version 2.
%%-------------------------------------------------------------------------
% Author: Liang
% Danke.Liang@gmail.com
% Started on Dec.14, 2010
%__________________________________________________________________________
if nargin == 0;
    %[FamosName, FamosPath] = uigetfile({'*.raw';'*.dat'},'Select Famos Raw data');
   FullRawData = uigetfile({'*.raw';'*.dat'},'Select Famos Raw data');
    %pwd current path
    %filesep e.g "/" under windows os
%elseif nargin == 1; 
    %FamosPath = [pwd filesep];   
end

fid = fopen(FullRawData,'r');
KeyFlag={'|CF';'|Ck';'|NO';'|CT';'|CB';'|CI';'|CG';'|CD';'|NT';'|CZ';'|CC';'|CP';'|Cb';'|CR';'|ND';'|CN';'|CS';'|NU'};

disp(['Info: Read data @' datestr(now) ' from' ])
% disp([ ' ' FamosPath FamosName '...'])
disp([ ' ' FullRawData '...'])
%initiation
BinaryStart=0;
Str3='';
%while 
BinaryStart=FindBinaryStart(fid);
ChannelID=1;
Channel=struct('name','','comment','','data',[],'length',0,'yUnit','','t0','','dt','','xUnit','');  
FileInfo=struct('Origin','','Company','','Comment','','ChannelNums',[]);

%Struct TriggerTime
FlagCS='|CS';
fseek(fid, 1, 'bof');
 while strcmp(Str3,FlagCS)==0
     lastlocation=ftell(fid);
     tline=fgetl(fid);
     Str3=tline(1:3);
     switch (Str3)
         case KeyFlag(1)
         CFfini=ProcessCFandCK(tline);
         if CFfini==0
         Str3='|CS'; %force to exit while loop     
         end    
         case KeyFlag(3);
        [NOKeyOrigin,NOKeyCompany,NOKeyComment]=ProcessNO(tline);
            FileInfo.Origin=NOKeyOrigin;
            FileInfo.Company=NOKeyCompany;
            FileInfo.Comment=NOKeyComment;
         case KeyFlag(4);
         ProcessCT(tline);
          case KeyFlag(5);
         ProcessCBbig(tline);
         case KeyFlag(6);
         ProcessCI(tline);
         case KeyFlag(7);
         [CGNumberComponents,CGFieldType,CGDimension]=ProcessCG(tline);
         case KeyFlag(8);
         [CDSample, CDUnit]=ProcessCD(tline);
         case KeyFlag(9);
         TriggerTime = ProcessNT(tline);
         case KeyFlag(10);
         ProcessCZ(tline);
         case KeyFlag(11);
         KeyComponentIndex= ProcessCC(tline);
         case KeyFlag(12);
         [KyBufferRef,KeyBytes,KeyNumberFormat,KeySignBits]=ProcessCP(tline);
         case KeyFlag(13);
         [KeyBufferRefIndex,KeyBufferRefCb,KeyOffsetBufferInSamplesKey,KeyBufferFilledBytes]=ProcessCblittle(tline);
         case KeyFlag(14);
         [KeyTransformation,KeyCRfactor,KeyCRoffset,KeyUnit]=ProcessCR(tline);
         case KeyFlag(15);
         ProcessND();
         case KeyFlag(16);
             CurrentLocation=ftell(fid);
             [ChannelName,ChannelComment]=ProcessCN(tline);
             %Read Data from Buffer
             BinaryRead= BinaryStart+KeyOffsetBufferInSamplesKey;
             ChannelLength=KeyBufferFilledBytes*8/KeySignBits;
             TempChannel=ReadChannel(fid,BinaryRead,ChannelLength,KeyNumberFormat,KeyCRfactor,KeyCRoffset);
             Channel(ChannelID).name=ChannelName;
             Channel(ChannelID).comment=ChannelComment;
             Channel(ChannelID).length=ChannelLength;
             Channel(ChannelID).data=TempChannel;
             Channel(ChannelID).yUnit=KeyUnit;
             Channel(ChannelID).t0=TriggerTime;
             Channel(ChannelID).dt=CDSample;
             Channel(ChannelID).xUnit=CDUnit;
%              plot(TempChannel)
             clear TempChannel;
             ChannelID=ChannelID+1;
         fseek(fid,CurrentLocation,'bof');
         case KeyFlag(17);
         ProcessCS();
         case KeyFlag(18);
         ProcessNU();
     end
 end
fclose(fid);
FileInfo.ChannelNums=ChannelID-1;
Channels=Channel;
end

function BinaryStart=FindBinaryStart(fileid)
Str3='';
while not(strcmp(Str3,'|CS'))
LastLocation=ftell(fileid);
  tline=fgetl(fileid);
  Str3=tline(1:3);
end
CommaLocation=find(tline==',');
BinaryStart=CommaLocation(4)+LastLocation;

end
%--------------------------------------------------------------------------
%%
% CF,2,1,1;
%  Dateiformat,Prozessor
%  Dateiformat = 2, Keyl?nge =1, Prozessor = 1
%--------------------------------------------------------------------------
function  Finished=ProcessCFandCK(TxtString)
disp('Info: Processing key CF and CK...');
FileFormat=TxtString(5);
KeyLength=TxtString(7);
temp=TxtString(21);
Finished=str2double(temp);
if Finished==0
    msgbox('the rawdata is not finished storage','incorrect data','error');
end
disp('Info: Finished Processing key CF and CK!')
end

%-------------------------------------------------------------------------------
% CK,1,3,1,Abgeschlossen;
%-------------------------------------------------------------------------------
function  [keyVersion,keyLength,keyData]=ProcessCK(keyVersion,keyLength,keyData)
disp('Info: Processing key CK...')
if (keyLength ~= 3)
    msgbox('ERROR: CKs key length should always be 3.');
end
if (dataClosed == 0)
msgbox('WARNING: CK key indicates not all data was written');
msgbox('done processing key');
end
disp('Info: Finished Processing key CK!')
end
%-------------------------------------------------------------------------------
% NO,1,KeyLang,Ursprung,NameLang,Name, KommLang,Kommentar;
%-------------------------------------------------------------------------------
function [KeyOrigin,KeyCompany,KeyComment] = ProcessNO(TxtString)
%disp('Info: Processing key NO...');

CommaLocation=find(TxtString==',');
KeyOrigin=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
KeyCompany=TxtString(CommaLocation(5)+1:CommaLocation(6)-1);
KeyCommLength=TxtString(CommaLocation(6)+1:CommaLocation(7)-1);
if KeyCommLength=='0';
KeyComment='';
else 
    temp=str2double(KeyCommLength);
    KeyComment=TxtString(CommaLocation(7)+1,CommaLocation(7)+temp);
end

%disp('Info: Finished Processing key NO!')
end

% '-------------------------------------------------------------------------------
% ' CB,1,KeyLang,IndexGruppe,NameLang,Name,KommLang,Kommentar; 
% '-------------------------------------------------------------------------------
function tempCBbig= ProcessCBbig(TxtString)
% This function is relatvie to Group function
tempCBbig=0;
end


% '-------------------------------------------------------------------------------
% ' CT,1,KeyLang,IndexGruppe, NameLang,Name,TextLang,Text, CommLeng,Comment;
% '
% '  NOTE: The use of the word 'name' here is misleading.  This key contains extra
% '  information about a given channel group, not the channel group's actual name.
% '  'name', as used by this key, refers to the name of the attribute which
% '  will appear in the channel group's properties.
% '-------------------------------------------------------------------------------
function ProcessCT(TxtString)
% function is relative to Group
end

% '-------------------------------------------------------------------------------
% ' CG,1,KeyLang,NumberComponent,Fieldtype,Dimension;
% '-------------------------------------------------------------------------------
function [KeyNumnerCommponents,KeyFieldType,KeyDimension]=ProcessCG(TxtString)
% 	TracePrint(" Processing key CG...")
%disp('Info: Processing key CG...');
global CGCount;
CGCount=CGCount+1;
global CGFlag;
CGFlag=1;
% 	Dim paramList : paramList = Split(keyData,",")
CommaLocation=find(TxtString==',');

    Txtemp=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
    KeyNumnerCommponents=str2num(Txtemp);
    Txtemp=TxtString(CommaLocation(4)+1:CommaLocation(5)-1);
    KeyFieldType=str2num(Txtemp);
    Txtemp=TxtString(CommaLocation(5)+1);
    KeyDimension=str2num(Txtemp);
%disp('Info: Finished Processing key CG!')
end

% '-------------------------------------------------------------------------------
% ' CD,1,KeyLength,dx,kalibriert,EinheitLang, Einheit, 0,0,0; 
% ' CD,2,KeyLang,dx,kalibriert,EinheitLang, Einheit, Reduktion, IsMultiEvents, 
% '  SortiereBuffer, x0, PretriggerVerwendung; 
% '-------------------------------------------------------------------------------
function [KeyDx, KeyUnit]= ProcessCD(TxtString)
% disp('Info: Processing key CD...');

CommaLocation=find(TxtString==',');
Txtemp=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
KeyDx=str2double(Txtemp);
KeyUnit=TxtString(CommaLocation(6)+1:CommaLocation(7)-1);
% disp('Info: Finished Process key CD!');
end

% '-------------------------------------------------------------------------------
% ' NT,1,KeyLang,Tag,Monat,Jahr,Stunden,Minuten,Sekunden;
% '-------------------------------------------------------------------------------
function TimeStart = ProcessNT(TxtString)

    CommaLocation=find(TxtString==',');
    Txtemp=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
    KeyDay=str2num(Txtemp);
    Txtemp=TxtString(CommaLocation(4)+1:CommaLocation(5)-1);
    KeyMonth=str2num(Txtemp);
    Txtemp=TxtString(CommaLocation(5)+1:CommaLocation(6)-1);
    KeyYear=str2num(Txtemp);
    
    Txtemp=TxtString(CommaLocation(6)+1:CommaLocation(7)-1);
    KeyHours=str2num(Txtemp);
    Txtemp=TxtString(CommaLocation(7)+1:CommaLocation(8)-1);
    KeyMinutes=str2num(Txtemp);
    Txtemp=TxtString(CommaLocation(8)+1:length(TxtString));
    KeySeconds=str2num(Txtemp);
    
    TimeStart=datestr(datenum([KeyYear, KeyMonth,KeyDay,KeyHours,KeyMinutes,KeySeconds]),'yyyy-mm-dd HH:MM:SS');
% disp('Info: Finished Processing key NT!');
end

% '-------------------------------------------------------------------------------
% ' CZ,1,KeyLang,dz,dzkali,z0,z0kali,EinheitLang,Einheit,SegmentLang; 
% '-------------------------------------------------------------------------------
function ProcessCZ(TxtString)
% 	TracePrint(" Processing key CZ...")
% 
%   TracePrint(" ignoring key")
end


% '-------------------------------------------------------------------------------
% ' CC,1,KeyLang,KomponentenIndex,AnalogDigital;
% '
% ' Indicates a new channel.
% '-------------------------------------------------------------------------------
function KeyComponentIndex= ProcessCC(TxtString)
% 	TracePrint(" Processing key CC...")
% disp('Info: Processing key CC...');
% 	Dim paramList : paramList = Split(keyData,",")
%   Dim chan : Set chan = currentChanGroup.AddChan()
CommaLocation=find(TxtString==',');
Txtemp=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
KeyComponentIndex=str2num(Txtemp);
end

% '-------------------------------------------------------------------------------
% ' CP,1,KeyLang,BufferReferenz,Bytes,Zahlenformat,SignBits,Maske,Offset,
% '  DirekteFolgeAnzahl,AbstandBytes; 
% '-------------------------------------------------------------------------------
function [KeyBufferRef,KeyBytes,KeyNumerFormat,KeySignBits]= ProcessCP(TxtString)
% disp('Info: Processing key CP...');
CommaLocation=find(TxtString==',');  
Txtemp=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
KeyBufferRef=str2num(Txtemp);
Txtemp=TxtString(CommaLocation(4)+1:CommaLocation(5)-1);
KeyBytes=str2num(Txtemp);
Txtemp=TxtString(CommaLocation(5)+1:CommaLocation(6)-1);
NumberFormat=str2num(Txtemp);
switch (NumberFormat)
    case 1
        KeyNumerFormat='*uint';
    case 2
        KeyNumerFormat='*int';
    case 3
        KeyNumerFormat='*ushort'; 
    case 4
        KeyNumerFormat='*short';
    case 5
        KeyNumerFormat='*ulong'; 
    case 6
        KeyNumerFormat='*long';
    case 7
        KeyNumerFormat='*float'; 
    case 8
        KeyNumerFormat='*float32';
    case 9
        KeyNumerFormat='*'; % imc Device Transitional Recording
    case 10
        KeyNumerFormat='*TimeStampASII' ;% TimeStamp is famos type
    case 11 
        KeyNumberFormat='*bit16'; %2-byte-word digital
    case 13
         KeyNumberFormat='*bit48';      
end
Txtemp=TxtString(CommaLocation(6)+1:CommaLocation(7)-1);
KeySignBits=str2num(Txtemp);
end
% '-------------------------------------------------------------------------------
% ' Cb,1,KeyLang,AnzahlBufferInKey,BytesInUserInfo,BufferReferenz, IndexSamplesKey,
% '  OffsetBufferInSamplesKey, BufferLangBytes,OffsetFirstSampleInBuffer, 
% '  BufferFilledBytes, 0, X0, AddZeit, UserInfo, [BufferReferenz, ... ]; 
% '
% ' NOTE: This description above is taken from the specs, but all examples use a
% '  format as given below, with a zero after AddZeit.
% ' Cb,1,KeyLang,AnzahlBufferInKey,BytesInUserInfo,BufferReferenz, IndexSamplesKey,
% '  OffsetBufferInSamplesKey, BufferLangBytes,OffsetFirstSampleInBuffer, 
% '  BufferFilledBytes, X0, AddZeit, 0, UserInfo, [BufferReferenz, ... ]; 
% '-------------------------------------------------------------------------------
function [KeyBufferRefIndex,KeyBufferRefCb,KeyOffsetBufferInSamplesKey,KeyBufferFilledBytes] = ProcessCblittle(TxtString)
% disp('Info: Processing key Cb...');
CommaLocation=find(TxtString==',');
Txtemp=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
KeyBufferRefIndex=str2num(Txtemp);
Txtemp=TxtString(CommaLocation(5)+1:CommaLocation(6)-1);
KeyBufferRefCb=str2double(Txtemp);
Txtemp=TxtString(CommaLocation(7)+1:CommaLocation(8)-1);
KeyOffsetBufferInSamplesKey=str2double(Txtemp);
Txtemp=TxtString(CommaLocation(10)+1:CommaLocation(11)-1);
KeyBufferFilledBytes=str2double(Txtemp);
%disp('Info: Finished Processing key Cb!');
end

% '-------------------------------------------------------------------------------
% ' CR,1,KeyLang,Transformieren,Faktor,Offset,Kalibriert,EinheitLang, Einheit; 
% '-------------------------------------------------------------------------------
function [KeyTransformation,KeyCRfactor,KeyCRoffset,KeyUnit]= ProcessCR(TxtString)
%   disp('Info: Processing key CR...')
%
CommaLocation=find(TxtString==','); 
Txtemp=TxtString(CommaLocation(3)+1:CommaLocation(4)-1);
KeyTransformation=str2num(Txtemp);
Txtemp=TxtString(CommaLocation(4)+1:CommaLocation(5)-1);
KeyCRfactor=str2double(Txtemp);
Txtemp=TxtString(CommaLocation(5)+1:CommaLocation(6)-1);
KeyCRoffset=str2double(Txtemp);
Txtemp=TxtString(CommaLocation(7)+1:CommaLocation(8)-1);
KeyUnitLength=str2double(Txtemp);
KeyUnit=TxtString(CommaLocation(8)+1:CommaLocation(8)+KeyUnitLength);

%   disp('Info: Finished Processing key CR!');
end

% '-------------------------------------------------------------------------------
% ' ND,1,KeyLang,FarbeR,FarbeG,FarbeB,yMin,yMax; 
% '-------------------------------------------------------------------------------
function  ProcessND(TxtString)
% this function is relative to color and MaxMin value of channel
end


% '-------------------------------------------------------------------------------
% ' CN,1,KeyLang,IndexGruppe,0,IndexBit,NameLang,Name,KommLang,Kommentar; 
% '-------------------------------------------------------------------------------
function [ChannelName,ChannelComment]= ProcessCN(TxtString)
% 	TracePrint(" Processing key CN...")
%disp('Info: Processing key CR...');
CommaLocation=find(TxtString==',');
ChannelName=TxtString(CommaLocation(7)+1:CommaLocation(8)-1);
%   NOTE: It is unclear why this key has an index group, as it seems that the 
%   index group in the CB and CT keys are channel group numbers and this key
%   relates only to a single channel
ChannelCommLength=TxtString(CommaLocation(8)+1:CommaLocation(9)-1);
if ChannelCommLength=='0';
ChannelComment='';
else 
    temp=str2double(ChannelCommLength);
    ChnannelComment=TxtString(CommaLocation(9)+1,CommaLocation(9)+temp);
end
%disp('Info: Finished Processing key CN!');
end


function tempCS= ProcessCS(TxtString)
% 	TracePrint(" Processing key CS...")
%   
%   globalFile.Formatter.Delimiters  = ","
%   Dim dataSampleIndex : dataSampleIndex = globalFile.GetNextStringValue(defaultIntType)
%   Dim filePositionKeyStart : filePositionKeyStart = keyData
%   Dim filePositionDataStart : filePositionDataStart = globalFile.Position
%   'file position should now be at beginning of data
%     
%   Dim currentChannelGroup 
%   Dim currentChannel
%   Dim chunkLength,chanLength
%   Dim chan, chanGroup
%   Dim wordType, bytesPerWord
%   'If the channels are intermixed (channelsMixedTogether = true), one BinaryBlock
%   ' must be created to contain all the direct access channels
%   Dim binBlock : Set binBlock = globalFile.GetBinaryBlock()
%   
%   Call DetermineExactFileFormat(filePositionKeyStart,filePositionDataStart,keyLength,avlFormat,singleBinaryBlock,samplesOddlyClumped,channelsMixedTogether)
%        
%   For Each chanGroup In chanGroups
%     TracePrint(" looking at channelGroup: " & chanGroup.CBname)
%     
%     'processing channel group...
%     If (Not chanGroup.processed) Then
%       TracePrint("  this channel group has never been processed; adding it")
%       Set currentChannelGroup = Root.ChannelGroups.Add(chanGroup.CBname)
%       Set chanGroup.channelGroup = currentChannelGroup
%       chanGroup.processed = true
%     
%       'Fill in the channel group's meta-data
%       If (chanGroup.existsCT) Then
%         Call currentChannelGroup.Properties.Add(chanGroup.CTname,chanGroup.CTtext)
%         Call currentChannelGroup.Properties.Add(chanGroup.CTname & " comment",chanGroup.CTcomment)
%       End If    
%       Call currentChannelGroup.Properties.Add("description",chanGroup.CBcomment)
%     Else
%       TracePrint("  this channel group has ALREADY been processed")
%       Set currentChannelGroup = chanGroup.channelGroup
%     End If
%     'currentChannelGroup has now been correctly set
%     
%     For Each chan In chanGroup.chans
%       TracePrint(" looking at channel: " & chan.CNname)
%       If (chan.Cbindex = dataSampleIndex) Then
%         'this channel has data in this CS key
%         TracePrint("  this channel shares dataSampleIndex: " & dataSampleIndex)
%          
%         'Add an implicit channel for each channel, if possible.  Sizes will
%         ' be updated at the end.
%         If ( (Not chan.processed) And chan.subGroup.existsCD) Then
%           Dim dummySize : dummySize = 10
%           Set currentChannel = currentChannelGroup.Channels.AddImplicitChannel(chan.CNname & " x-axis",chan.CbtimeOffset,chan.subGroup.CDdx,dummySize,defaultRealType)
%           Set chan.associatedImplicitChannel = currentChannel
%           Call currentChannel.Properties.Add("unit_string",chan.subGroup.CDunit)
% 
%           TracePrint("  adding implicit channel, offset: " & chan.CbtimeOffset & " incr: " & chan.subGroup.CDdx & " length: " & chanLength)
%         End If
%         
%         'Determine if direct access channels can be used.
%         If ( (Not forceStableDataRead) And singleBinaryBlock And (Not samplesOddlyClumped) ) Then
%           TracePrint("  using direct access channels")
%           
%           If (chan.processed) Then
%             TracePrint("ERROR: direct access channels cannot process channels twice")
%             ErrorPrint("ERROR: The file format appears to be incorrect.  See log file for more details.")
%           End If
%           chan.processed = true
%                     
%           'chunkLength is measured in bytes.
%           chunkLength = (chan.CPnumberSamplesTogether * chan.CPbytesPerMeasurement) + chan.CPspacerBytes
%            
%           'chanLength is measured in number of samples
%           chanLength = (chan.Cblength \ chunkLength) * chan.CPnumberSamplesTogether
%           TracePrint("  chunkLength: " & chunkLength & "   and chanLength: " & chanLength)
%                     
%           If (channelsMixedTogether) Then
%             'Typical channel structure, e.g. A1 B1 A2 B2 A3 B3...
%             'All direct channels will come from one BinaryBlock.
% 
%             'NOTE: Currently, when the channels are mixed together in the binary
%             ' block, this plugin assumes that the first channel described in the
%             ' FAMOS file (i.e. with a CC key) is the first channel that appears
%             ' in the binary block.  If it is the case that a FAMOS file can 
%             ' describe channel Y then channel X, but in the binary block the data
%             ' looks like X1 Y1 X2 Y2... (i.e. channel X starts first), then
%             ' the channels must be sorted before being added to the BinaryBlock
%             TracePrint("  channels are mixed together, using one BinaryBlock")
%           Else
%             'Channels follow each other, e.g. A1 A2 A3... B1 B2 B3...
%             'Each channel gets its own BinaryBlock.
%             Set binBlock = globalFile.GetBinaryBlock()
%             'NOTE: the interaction among all the offsets is not entirely clear
%             binBlock.Position = filePositionDataStart + chan.CPinitialOffset + chan.CbbufferOffset + chan.CbsampleOffset
%             TracePrint("  channels are NOT mixed together, using many BinBlocks")
%           End If
%           
%           binBlock.BlockLength = chanLength
%           
%           Call FAMOStoUSI(chan.CPdataType,wordType,bytesPerWord)
%     
%           If (wordType = eNoType) Then
%             TracePrint("ERROR: invalid type for reading data.  FAMOS type # " & chan.CPdataType)
%             ErrorPrint("ERROR: Unable to process part of the source file.  See log file for more details.")
%           End If        
%   
%           Set currentChannel = binBlock.Channels.Add(chan.CNname,wordType)
%           Set chan.channel = currentChannel
% 
%           If (chan.CRtransformationType = 1) Then
%             TracePrint("  scaled, factor: " & chan.CRfactor & "   offset: " & chan.CRoffset)
%             currentChannel.Factor = chan.CRfactor
%             currentChannel.Offset = chan.CRoffset
%           Else
%             TracePrint("  not scaled")
%           End If
% 
%           TracePrint("  adding direct access channel to channel group")
%           currentChannelGroup.Channels.AddDirectAccessChannel(currentChannel) 
%            
%         Else
%           TracePrint("  reading binary data serially with normal (not direct access) channels")
%         
%           'processing channel...
%           If (Not chan.processed) Then
%             TracePrint("  this channel has never been processed; adding it")
%             chan.processed = true
%      
%             'Before reading binary data, fill in the channel's meta-data
%             Set currentChannel = currentChannelGroup.Channels.Add(chan.CNname,defaultRealType)'chan.CPdataType
%             Set chan.channel = currentChannel
%             
%           Else
%             TracePrint("  this channel has ALREADY been processed")
%             Set currentChannel = chan.channel
%           End If
%           'currentChannel has now been correctly set
%          
%           Call ReadBinaryDataSerial(chan,currentChannel,filePositionDataStart)
%         
%         End If ' If (direct access channels can be used or not)
%       
%         'update meta-data
%         Call currentChannel.Properties.Add("unit_string",chan.CRunit)
%         Call currentChannel.Properties.Add("description",chan.CNcomment)
%         Call currentChannel.Properties.Add("datetime",chan.subGroup.NTdateAndTime.variantdate)
%         If (chan.existsND) Then
%           Call currentChannel.Properties.Add("colorRed",chan.NDcolorRed)
%           Call currentChannel.Properties.Add("colorGreen",chan.NDcolorGreen)
%           Call currentChannel.Properties.Add("colorBlue",chan.NDcolorBlue)
%           Call currentChannel.Properties.Add("yMin",chan.NDyMin)
%           Call currentChannel.Properties.Add("yMax",chan.NDyMax)
%         End If
%       
%       End If   ' If (channel has data in this CS key or not)
%       TracePrint(" processing next channel...")
%     Next
%     TracePrint(" processing next chanGroup...")
%   Next
%   
%   'adjust the file position to the end of the CS key
%   TracePrint(" done looping; adjusting file position from " & globalFile.Position & " to " & filePositionKeyStart + keyLength)
%   globalFile.Position = filePositionKeyStart + keyLength
%   
%   'consume the trailing semicolon unless this is an AVL format file
%   If (Not avlFormat) Then
%     If (Not ByteStream(1) = ";") Then
%       TracePrint("ERROR: CS key improperly formatted, no ; found at end (and file is not an AVL file)")
%       ErrorPrint("ERROR: The file is incorrectly formatted.  See log file for more details.")
%     End If
%   End If
%   
%   TracePrint(" done processing CS key")
tempCS=0;
end
    
% '-------------------------------------------------------------------------------
% ' NU,1,KeyLang,KennLang,Kennwort,Daten;
% ' This is a binary key so keydata is the file position directly after 
% '  the comma following the key length
% '-------------------------------------------------------------------------------
function tempNU= ProcessNU(TxtString)
%
tempNU=0;
end

% '-------------------------------------------------------------------------------
% ' CI,1,KeyLang, IndexBlockKey, Zahlenformat, NameLang, Name, Wert, EinheitLang, 
% '  Einheit, KommentarLang, Kommentar, Zeit;
% '-------------------------------------------------------------------------------
function tempCI= ProcessCI(TxtString)
%This function is relative to single value
tempCI=0;
end

% '-------------------------------------------------------------------------------
% ' MakeNewChanGroup: Makes a new chanGroup, adds the group to the array of 
% '  chanGroups, and sets the parameter 'currentChanGroup' to the new 
% '  chanGroup.  currentChanGroup is also a global variable, but it made most of
% '  the program more easily understandable to pass a variable to MakeNewChanGroup.
% ' name: the name of the new chanGroup
% ' currentChanGroup: output - refers to the newly made ChanGroup
% '-------------------------------------------------------------------------------
function MakeNewChanGroup(name,currentChanGroup)
%The funcion is relative to Group
end

function tempChannel=ReadChannel(FileID, ReadStart,ChannelLength, Datatype,factor,offset)
fseek(FileID,ReadStart,'bof');

tempChannel=double(fread(FileID,ChannelLength,Datatype))*factor+offset;
%disp('Info: a Channle was imported.... ');
end


