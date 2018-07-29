function [m, sx, units]=ReadDMFile(filename,logfile)
% function [m, sx, units]=ReadDMFile(filename,logfile) Read a Digital
% Micrograph file version 3 or 4 and return the first image in its native
% data format (e.g. int16), along with its pixel scale information
% (typically the units value = 'nm').  If a logfile name is specified, a
% description of the entire tree will be written to the console and also to
% the file.

% F. Sigworth, August 2013
% Based on ReadDM3 F. Sigworth, July 2009
% Code was based on the description by Greg Jefferis at
% http://rsb.info.nih.gov/ij/plugins/DM3Format.gj.html
% Version 4 differs from version 3 mainly in that it uses uint64 instead of
% int32 or uint32 for various count entries.  The function GetLLong is used
% to get these counts in a version-dependent manner.
% 
% This function has been written assuming that it will run on a
% little-endian (e.g. Intel) machine, reading a file written by a
% little-endan machine. Otherwise the use of the swapbytes function will
% have to be made conditional on the local machine type and the byteorder
% variable. Also, swapbytes may have to be added to the GetData function.
% 
% Note that the code here allows any
% fields from the tree to be extracted. Here is where we define the fields
% that we will extract.  We grab the data value at the first match of each
% of these tags.  Here numerals represent unnamed fields.  To see what all
% the tags are, specify a logfile to receive the hundreds of lines of
% information!

celltags={'ImageList 2 ImageData Calibrations Dimension 1 Scale'
    'ImageList 2 ImageData Calibrations Dimension 1 Units'
    'ImageList 2 ImageData Dimensions 1'
    'ImageList 2 ImageData Dimensions 2'
    'ImageList 2 ImageData Dimensions 3'
    'ImageList 2 ImageData Data'};

% Strings to write out data types
dataTypeString={'1?'      'int16'   'int32' 'uint16' 'uint32'...
                'float32' 'float64' 'bool'  'int8'   'uint8'...
                'int64'   'uint64'  '13?'   '14?'    'struct'...
                '16?'     '17?'     'string' '20?'   'array'};

found=zeros(size(celltags));
output=cell(size(celltags));

% Set up the log file.  We use my mprintf function to allow printing to the
% console as well, and suppressing printing when the handle is zero.
if nargin>1
    flog=fopen(logfile,'w');
    hs=[1 flog];  % log file handles
else
    flog=0;
    hs=[0];
end;
tabstring='| ';
level=0;
maxprint=4;
OutputOn=1;

% Read the whole file into memory as a byte array.
fb=fopen(filename,'r');
tic;
d=fread(fb,inf,'*uint8');  % read the whole file as bytes
dt=toc;
fclose(fb);

p=uint64(1);  % byte pointer--also a global variable
Tags=cell(1,10); % Keeps track of the sequence of tags, for matching with the tag strings.


% Pick up the header
version=GetLong;
if (version<3) || (version>4)
    error(['ReadDM34: Wrong file type.  Version = ' num2str(version)]);
end;
mprintf(hs,'Version %d\n',version);

nbytes=GetLLong;
mprintf(hs,'Total size %d MB\n',nbytes/2^20);
mprintf(hs,'Read in %d s\n',dt);
% Handle little- and big-endian files and machines
dle=GetLong;  % boolean to tell whether data are little endian
[str,maxsize,endian] = computer;
mle= (endian=='L');  % machine is little endian: we'll have to swap bytes in reading the tree.
dswap=(dle~=mle);  % swap byte-order when reading data

% Traverse the tree
GetTagGroup;

% Close the logfile
if flog>0
    fclose(flog);
end;

% Extract the output parameters
sx=output{1};
units=char(output{2});
xdim=output{3};
ydim=output{4};
zdim=output{5};         % no. of images in a stack
if numel(zdim)<1 || any(zdim)<1
    zdim=1;
end;
m=reshape(output{6},[xdim ydim zdim]);

% end of main function

% -------------------------------


