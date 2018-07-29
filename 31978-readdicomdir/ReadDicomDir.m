function [outMat,procInfo,dcmInfo]=ReadDicomDir(inDir,debugLevel)
% [outMat,procInfo,dcmInfo]=ReadDicomDir(inDir [,debugLevel])
%   Read DICOM files from directory 'inDir'.
%   If mag and phase images in same directory: read and sort these images; 
%   phase images will be at 2nd half of outMat
%
% inDir: directory where the DICOM files are stored
% debugLevel: if >0, print debug message; debugLevel=0, 1, 2
% 
% outMat: a 2D matrix for a single slice, 3D matrix for multiple slices
% procInfo: abbreviated DICOM information
% dcmInfo: DICOM information from 1st DICOM file
%
% Example: 
% d1 = 'C:\Data\TAG7MM-92_11'
% [a,pname,pp]=ReadDicomDir(d1); 
% figure; imagesc(abs(a(:,:,20))
%
% check current directory
% [a]=ReadDicomDir('.');
%
% use GUI to choose directory
% [a]=ReadDicomDir;
%
% Tested using Siemens dicom images and Philips mag, phase dicom images.
% Tested using Philips mag and phase images
% Tested using GE dicom images: mag, phase, mag, phase, mag, phase ....
%
% For Siemens dicom in mosaic format: default to be magnitude. 
% Works for Siemens PET dicom images.
% For Philips real, imag images: check ImageType and revise flags
%
% Wen-Tung Wang, 201106
% Revised to read and sort mag and phase images (currently Siemens images only). 201107
% Revised to read Siemens dicom in mosaic format (all magnitude images).201205
% Revised to read GE dicom images. 201205

% msg = nargchk(1,2,nargin);
% if ~isempty(msg)
%    fprintf(1,'\tusage: [outMat,procInfo,dcmInfo]=ReadDicomDir(inDir [, debugLevel])\n');
%    fprintf(1,'\tRead multiple single-slice DICOM data (*.dcm, not *.ima)\n');
%    fprintf(1,'\tcheck "help ReadDicomDir" for more details\n');
%    return;
% end
% input from ui
    if (nargin<1) || (isempty(inDir)),
        inDir=uigetdir('','Select DICOM Directory');
        if ~ischar(inDir)
            disp('no valid Directory selected.');
            outMat=[]; procInfo=[]; dcmInfo=[];
            return;
        end
    end
% debugLevel
    if nargin<2, debugLevel=0; end
% check if directory exist 
    if (debugLevel), tic; end
    if (exist(inDir,'dir'))~=7,
	    fprintf(2,'%s \nnot exist or not a folder\n',inDir);
	    outMat=[]; procInfo=[]; dcmInfo=[];
	    return
    end
	aaDir = strfind(inDir,filesep);
	lenDir = length(inDir);
    if (~isempty(aaDir)),
        if (aaDir(end)==lenDir), % remove last filesep: either / or \
            inDir = inDir(1:end-1);
        end
    end
% read all files
    ffext = sprintf('*');
    fdir = fullfile(inDir,ffext);
    if (debugLevel), fprintf(1,'%s\n',fdir); end
	ff = dir(fdir);
    flen0 = numel(ff);
	flen = length(ff);
% exclude '.' and '..', and other files if needed
    ff(cell2mat({ff(:).isdir})>0)=[];
	flen = length(ff);
    ff0 = ff; %filenames without directory
% add path to filenames
    if (debugLevel), 
        fprintf(1,'%d files. 1st file = %s\n',flen,ff(1).name); 
    end
	for k=1:flen
		ff(k).name = [inDir,filesep,ff(k).name];
	end
% GE or Siemens or Philips DICOM
% Use magmatch, phamatch, realmatch, imagmatch to distinguish magnitude,
% phase, real, and imaginary dicom images
	display(ff(1).name);
	dinfo=dicominfo(ff(1).name);
    GEflag = 0; Siemensflag = 0; Philipsflag = 0;
    dcmInfo = dinfo;
    if (strfind(dinfo.Manufacturer,'SIEMENS')),
        Siemensflag = 1;
        vendor = 'Siemens';
        magmatch = 'ORIGINAL\PRIMARY\M\ND\NORM';
        magmatch = 'ORIGINAL\PRIMARY\M\';
        magmatch2= 'ORIGINAL\PRIMARY\M\ND\MOSAIC'; %mosaic format: magnitude
        phamatch = 'ORIGINAL\PRIMARY\P\';
    elseif (strfind(dinfo.Manufacturer,'GE')),
        % GE mag and phase images alternates. 
        % e.g. i1110030.MRDC.1 is magnitude; i1110031.MRDC.2 is phase
        GEflag = 1;
        vendor = 'GE';
        magmatch = 'ORIGINAL\PRIMARY\OTHER'; % 
        phamatch = 'ORIGINAL\PRIMARY\M'; % need to be revised
        if (mod(flen,2)~=0), 
            fprintf(1,'GE data: #files=%d. Need even number of files.\n',flen);
            outMat=[]; procInfo=[]; dcmInfo=[]; return;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %fprintf(1,'CHECK IMAGETYPE for GE Dicom images (%s), stop\n'); 
	    %outMat=[]; procInfo=[]; dcmInfo=[]; return;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif (strfind(dinfo.Manufacturer,'Philips')),
        Philipsflag = 1;
        vendor = 'Philips';
        magmatch = '\M\';
        phamatch = '\PHASE MAP\';
        realmatch = '\Real\'; % may need to be revised
        imagmatch = '\Imag\';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %fprintf(1,'CHECK IMAGETYPE for Philips Dicom images, stop\n'); 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        fprintf(1,'not recognized Manufacturer\n');
	    outMat=[]; procInfo=[]; dcmInfo=[]; return;
    end
    if (debugLevel>1), fprintf(1,'vendor: %s\n',vendor); end
% name strings: dicom tags to read. Add if need more.
    namestring = {'FileModDate','SeriesDescription','EchoTime',...
        'SeriesNumber','RepetitionTime','EchoTrainLength',...
        'PixelBandwidth','SequenceName','PercentPhaseFieldOfView',...
        'StudyDate','Manufacturer','InstanceNumber',...
        'SliceLocation','SliceThickness','FlipAngle','EchoNumber',...
        'Rows','Columns','Width','Height','ProtocolName',...
        'ImageType'};
    lenstr = length(namestring);
% assign parameters
    %matching variables
    for kk=1:lenstr
        str = cell2mat(namestring(kk));
        ttxt = sprintf('if(isfield(dinfo,''%s'')), %s = dinfo.%s; end',str,str,str);
        %disp(ttxt); %for checking
        eval([ttxt]);
    end
    if (debugLevel>1), fprintf(1,'variable matching done\n'); end
    % trim
    if (exist('SequenceName','var')),
        ind1 = strfind(SequenceName,'*');
        SequenceName = SequenceName(ind1+1:end);
    else
        ind1 = [];
    end
% display procInfo
    if (exist('ProtocolName')),
        line1 = sprintf('%s Protocol: %s',vendor,ProtocolName);
    else
        line1 = sprintf('%s Protocol: %s',vendor,SequenceName);
    end
% for multiple images: (1) read in all images. (2) sort mag and phase
% images, if exist. Phase images will be at 2nd half of outMat
	slc1=dicomread(dinfo);
    slcIndex = InstanceNumber;
    if (exist('EchoNumber','var')),
        EchoNumberMax = EchoNumber;
    else
        EchoNumberMax = 0;
    end
    if (debugLevel>1), fprintf(1,'start looping through files\n'); end
	if flen==1,
        outMat = double(slc1);
        % for procInfo
        magFlag = 0;
        phaFlag = 0;
		line2 = sprintf('  TE/TR/FA/SlcThk=%.2fms/%.0fms/%.1fdeg/%.1fmm',EchoTime,RepetitionTime,FlipAngle,SliceThickness);
		line3 = sprintf('  matrix=%dx%d, FoV=%dx%d',Rows,Columns,Height,Width);
        if (strfind(ImageType,magmatch)),
            magFlag = 1;
        elseif (strfind(ImageType,phamatch2)),
            magFlag = 1;
        elseif (strfind(ImageType,phamatch)),
            phaFlag = 1;
            if (magFlag==1),
                slcIndex = slcIndex + skipNumber;
            end
        else
            fprintf(1,'neither mag nor phase. ImageType=%s\n',ImageType);
            procInfo=[]; 
        end
		if (magFlag==1)&&(phaFlag==0),
			line3 = [line3,', Magnitude images'];
		elseif (magFlag==0)&&(phaFlag==1),
			line3 = [line3,', Phase images'];
		elseif (magFlag==1)&&(phaFlag==1),
			line3 = [line3,', Magnitude+Phase images'];
		else
        end
		if (EchoNumberMax>1),
            ETline=sprintf('  %d TEs=',EchoNumberMax);
            for kk=1:EchoNumberMax-1, ETline=[ETline,sprintf('%.2f/',ETsort(kk))]; end
            ETline=[ETline,sprintf('%.1f ms',ETsort(EchoNumberMax))];
            procInfo = sprintf('%s\n%s\n%s\n%s',line1,line2,line3,ETline);
        else
            procInfo = sprintf('%s\n%s\n%s',line1,line2,line3);
        end
		disp(procInfo);
    else
        kk = 1;
        magFlag = 0;
        phaFlag = 0;
        magSlices = [];
        phaSlices = [];
        skipNumber = flen/2;
        if (strfind(ImageType,magmatch)),
            magFlag = 1;
            magSlices = [magSlices; kk InstanceNumber];
        elseif (strfind(ImageType,magmatch2)),
            magFlag = 1;
            magSlices = [magSlices; kk InstanceNumber];
        elseif (strfind(ImageType,phamatch)),
            phaFlag = 1;
            phaSlices = [phaSlices; kk InstanceNumber+skipNumber];
        else
            fprintf(1,'neither mag nor phase. Default: mag\n');
            magFlag = 1;
            magSlices = [magSlices; kk InstanceNumber];
            %procInfo=[]; 
        end
        % philips may output mag, phase, real, imag
        % still use magSlices and phaSlice to store real and imag data
        if (Philipsflag), 
            if (strfind(ImageType,realmatch)), %using strfind maybe better than strcmp
                magFlag = 1;
                magSlices = [magSlices; kk InstanceNumber];
            elseif (strfind(ImageType,imagmatch)),
                phaFlag = 1;
                phaSlices = [phaSlices; kk InstanceNumber+skipNumber];
            else
                fprintf(1,'neither real nor imag\n');
                procInfo=[]; 
            end
        end
        if (debugLevel>2), fprintf(1,'%3d ',kk); end
        outMat=zeros([Rows,Columns,flen]);
        outMat(:,:,kk) = double(slc1);
        InstanceNumbers=zeros([flen,1]);
        if (exist('EchoTime','var')),
            EchoTimes=zeros([flen,1]);
            EchoTimes(kk)=EchoTime;
        end
        InstanceNumbers(kk)=InstanceNumber;
		for kk=2:flen,
			dinfo = dicominfo(ff(kk).name);
            %EchoTrainLength = dinfo.EchoTrainLength;
            %SliceLocation = dinfo.SliceLocation;
            InstanceNumber = dinfo.InstanceNumber;
            slcIndex = InstanceNumber;
            if (exist('EchoTime','var')),
                EchoTime = dinfo.EchoTime;
            end
            if (exist('EchoNumber','var')),
                EchoNumber = dinfo.EchoNumber;
                if (EchoNumber>EchoNumberMax), EchoNumberMax = EchoNumber; end
            end
            ImageType = dinfo.ImageType;
            if (debugLevel>4), 
                fprintf(1,'%s ',ff0(kk).name); 
                if (debugLevel>5), 
                    fprintf(1,' type=%s ',ImageType); 
                end
            end
			if (strfind(ImageType,magmatch)),
                magFlag = 1;
                magSlices = [magSlices; kk slcIndex];
            elseif (strfind(ImageType,magmatch2)),
                magFlag = 1;
                magSlices = [magSlices; kk slcIndex];
			elseif (strfind(ImageType,phamatch)),
                phaFlag = 1;
                phaSlices = [phaSlices; kk slcIndex+skipNumber];
				if (magFlag==1),
                    slcIndex = slcIndex + skipNumber;
                end
            else %default: mag
                magFlag = 1;
                magSlices = [magSlices; kk slcIndex];
            end
            InstanceNumbers(kk)=slcIndex;
            if (exist('EchoTime','var')),
                EchoTimes(kk)=EchoTime;
            end
            % output
			outMat(:,:,kk) = double(dicomread(dinfo));
            if (debugLevel>2), fprintf(1,'%3d ',kk); end
            if (debugLevel>2)&&((mod(kk,20)==0)||(mod(kk,flen)==0)), fprintf(1,'\n'); end
        end
        % swap order according to InstanceNumber
        % for mag+phase images: phase images at 2nd half of outMat
        tmp = zeros(size(outMat));
        lenMag = length(magSlices);
        lenPha = length(phaSlices);
        if (debugLevel>1), fprintf(1,'#(magintude, phase)images = (%d, %d)\n',lenMag,lenPha); end
        if ((lenMag<1)&&(lenPha<1)), procInfo=[]; fprintf(1,'check magSlices (%s) and phasSlices (%s)\n',magmatch,phamatch); return; end
        % Philips data are in order of mag+phase already, they don't mixed
        if (~Philipsflag),
            if (lenMag*lenPha)>0, % mag + phase images
                tmp(:,:,magSlices(:,2))=outMat(:,:,magSlices(:,1));
                tmp(:,:,phaSlices(:,2))=outMat(:,:,phaSlices(:,1));
            else
                if (lenMag>0), % magnitude images only
                    tmp(:,:,magSlices(:,2))=outMat(:,:,magSlices(:,1));
                else % phase images only: subtract skipNumber
                    phaSlices(:,2) = phaSlices(:,2) - skipNumber;
                    tmp(:,:,phaSlices(:,2))=outMat(:,:,phaSlices(:,1));
                end
            end
            outMat=tmp;
        end
        
        % find echo times
        if (exist('EchoTime','var')),
            uEchoTimes = unique(EchoTimes);
            [ETsort] = sort(uEchoTimes,'ascend');
        end
        lenETsort = length(ETsort);
        
	   	%display procInfo
        %if (debugLevel>1), fprintf(1,'\n'); end
        if (exist('EchoTime','var')),
            line2 = sprintf('  TE/TR/FA/SlcThk=%.2fms/%.0fms/%.1fdeg/%.1fmm',EchoTime,RepetitionTime,FlipAngle,SliceThickness);
        else
            line2 = sprintf('  SlcThk=%.1fmm',SliceThickness);
        end
		line3 = sprintf('  matrix=%dx%d, FoV=%dx%d',Rows,Columns,Height,Width);
		if (magFlag==1)&&(phaFlag==0),
			line3 = [line3,', Magnitude images'];
		elseif (magFlag==0)&&(phaFlag==1),
			line3 = [line3,', Phase images'];
		elseif (magFlag==1)&&(phaFlag==1),
			line3 = [line3,', Magnitude+Phase images'];
		else
		end
		if ((EchoNumberMax>1)&(lenETsort>1)),
            ETline=sprintf('  %d TEs=',EchoNumberMax);
            for kk=1:EchoNumberMax-1, ETline=[ETline,sprintf('%.2f/',ETsort(kk))]; end
            ETline=[ETline,sprintf('%.1f ms',ETsort(EchoNumberMax))];
            procInfo = sprintf('%s\n%s\n%s\n%s',line1,line2,line3,ETline);
        else
            procInfo = sprintf('%s\n%s\n%s',line1,line2,line3);
		end
		disp(procInfo);
		if (flen>1),
			fprintf(1,'total %d files/images\n',flen);
		end
    end
    if ((GEflag)&(flen>1)),
        reply = input('Place odd slices as 2nd half of 3D matrix? Y/N [Y]:','s');
        if isempty(reply)
            reply = 'Y';
        end
        if ((reply=='Y')|(reply=='y')),
            tmpOdd=outMat(:,:,1:2:end-1);
            tmpEven=outMat(:,:,2:2:end);
            outMat = cat(3, tmpOdd, tmpEven);
        end
    end
% total elapsed time    
    if (debugLevel), 
        fprintf(1,'elapsed time = %f\n',toc); 
    end
return;
    
