function [fcsdat, fcshdr, fcsdatscaled, fcsdat_comp] = fca_readfcs(filename)
% [fcsdat, fcshdr, fcsdatscaled, fcsdat_comp] = fca_readfcs(filename);
%
%
% Read FCS 2.0 and FCS 3.0 type flow cytometry data file and put the list mode  
% parameters to the fcsdat array with the size of [NumOfPar TotalEvents]. 
% Some important header data are stored in the fcshdr structure:
% TotalEvents, NumOfPar, starttime, stoptime and specific info for parameters
% as name, range, bitdepth, logscale(yes-no) and number of decades.
%
% [fcsdat, fcshdr] = fca_readfcs;
% Without filename input the user can select the desired file
% using the standard open file dialog box.
%
% [fcsdat, fcshdr, fcsdatscaled] = fca_readfcs(filename);
% Supplying the third output the fcsdatscaled array contains the scaled     
% parameters. It might be useful for logscaled parameters, but no effect 
% in the case of linear parameters. The log scaling is the following
% operation for the "ith" parameter:  
% fcsdatscaled(:,i) = ...
%   10.^(fcsdat(:,i)/fcshdr.par(i).range*fcshdr.par(i).decade;);
%
% 
%[fcsdat, fcshdr, fcsdatscaled, fcsdat_comp] = fca_readfcs(filename);
% In that case the script will calculate the compensated fluorescence 
% intensities (fcsdat_comp) if spillover data exist in the header 
%
% Ver May/10/2013

% 2006-2011 / University of Debrecen, Institute of Nuclear Medicine
% Laszlo Balkay 
% balkay@pet.dote.hu
%
% History
% 14/08/2006 I made some changes in the code by the suggestion of 
% Brian Harms <brianharms@hotmail.com> and Ivan Cao-Berg <icaoberg@cmu.edu> 
% (given at the user reviews area of Mathwork File exchage) The program should work 
% in the case of Becton EPics DLM FCS2.0, CyAn Summit FCS3.0 and FACSDiva type 
% list mode files.
%
% 29/01/2008 Updated to read the BD LSR II file format and including the comments of
% Allan Moser (Cira Discovery Sciences, Inc.)
%
% 24/01/2009 Updated to read the Partec CyFlow format file. Thanks for
% Gavin A Price
% 
% 20/09/2010 Updated to read the Accuri C6 format file. Thanks for
% Rob Egbert, University of Washington
%
% 07/11/2011 Updated to read Luminex 100 data file. Thanks for
% Ofir Goldberger, Stanford University
%
% 11/05/2013 The fluorescence compensation is implemeted into the code.
% Thanks for Rick Stanton, J. Craig Venter Institute, La Jolla, San Diego

%

% if noarg was supplied
if nargin == 0
     [FileName, FilePath] = uigetfile('*.*','Select fcs2.0 file');
     filename = [FilePath,FileName];
     if FileName == 0;
          fcsdat = []; fcshdr = []; fcsdatscaled= []; fcsdat_comp= [];
          return;
     end
else
    filecheck = dir(filename);
    if size(filecheck,1) == 0
        hm = msgbox([filename,': The file does not exist!'], ...
            'FcAnalysis info','warn');
        fcsdat = []; fcshdr = []; fcsdatscaled= []; fcsdat_comp= [];
        return;
    end
end

% if filename arg. only contain PATH, set the default dir to this
% before issuing the uigetfile command. This is an option for the "fca"
% tool
[FilePath, FileNameMain, fext] = fileparts(filename);
FilePath = [FilePath filesep];
FileName = [FileNameMain, fext];
if  isempty(FileNameMain)
    currend_dir = cd;
    cd(FilePath);
    [FileName, FilePath] = uigetfile('*.*','Select FCS file');
     filename = [FilePath,FileName];
     if FileName == 0;
          fcsdat = []; fcshdr = []; fcsdatscaled= []; fcsdat_comp= [];
          return;
     end
     cd(currend_dir);
end

