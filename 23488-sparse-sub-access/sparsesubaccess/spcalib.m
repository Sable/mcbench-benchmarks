function ts = spcalib(varargin)
% function t = spcalib()
% function t = spcalib('auto', n) % autocalibration n time, n=3 by default
% function t = spcalib('reset') % Recover the timing set during the session
% function t = spcalib(newT) % Set the new timing
%
% Return the typical running time of each atomic task (mostly sparse
% access) for the specific computer. Make sure no other program do not run
% at the same time
%
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 11-Apil-2009
%              13-Nov-2010, move mexing to build_spidxmex

global TREF;

if nargin>=1
    v1 = varargin{1};
    if isstruct(v1)
        TREF = v1;
    elseif ischar(v1) && ~isempty(strmatch(lower(v1),'auto'))
        
        ntest = 3;
        if nargin>=2
            v2 = varargin{2};
            if isnumeric(v2) && isscalar(v2) && v2>=1
                ntest = floor(v2);
            end
        end
        
        % Prompt user to save the customize time
        msg='Compile mexfile get/setspvalmex?';
        ButtonName = questdlg(msg, 'SPcalib', 'Yes', 'No', 'No');
        if strcmp(ButtonName,'Yes')
            try
                build_spidxmex();
            catch
                warning('Could not compile mex file');
            end
        end
        
        msg='Make sure the computer is not loaded by other applications';
        questdlg(msg, 'SPcalib', 'OK', 'OK');
        drawnow;
        
        fprintf('Auto calibration in progess, please be patient...\n');
         
        n=1e5;
        nz=1e6;
        i=ceil(n*rand(1,nz));
        j=ceil(n*rand(1,nz));
        iminmax=min(maxlinind([n n]),n*n);
        ilin=ceil(iminmax*rand(1,nz));
        s=rand(size(i));
       
        % Allocate time arrays
        tfind=zeros(1,ntest);
        tcreate=zeros(1,ntest);
        treadlin=zeros(1,ntest);
        treadfor=zeros(1,ntest);
        twritefor=zeros(1,ntest);
        tadd=zeros(1,ntest);
        tsetval=zeros(1,ntest);
        tgetval=zeros(1,ntest);
        tinsert=zeros(1,ntest);
        tremove=zeros(1,ntest);
        tismember=zeros(1,ntest);
        
        for l=1:ntest
            
            % ismember
            tic
            ismember([i j],[i j],'rows');
            tismember(l)=toc/numel(i);
            fprintf('.');

            % create sparse
            tic
            S=sparse(i,j,s,n,n);
            tcreate(l)=toc/nnz(S);
            fprintf('.')
            
            % find
            tic
            [I J v]=find(S); %#ok
            tfind(l)=toc/nnz(S);
            fprintf('.');
            
            % read with linear indexes
            tic
            v=S(ilin); %#ok
            treadlin(l)=toc/numel(ilin);
            fprintf('.');
            
            % read with for loop
            tic
            nloop=min(length(i),Inf);
            for k=1:nloop
                s(k) = S(i(k),j(k));
            end
            treadfor(l)=toc/nloop;
            fprintf('.');
            
            % write with for loop
            tic
            nloop=min(length(i),10000);
            for k=1:nloop
                S(i(k),j(k)) = s(k);
            end
            twritefor(l)=toc/nloop;
            fprintf('.');
            
            % add large sparse matrices to a small one
            S=sparse([],[],[],n,n);
            tic
            Sadd = sparse(i,j,s,n,n);
            S = S + Sadd;
            tadd(l)=toc/nnz(S);
            fprintf('.');
            
            % getspvalmex
            [i j]=find(S);
            tic
            s = getspvalmex(S,i(:),j(:));
            tgetval(l)=toc/numel(i)/max(log2(nnz(S)),7);
            fprintf('.');
            
            % setspvalmex
            [i j s]=find(S);
            tic
            S = setspvalmex(S,i(:),j(:),s(:));
            tsetval(l)=toc/numel(s)/max(log2(nnz(S)),7);
            fprintf('.');
            
            % insert new elements
            S=sparse([],[],[],n,n,nz);
            tic
            nloop=min(length(i),10000);
            for k=1:nloop
                S(i(k),j(k)) = s(k);
            end
            tinsert(l)=toc/nloop;
            fprintf('.');
            
            % remove existing elements
            % Use the same n-loop
            % nloop=min(length(i),10000);
            tic
            for k=1:nloop
                S(i(k),j(k)) = 0;
            end
            tremove(l)=toc/nloop;
            fprintf('.');
        end
        
        fprintf('\n');
        
        clear S i j s
        
        TREF = struct('factory', false, ...
            'tcreate', median(tcreate), ...
            'tfind', median(tfind), ...
            'treadlin',  median(treadlin), ...
            'tismember', median(tismember), ...
            'treadfor',  median(treadfor), ...
            'twritefor',  median(twritefor), ...,
            'tadd',  median(tadd), ...
            'tgetval',  median(tgetval), ...
            'tsetval',  median(tsetval), ...
            'tinsert',  median(tinsert), ...
            'tremove',  median(tremove));
        
        fprintf('\n');
        
        disp(TREF);
        
        % Prompt user to save the customize time
        msg='Save the calibration permanently?';
        ButtonName = questdlg(msg, 'SPcalib', 'Yes', 'No', 'No');
        
        % Write to a file
        if strcmp(ButtonName,'Yes')
            path = mfilename('fullpath');
            path = fileparts(path);
            fid = fopen([path filesep 'defaultTref.m'], 'w');
            if fid>0
                contains = {
                    'function tref = defaultTref'
                    '%'
                    '% Return the typical running time of each task'
                    '% This must be customized for each specific computer'
                    '% The structure here is the same as output returned by calling'
                    '% SPCALIB(''auto'')'
                    '%'
                    '% Do not change here'
                    '% Reference factory, obtained from 2007 Sony laptop '
                    '%  tref = struct( ...'
                    '%      ''factory'', true, ...'
                    '%      ''tcreate'', 7.8671e-00, ...'
                    '%      ''tfind'', 5.088857e-008, ...'
                    '%      ''treadlin'', 1.1566e-007, ...'
                    '%      ''tismember'', 1.716785e-007, ...'
                    '%      ''treadfor'', 3.4761e-006, ...'
                    '%      ''twritefor'', 7.439304e-006, ...'
                    '%      ''tadd'', 1.0071e-007, ...'
                    '%      ''tgetval'', 1.2649e-008, ...'
                    '%      ''tsetval'', 1.1009e-008, ...'
                    '%      ''tinsert'', 6.796743e-005, ...'
                    '%      ''tremove'', 5.114582e-005);'
                    sprintf('%% Create date: %s', datestr(now))
                    ''
                    ' tref = struct( ...'
                            '     ''factory'', false, ...'
                    sprintf('     ''tcreate'', %e, ...', TREF.tcreate)
                    sprintf('     ''tfind'', %e, ...', TREF.tfind)
                    sprintf('     ''treadlin'', %e, ...', TREF.treadlin)
                    sprintf('     ''tismember'', %e, ...', TREF.tismember)
                    sprintf('     ''treadfor'', %e, ...', TREF.treadfor)
                    sprintf('     ''twritefor'', %e, ...', TREF.twritefor)
                    sprintf('     ''tadd'', %e, ...', TREF.tadd)
                    sprintf('     ''tgetval'', %e, ...', TREF.tgetval)
                    sprintf('     ''tsetval'', %e, ...', TREF.tsetval)
                    sprintf('     ''tinsert'', %e, ...', TREF.tinsert)
                    sprintf('     ''tremove'', %e);', TREF.tremove)
                    ''
                    'end'
                    };
                count = fprintf(fid, '%s\n',contains{:});
                if count<sum(cellfun(@length,contains)+1)
                    error('Could not save defaultTref.m');
                end
            else
                error('Could not save defaultTref.m');
            end
            fclose(fid);
            drawnow;
        end
        
    else
        TREF = [];
    end
    
end

% Factory tune
if isempty(TREF)
    TREF = defaultTref();
end

ts = TREF;

end