% ---- here are all the local functions, called recursively ----

    function GetTagGroup
        sorted=GetByte;
        open=GetByte;
        NumTags=GetLLong;
        for i=1:NumTags
            GetTagEntry(i);
        end;
    end

    function GetTagEntry(MemberIndex)
        level=level+1;
        PutNewline;
        PutTabs;
        isdata=GetByte;
        labelsize=GetInt;
        labelstring=GetString(labelsize);
        PutStr('-');
        PutStr([labelstring ':']);
        if numel(labelstring)<1
            labelstring=num2str(MemberIndex);
        end;
        Tags{level}=labelstring;
        if version==4
            totalBytes=GetLLong;
        end;
        if isdata==21
            GetTagType
        elseif isdata==20
            GetTagGroup
        else
            error(['Unknown TagEntry type ' num2str(isdata)]);
        end;
        Tags{level}=[];
        level=level-1;
    end

    function GetTagType
        dum=GetLong;
        if dum ~= 623191333
            disp(['Illegal TagType value ' num2str(dum)]);
        end
        deflen=GetLLong;  % number of items in encoding array
        EncType=GetLLong;
%         for i=1:deflen
%             EncType(i)=GetLLong;  % Don't know how to use the array...
%         end;
        x=GetData(EncType);
        index=CheckTags;
        if index>0
            output{index}=x;
        end;
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % This is the function that slows everything down, which checks the
    % entire tag list for each tagged type.  It is inefficient, but simple.
    function r=CheckTags
        for i=1:numel(celltags)
            ok=~found(i);
            c=celltags{i};
            j=1;
            while ok && (numel(c)>0)
                [s c]=strtok(c);
                ok=strcmp(s,'*')||strcmp(s,Tags{j});
                j=j+1;
            end;
            if ok
                r=i;
                return
            end;
        end;
        r=0;
    end


    function x=GetData(ftype,num)
        if nargin<2
            num=1;
        end;
        num=uint64(num);
        x=[];
        %         disp(['GetData ' num2str(ftype)]);
        switch ftype
            case 2  % short
                x=typecast(d(p:p+num*2-1),'int16');
                p=p+2*num;
            case 3  % long
                x=typecast(d(p:p+num*4-1),'int32');
                p=p+4*num;
            case 4  % ushort
                x=typecast(d(p:p+num*2-1),'uint16');
                p=p+2*num;
            case 5  % ulong
                x=typecast(d(p:p+num*4-1),'uint32');
                p=p+4*num;
            case 6  % float
                x=typecast(d(p:p+num*4-1),'single');  % Takes 4 s for 142 M elements
                p=p+4*num;
            case 7  % double
                x=typecast(d(p:p+num*8-1),'double');
                p=p+8*num;
            case 8  % boolean
                x=d(p:p+num-1);
                p=p+num;
            case 9  % char
                x=char(d(p:p+num-1));
                p=p+num;
            case 10  % octet
                x=(d(p:p+num-1));
                p=p+num;
            case 11  % int64
                x=typecast(d(p:p+num*8-1),'int64');
                p=p+8*num;
            case 12  % uint64
                x=typecast(d(p:p+num*8-1),'uint64');
                p=p+8*num;
            case 15  % Struct
                PutStr('struct');
                StructNameLength=GetLLong;
                NumFields=GetLLong;
                x=[];
                for i=1:NumFields
                    FieldNameLength(i)=GetLLong;
                    FieldType(i)=GetLLong;
                end;
                StructName=GetString(StructNameLength);
                PutStr(StructName);
                PutNewline; PutTabs;
                for i=1:NumFields
                    %                     FieldNameLen=FieldNameLength(i);
                    FieldName=GetString(FieldNameLength(i));
                    PutStr(FieldName);
                    x(i)=GetData(FieldType(i));
                    PutNewline; PutTabs;
                end;
            case 18 % string
                length=GetLong;
                x=char(d(p:p+length-1)');
                PutVal(x); PutNewline;
                p=p+uint64(length);
                
            case 20  % Array
                ArrayType=GetLLong;
                if ArrayType==15  % Struct is special case
                    StructNameLength=GetLLong;
                    NumFields=GetLLong;
                    x=[];
                    for i=1:NumFields
                        FieldNameLength(i)=GetLLong;
                        FieldType(i)=GetLLong;
                    end;
                end;
                ArrayLength=GetLLong;
                
                if ArrayType ~=4
                    PutStr('array of');
                    PutVal(ArrayLength);
                    PutStr(' --type: ');
                    PutStr(dataTypeString{ArrayType});
%                     PutVal(ArrayType);
                end;
                
                if ArrayType==15
                    PutStr('structs');
                    PutNewline;
                    for j=1:ArrayLength
                        OutputOn=j<=maxprint;
                        for i=1:NumFields
                            FieldNameLen=FieldNameLength(i);
                            FieldName=GetString(FieldNameLength(i));
                            FieldTy=FieldType(i);
                            PutTabs;
                            PutStr(FieldName);
                            x(i)=GetData(FieldType(i));
                            PutNewline;
                        end;
                        OutputOn=1;
                    end;
                elseif ArrayType==4
                    OutputOn=0;
                    for j=1:ArrayLength
                        x(j)=GetData(ArrayType);
                    end;
                    OutputOn=1;
                    PutVal(char(x'));
                else
                    % Might be long data
                    if (ArrayLength > 1000)  % try to handle a long array
                        OutputOn=0;
                        x=GetData(ArrayType,ArrayLength);
                        OutputOn=1;
                    else
                        PutNewline;
                        for j=1:ArrayLength
                            OutputOn=j<=maxprint;
                            PutTabs;
                            x(j)=GetData(ArrayType);
                            PutNewline;
                        end;
                        OutputOn=1;
                    end; % long data
                end;
            otherwise
                x=0;
                disp(['Unrecognized data type ' num2str(ftype)]);
        end; % switch
        if (ftype < 15) && OutputOn
            PutVal(x);
        end;
    end % GetData


    function PutStr(s)
        if OutputOn
            mprintf(hs,'%s ',s);
        end;
    end

    function PutTabs
        if OutputOn
            for i=1:level-1
                mprintf(hs,'%s',tabstring);
            end;
        end;
    end

    function PutVal(x)
        if OutputOn
            if isa(x,'char')
                mprintf(hs,'%s ',x);
            else
                mprintf(hs,'%d ',x);
            end;
        end;
    end

    function PutNewline
        if OutputOn
            mprintf(hs,'\n');
        end;
    end

    function s=GetString(len)
        len=uint64(len);
        if len<1
            s=[];
        else
            s=char(d(p:p+len-1)');
            p=p+len;
        end;
    end

    function x=GetLong  
        x=typecast(d(p:p+3),'int32');
        x=swapbytes(x);
        p=p+4;        
    end

    function x=GetLLong % uint32 in version 3, uint64 in version 4
        if version == 3
            x=GetLong;
        else  % version 4 code:
            x=typecast(d(p:p+7),'uint64');
            x=swapbytes(x);
            p=p+8;
        end;
    end

    function x=GetWord
        x=typecast(d(p:p+1),'int16');
        x=swapbytes(x);
        p=p+2;
    end

    function x=GetInt
        x=typecast(d(p:p+1),'int16');
        x=swapbytes(x);
        p=p+2;
    end
    function x=GetByte
        x=d(p);
        p=p+1;
    end

    function mprintf(handles,varargin)
    % function mprintf(handles,varargin) % copy of my utility function to
    % make ReadDM3 self-contained.
    % Write the same formatted text to multiple files.  handles is an array of
    % file handles.  The function fprintf is called multiple times, once for
    % each handle number.  Handles of 0 are ignored.
    for i=1:numel(handles)
        if handles(i)>0
            fprintf(handles(i),varargin{:});
        end;
    end
    end % mprintf
end