%fid = fopen(filename,'r','ieee-be');
fid = fopen(filename,'r','b');
fcsheader_1stline   = fread(fid,64,'char');
fcsheader_type = char(fcsheader_1stline(1:6)');
%
%reading the header
%
if strcmp(fcsheader_type,'FCS1.0')
    hm = msgbox('FCS 1.0 file type is not supported!','FcAnalysis info','warn');
    fcsdat = []; fcshdr = []; fcsdatscaled= []; fcsdat_comp= [];
    fclose(fid);
    return;
elseif  strcmp(fcsheader_type,'FCS2.0') || strcmp(fcsheader_type,'FCS3.0') % FCS2.0 or FCS3.0 types
    fcshdr.fcstype = fcsheader_type;
    FcsHeaderStartPos   = str2num(char(fcsheader_1stline(11:18)'));
    FcsHeaderStopPos    = str2num(char(fcsheader_1stline(19:26)'));
    FcsDataStartPos     = str2num(char(fcsheader_1stline(27:34)'));
    status = fseek(fid,FcsHeaderStartPos,'bof');
    fcsheader_main = fread(fid,FcsHeaderStopPos-FcsHeaderStartPos+1,'char');%read the main header
    warning off MATLAB:nonIntegerTruncatedInConversionToChar;
    fcshdr.filename = FileName;
    fcshdr.filepath = FilePath;
    % "The first character of the primary TEXT segment contains the
    % delimiter" (FCS standard)
    if fcsheader_main(1) == 12
        mnemonic_separator = 'FF';
    else
        mnemonic_separator = char(fcsheader_main(1));
    end
    if mnemonic_separator == '@';% WinMDI
        hm = msgbox([FileName,': The file can not be read (Unsupported FCS type: WinMDI histogram file)'],'FcAnalysis info','warn');
        fcsdat = []; fcshdr = [];fcsdatscaled= []; fcsdat_comp= [];
        fclose(fid);
        return;
    end
    fcshdr.TotalEvents = str2num(get_mnemonic_value('$TOT',fcsheader_main, mnemonic_separator));
    if fcshdr.TotalEvents == 0
        fcsdat = 0;
        fcsdatscaled = 0;
        return
    end
    fcshdr.NumOfPar = str2num(get_mnemonic_value('$PAR',fcsheader_main, mnemonic_separator));
    fcshdr.Creator = get_mnemonic_value('CREATOR',fcsheader_main, mnemonic_separator);
    for i=1:fcshdr.NumOfPar
        fcshdr.par(i).name = get_mnemonic_value(['$P',num2str(i),'N'],fcsheader_main, mnemonic_separator);
        fcshdr.par(i).range = str2num(get_mnemonic_value(['$P',num2str(i),'R'],fcsheader_main, mnemonic_separator));
        fcshdr.par(i).bit = str2num(get_mnemonic_value(['$P',num2str(i),'B'],fcsheader_main, mnemonic_separator));

        %==============   Changed way that amplification type is treated ---  ARM  ==================
        par_exponent_str= (get_mnemonic_value(['$P',num2str(i),'E'],fcsheader_main, mnemonic_separator));
        if isempty(par_exponent_str)
            % There is no "$PiE" mnemonic in the Lysys format
            % in that case the PiDISPLAY mnem. shows the LOG or LIN definition
            islogpar = get_mnemonic_value(['P',num2str(i),'DISPLAY'],fcsheader_main, mnemonic_separator);
            if strcmp(islogpar,'LOG')
               par_exponent_str = '5,1'; 
            else % islogpar = LIN case
                par_exponent_str = '0,0';
            end
        end
       
        par_exponent= str2num(par_exponent_str);
        fcshdr.par(i).decade = par_exponent(1);
        if fcshdr.par(i).decade == 0
            fcshdr.par(i).log = 0;
            fcshdr.par(i).logzero = 0;
        else
            fcshdr.par(i).log = 1;
            if (par_exponent(2) == 0)
              fcshdr.par(i).logzero = 1;
            else
              fcshdr.par(i).logzero = par_exponent(2);
            end
        end
     
%============================================================================================
    end
    fcshdr.starttime = get_mnemonic_value('$BTIM',fcsheader_main, mnemonic_separator);
    fcshdr.stoptime = get_mnemonic_value('$ETIM',fcsheader_main, mnemonic_separator);
    fcshdr.cytometry = get_mnemonic_value('$CYT',fcsheader_main, mnemonic_separator);
    fcshdr.date = get_mnemonic_value('$DATE',fcsheader_main, mnemonic_separator);
    fcshdr.byteorder = get_mnemonic_value('$BYTEORD',fcsheader_main, mnemonic_separator);
    if strcmp(fcshdr.byteorder, '1,2,3,4')
        machineformat = 'ieee-le';
    elseif strcmp(fcshdr.byteorder, '4,3,2,1')
        machineformat = 'ieee-be';
    end
    fcshdr.datatype = get_mnemonic_value('$DATATYPE',fcsheader_main, mnemonic_separator);
    fcshdr.system = get_mnemonic_value('$SYS',fcsheader_main, mnemonic_separator);
    fcshdr.project = get_mnemonic_value('$PROJ',fcsheader_main, mnemonic_separator);
    fcshdr.experiment = get_mnemonic_value('$EXP',fcsheader_main, mnemonic_separator);
    fcshdr.cells = get_mnemonic_value('$Cells',fcsheader_main, mnemonic_separator);
    fcshdr.creator = get_mnemonic_value('CREATOR',fcsheader_main, mnemonic_separator);
    fcshdr.spill = get_mnemonic_value('SPILL',fcsheader_main, mnemonic_separator); %spillover factor for Fl. compensation
    
 % Create the Fluorescence compensation matrix if spillover data exist in the header
 % This option was implemented with the help of Rick Stanton (jcvi, la jolla, ca)
    if ~isempty(fcshdr.spill) 
        [compSize pos1] = textscan(fcshdr.spill,'%f',1,'delimiter',',');
        [compNames_ pos2] = textscan(fcshdr.spill(pos1+1:end),'%s',compSize{1},'delimiter',',');
        compNames = compNames_{1};
%       mComp_ = textscan(fcshdr.spill(pos1+pos2+1:end),'%f',compSize{1}^2,'delimiter',',');
%       mComp = reshape(cell2mat(mComp_),[compSize{1} compSize{1}]);
        mSpill_ = textscan(fcshdr.spill(pos1+pos2+1:end),'%f',compSize{1}^2,'delimiter',',');
        mSpill  = reshape(cell2mat(mSpill_),[compSize{1} compSize{1}]);
        mComp   = inv(mSpill');
        fcshdr.mComp = mComp;
        compNames2num=[];
        for j=1:compSize{1}
            for i=1:fcshdr.NumOfPar
                if strcmp(compNames{j},fcshdr.par(i).name)
                   compNames2num(j) = i;
                   break;
                end
            end
        end
    end
        
else
    hm = msgbox([FileName,': The file can not be read (Unsupported FCS type)'],'FcAnalysis info','warn');
    fcsdat = []; fcshdr = []; fcsdatscaled= []; fcsdat_comp= [];
    fclose(fid);
    return;
end
%
%reading the events
%
status = fseek(fid,FcsDataStartPos,'bof');
if strcmp(fcsheader_type,'FCS2.0')
    if strcmp(mnemonic_separator,'\') || strcmp(mnemonic_separator,'FF')... %ordinary or FacsDIVA FCS2.0 
           || strcmp(mnemonic_separator,'/') % added by GAP 1/22/09
        if fcshdr.par(1).bit == 16
            fcsdat = uint16(fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'uint16')');
            fcsdat_orig = fcsdat;%//
            if strcmp(fcshdr.byteorder,'1,2')...% this is the Cytomics data
                    || strcmp(fcshdr.byteorder, '1,2,3,4') %added by GAP 1/22/09
                fcsdat = bitor(bitshift(fcsdat,-8),bitshift(fcsdat,8));
            end
        elseif fcshdr.par(1).bit == 32
                if fcshdr.datatype ~= 'F'
                    fcsdat = (fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'uint32')');
                else % 'LYSYS' case
                    fcsdat = (fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'float32')');
                end
        else 
            bittype = ['ubit',num2str(fcshdr.par(1).bit)];
            fcsdat = fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],bittype, 'ieee-le')';
        end
    elseif strcmp(mnemonic_separator,'!');% Becton EPics DLM FCS2.0
        fcsdat_ = fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'uint16', 'ieee-le')';
        fcsdat = zeros(fcshdr.TotalEvents,fcshdr.NumOfPar);
        for i=1:fcshdr.NumOfPar
            bintmp = dec2bin(fcsdat_(:,i));
            fcsdat(:,i) = bin2dec(bintmp(:,7:16)); % only the first 10bit is valid for the parameter  
        end
    end
    fclose(fid);
elseif strcmp(fcsheader_type,'FCS3.0')
    if strcmp(mnemonic_separator,'|') % CyAn Summit FCS3.0
        fcsdat_ = (fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'uint16',machineformat)');
        fcsdat = zeros(size(fcsdat_));
        new_xrange = 1024;
        for i=1:fcshdr.NumOfPar
            fcsdat(:,i) = fcsdat_(:,i)*new_xrange/fcshdr.par(i).range;
            fcshdr.par(i).range = new_xrange;
        end
    elseif strcmp(mnemonic_separator,'/')
        if findstr(lower(fcshdr.cytometry),'accuri')  % Accuri C6, this condition added by Rob Egbert, University of Washington 9/17/2010
            fcsdat = (fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'int32',machineformat)');
        elseif findstr(lower(fcshdr.cytometry),'partec')%this block added by GAP 6/1/09 for Partec, copy/paste from above
            fcsdat = uint16(fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'uint16',machineformat)');
            %fcsdat = bitor(bitshift(fcsdat,-8),bitshift(fcsdat,8));
        elseif findstr(lower(fcshdr.cytometry),'lx') % Luminex data
            fcsdat = fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'int32',machineformat)';
            fcsdat = mod(fcsdat,1024);
        end
    else % ordinary FCS 3.0
        fcsdat = fread(fid,[fcshdr.NumOfPar fcshdr.TotalEvents],'float32',machineformat)';
    end
    fclose(fid);
end

%% this is for Ricardo Khouri converting Partec to FacsDIVA_FCS20 format
%% 28/01/2013
save_FacsDIVA_FCS20 = 0;
if strcmp(fcshdr.cytometry ,'partec PAS') && save_FacsDIVA_FCS20    
    fcsheader_main2 = fcsheader_main;
    sep_place = strfind(char(fcsheader_main'),'/');
    fcsheader_main2(sep_place) = 12;
    fcsheader_1stline2 = fcsheader_1stline;
    fcsheader_1stline2(31:34) = double(num2str(FcsHeaderStopPos+1));
    fcsheader_1stline2(43:50) = double('       0');
    fcsheader_1stline2(51:58) = double('       0');
    FileSize =  length(fcsheader_main2(:))+ length(fcsheader_1stline2(1:FcsHeaderStartPos))+ 2*length(fcsdat_orig(:));
    space_char(1:8-length(num2str(FileSize)))= ' ';
    fcsheader_1stline2(35:42) = double([space_char,num2str(FileSize)]);

    fid2 = fopen([FilePath, FileNameMain,'_', fext],'w','b');
    fwrite(fid2,[fcsheader_1stline2(1:FcsHeaderStartPos)],'char');
    fwrite(fid2,fcsheader_main2,'char');
    fwrite(fid2,fcsdat_orig','uint16');
    fclose(fid2);
end

% Fluorescence compensation with the compensation matrix
if ~isempty(fcshdr.spill)
   fcsdat_comp = fcsdat; 
   fcsdat_comp(:,compNames2num) = fcsdat(:,compNames2num) * mComp;     
else
   fcsdat_comp= [];
end


%
%calculate the scaled events (for log scales)
%
fcsdatscaled = zeros(size(fcsdat));
for  i = 1 : fcshdr.NumOfPar
    Xlogdecade = fcshdr.par(i).decade;
    XChannelMax = fcshdr.par(i).range;
    Xlogvalatzero = fcshdr.par(i).logzero;
    if ~fcshdr.par(i).log
       fcsdatscaled(:,i)  = fcsdat(:,i);
    else
       fcsdatscaled(:,i) = Xlogvalatzero*10.^(double(fcsdat(:,i))/XChannelMax*Xlogdecade);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mneval = get_mnemonic_value(mnemonic_name,fcsheader,mnemonic_separator)

if strcmp(mnemonic_separator,'\')  || strcmp(mnemonic_separator,'!') ...
        || strcmp(mnemonic_separator,'|') || strcmp(mnemonic_separator,'@')...
        || strcmp(mnemonic_separator, '/') % added by GAP 1/22/08
    mnemonic_startpos = findstr(char(fcsheader'),[mnemonic_name,mnemonic_separator]);
    if isempty(mnemonic_startpos)
        mneval = [];
        return;
    end
    mnemonic_length = length(mnemonic_name);
    mnemonic_stoppos = mnemonic_startpos + mnemonic_length;
    next_slashes = findstr(char(fcsheader(mnemonic_stoppos+1:end)'),mnemonic_separator);
    next_slash = next_slashes(1) + mnemonic_stoppos;

    mneval = char(fcsheader(mnemonic_stoppos+1:next_slash-1)');
elseif strcmp(mnemonic_separator,'FF')
    mnemonic_startpos = findstr(char(fcsheader'),mnemonic_name);
    if isempty(mnemonic_startpos)
        mneval = [];
        return;
    end
    mnemonic_length = length(mnemonic_name);
    mnemonic_stoppos = mnemonic_startpos + mnemonic_length ;
    next_formfeeds = find( fcsheader(mnemonic_stoppos+1:end) == 12);
    next_formfeed = next_formfeeds(1) + mnemonic_stoppos;

    mneval = char(fcsheader(mnemonic_stoppos + 1 : next_formfeed-1)');
end
