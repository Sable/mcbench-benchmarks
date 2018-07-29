function Data = read_data(FName)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Title:          Data OUT1 Reader
%   Description:    Reads PZFlex data file into Matlab
%   Author:         Weidlinger
%   Date:           12/09/11
%   Version:        1.0
%
%   History:        1.0         Initial version
%                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set precision of open / close bytes
OCForm = 'int32';

% Open the file
Fid = fopen(FName); % Replace FName with name of flex data file
                    % e.g. 'FILENAME.flxdato'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Headers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read header record 1 open byte
OpenBytes = fread(Fid,1,OCForm);

% Decide precision used in file
if (OpenBytes == 8)
    
    % Single precision
    IntForm = 'int32';
    FloatForm = 'float32';
    
elseif (OpenBytes == 12)
    
    % Double precision
    IntForm = 'int64';
    FloatForm = 'float64';
    
else
    
    % Unknown header format
    disp('Error: Unknown header format.');
    Data = -1;
    return;
    
end;

% Read remainder of header record 1
Header1.Label = fread(Fid,4,'*char')';
Header1.Type = fread(Fid,1,IntForm);
CloseBytes = fread(Fid,1,OCForm);

% Check header and write to main structure
if (OpenBytes ~= CloseBytes)    
    Data = -1;
    return;   
end;

% Save to structure
Data.Header1 = Header1;

% Read header record 2
OpenBytes = fread(Fid,1,OCForm);             
Header2.FType = fread(Fid,20,'*char')';
Header2.FForm = fread(Fid,20,'*char')';
Header2.Date = fread(Fid,80,'*char')';
Header2.Code = fread(Fid,20,'*char')';
Header2.User = fread(Fid,200,'*char')';
Header2.Extra1 = fread(Fid,20,'*char')';
Header2.Extra2 = fread(Fid,20,'*char')';
CloseBytes = fread(Fid,1,OCForm); 

% Check header and write to main structure
if (OpenBytes ~= CloseBytes)    
    Data = -1;
    return;   
end;

% Save to structure
Data.Header2 = Header2;

% Read header record 3
OpenBytes = fread(Fid,1,OCForm);             
Header3.Title = fread(Fid,200,'*char')';
Header3.Tag = fread(Fid,80,'*char')';
CloseBytes = fread(Fid,1,OCForm); 

% Check header and write to main structure
if (OpenBytes ~= CloseBytes)    
    Data = -1;
    return;   
end;

% Save to structure
Data.Header3 = Header3;

% Read header record 4
OpenBytes = fread(Fid,1,OCForm);             
Header4.Version = fread(Fid,1,IntForm);
Header4.NPartitions = fread(Fid,1,IntForm);
Header4.IPartition = fread(Fid,1,IntForm); 
Header4.IntBytes = fread(Fid,1,IntForm);
Header4.RealBytes = fread(Fid,1,IntForm);
Header4.Char1Bytes = fread(Fid,1,IntForm);
Header4.Char2Bytes = fread(Fid,1,IntForm);
Header4.Char3Bytes = fread(Fid,1,IntForm); 
Header4.Extra1 = fread(Fid,1,IntForm); 
Header4.Extra2 = fread(Fid,1,IntForm); 
CloseBytes = fread(Fid,1,OCForm); 

% Check header and write to main structure
if (OpenBytes ~= CloseBytes)    
    Data = -1;
    return;   
end;

% Save to structure
Data.Header4 = Header4;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data records
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialise index
Index = 1;

% Loop through data records
while (feof(Fid) == 0)
    
    % Read data record A
    OpenBytes = fread(Fid,1,OCForm);
    
    % If cannot read openbytes the file end has been reached
    if (isempty(OpenBytes))
        
        break;
        
    end;
    
    % Continue record A
    DRecord(Index).A.Name = fread(Fid,20,'*char')';
    DRecord(Index).A.Length = fread(Fid,1,IntForm);
    DRecord(Index).A.NTmStp = fread(Fid,1,IntForm);
    DRecord(Index).A.Time = fread(Fid,1,FloatForm);
    DRecord(Index).A.NDim = fread(Fid,1,IntForm);
    DRecord(Index).A.IRange = fread(Fid,1,IntForm);
    DRecord(Index).A.JRange = fread(Fid,1,IntForm);
    DRecord(Index).A.KRange = fread(Fid,1,IntForm);
    DRecord(Index).A.IType = fread(Fid,1,IntForm);
    DRecord(Index).A.IPart = fread(Fid,1,IntForm);
    DRecord(Index).A.IExt1 = fread(Fid,1,IntForm); 
    DRecord(Index).A.IExt2 = fread(Fid,1,IntForm); 
    CloseBytes = fread(Fid,1,OCForm);
    
    % Check header
    if (OpenBytes ~= CloseBytes)
        Data = -1;
        return;
    end;
    
    
    % Interpret file type
    if (DRecord(Index).A.IPart == 0)
        
        % File is type 0, Record A and B(1)
        
        % Set data format and size
        if (DRecord(Index).A.IType == 1)
            
            % Read reals
            DataForm = FloatForm;
            
            % Set data size
            NRead = DRecord(Index).A.Length;
            MatSize = [DRecord(Index).A.IRange ...
                DRecord(Index).A.JRange ...
                DRecord(Index).A.KRange];
            
        elseif (DRecord(Index).A.IType == 2)
            
            % Read integers
            DataForm = IntForm;
            
            % Set data size
            NRead = DRecord(Index).A.Length;
            MatSize = [DRecord(Index).A.IRange ...
                DRecord(Index).A.JRange ...
                DRecord(Index).A.KRange];
            
        elseif (DRecord(Index).A.IType < 0)
            
            % Read characters
            DataForm = '*char';
            
            % Set data size
            NRead = DRecord(Index).A.Length * ...
                abs(DRecord(Index).A.IType);
            MatSize = [abs(DRecord(Index).A.IType) ...
                DRecord(Index).A.Length ...
                1];
            
        end;
        
        
        % Read Record B(1)
        OpenBytes = fread(Fid,1,OCForm);
        RawData = fread(Fid,NRead,DataForm)';
        DRecord(Index).B = reshape(RawData,MatSize);
        CloseBytes = fread(Fid,1,OCForm);
    
        % Check header
        if (OpenBytes ~= CloseBytes)
            Data = -1;
            return;
        end;
        
    else
        
        % File is type 1, Record A, A1 and B(2)
        
        % Read Record A1
        OpenBytes = fread(Fid,1,OCForm);
        DRecord(Index).A1.IBegin = fread(Fid,1,IntForm); 
        DRecord(Index).A1.IEnd = fread(Fid,1,IntForm);
        DRecord(Index).A1.JBegin = fread(Fid,1,IntForm); 
        DRecord(Index).A1.JEnd = fread(Fid,1,IntForm);
        DRecord(Index).A1.KBegin = fread(Fid,1,IntForm); 
        DRecord(Index).A1.KEnd = fread(Fid,1,IntForm);
        CloseBytes = fread(Fid,1,OCForm);
    
        % Check header
        if (OpenBytes ~= CloseBytes)
            Data = -1;
            return;
        end;
                
        
        % Set data format and size
        if (DRecord(Index).A.IType == 1)
            
            % Read reals
            DataForm = FloatForm;
            
            % Set data size
            MatSize = [(DRecord(Index).A1.IEnd - DRecord(Index).A1.IBegin + 1) ...
                       (DRecord(Index).A1.JEnd - DRecord(Index).A1.JBegin + 1) ...
                       (DRecord(Index).A1.KEnd - DRecord(Index).A1.KBegin + 1)];
            NRead = MatSize(1) * MatSize(2) * MatSize(3);
            
        elseif (DRecord(Index).A.IType == 2)
            
            % Read integers
            DataForm = IntForm;
            
            % Set data size
            MatSize = [(DRecord(Index).A1.IEnd - DRecord(Index).A1.IBegin + 1) ...
                       (DRecord(Index).A1.JEnd - DRecord(Index).A1.JBegin + 1) ...
                       (DRecord(Index).A1.KEnd - DRecord(Index).A1.KBegin + 1)];
            NRead = MatSize(1) * MatSize(2) * MatSize(3);
            
        elseif (DRecord(Index).A.IType < 0)
            
            % Read characters
            DataForm = '*char';
            
            % Set data size
            MatSize = [abs(DRecord(Index).A.IType) ...
                       (DRecord(Index).A1.IEnd - DRecord(Index).A1.IBegin + 1) ...
                       1];
            NRead = MatSize(1) * MatSize(2);
                  
        end;
       
        
        % Read Record B(2)
        OpenBytes = fread(Fid,1,OCForm);
        RawData = fread(Fid,NRead,DataForm)';
        DRecord(Index).B = reshape(RawData,MatSize);
        CloseBytes = fread(Fid,1,OCForm);
    
        % Check header
        if (OpenBytes ~= CloseBytes)
            Data = -1;
            return;
        end;
        
    end;
    
    
    % If data is character then flip contents of record B
    if (DRecord(Index).A.IType < 0)
        
        DRecord(Index).B = DRecord(Index).B';
        
    end;
    
    
    % Increment index
    Index = Index + 1;
      
    
end;

% Save to structure
Data.DRecord = DRecord';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close the file
fclose(Fid);