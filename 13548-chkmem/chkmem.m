function chkmem
% CHKMEM
% This utility measures the size of the largest contiguous block of virtual
% memory available to MATLAB, then recommends solutions to increase its
% size should it be smaller than typical. This is only for the diagnosis of
% memory fragmentation problems just after MATLAB startup.
%
% The recommended solutions can help to reduce the occurence of "Out of Memory"
% errors. See MEMORY function in MATLAB 7.6 and later.
%
% Example:
% chkmem
% MATLAB Memory Fragmentation Detection Utility
% ---------------------------------------------
% Measurement of largest block size:
%   Largest free block is 1157MB, which is close to typical (1200MB) but less than
%   best case (1500MB), therefore it's size **CAN BE INCREASED** and may reduce the
%   occurrence of "Out of Memory" errors if you are experiencing them.
%
% Possible software modules fragmenting MATLAB's memory space:
%  c:\winnt\system32\uxtheme.dll
%
% Recommendations to increase size of largest block:
% * The location of uxtheme.dll may be causing problems. Consider solution 1-1HE4G5,
%   which rebases a group of Windows DLLs. This has some known side effects which you
%   should consider. If you choose to make the changes, restart MATLAB and run
%   this utility again.
% * If the list of software modules above includes DLLs located in the MATLAB
%   installation directory, check your startup.m or matlabrc.m files to see if
%   they are running code that is not essential.
% * If the list of software modules above includes DLLs from applications other than
%   Windows or MATLAB, consider uninstalling the application if it is not essential,
%   then restart MATLAB and run this utility again. A tool such as Process Explorer
%   can help identify the source and manufacturer of DLLs MATLAB is using. You could
%   also contact the software manufacturer to ask if the DLL can be safely rebased.
%
% 3GB switch status:
%   The MATLAB process limit has been detected as is 3071MB, therefore the 3GB switch
%   in your system's boot.ini is SET.
%
% Copyright 2007-2009 The MathWorks, Inc

%% Test platform
if ~strcmp(computer,'PCWIN') % Check for 32-bit Windows
    error('This utility is supported on 32-bit Windows only.');
else

    fprintf('\n');
    fprintf('MATLAB Memory Fragmentation Detection Utility\n');
    fprintf('---------------------------------------------\n');

    str = evalc('feature(''dumpmem'')');
    newlines = regexp(str,'\n');
    memmap=cell(size(newlines,2)-2,4); % Preallocate

    %% Extract info about s/w modules
    for i=4:size(newlines,2)-5
        memmap{i-3,1}=deblank(str(newlines(i-1)+1:newlines(i)-36));
        memmap{i-3,2}=hex2dec(str(newlines(i)-35:newlines(i)-28));
        memmap{i-3,3}=hex2dec(str(newlines(i)-23:newlines(i)-16));
        memmap{i-3,4}=hex2dec(str(newlines(i)-11:newlines(i)-4));
    end

    %% Analyze Largest Block
    fprintf('Measurement of largest block size:\n')

    free=cell2mat(memmap(:,4));
    [largest index]=max(free);
    fprintf('  Largest free block is %dMB, ',floor(largest/2^20));

    if largest >= 1.4e9
        fprintf('which is close to best case (1500MB), therefore\n  cannot be improved.\n');
    else
        if largest >= 1.2e9
            fprintf('which is close to typical (1200MB) but less than\n');
            fprintf('  best case (1500MB), therefore it''s size **CAN BE INCREASED** and may reduce the\n');
            fprintf('  occurrence of "Out of Memory" errors if you are experiencing them.\n');
        else
            fprintf('which is less than typical (1100MB) and much less than\n');
            fprintf('  best case (1500MB), therefore it''s size **CAN BE INCREASED** and may reduce the\n');
            fprintf('  occurrence of "Out of Memory" errors if you are experiencing them.\n');
        end

        %% Cause of fragmentation
        modules=memmap([index-1:index+1],1);
        found=~strcmp(modules,' <anonymous>');

        fprintf('\nPossible software modules fragmenting MATLAB''s memory space:\n');
        foundOnes=modules(found);
        for i=1:length(foundOnes)
            disp(foundOnes{i});
        end

        if isempty(foundOnes)
            fprintf('  No software modules found. It is likely that chkmem is not being run\n')
            fprintf('  immediately after startup. Restart MATLAB and run it again.\n');
        else
            %% Fragmentation Solutions
            fprintf('\nRecommendations to increase size of largest block:\n');
            if ~isempty(cell2mat(strfind(modules,'uxtheme.dll')))
                fprintf('* The location of uxtheme.dll may be causing problems. Consider solution <a href="http://www.mathworks.com/support/solutions/data/1-1HE4G5.html?solution=1-1HE4G5">1-1HE4G5</a>,\n');
                fprintf('  which rebases a group of Windows DLLs. This has some known side effects which you\n');
                fprintf('  should consider. If you choose to make the changes, restart MATLAB and run\n');
                fprintf('  this utility again.\n');
            end
            if ~isempty(cell2mat(strfind(modules,'NETAPI32.dll')))
                fprintf('* The location of NETAPI32.dll may be causing problems. Consider solution <a href="http://www.mathworks.com/support/solutions/data/1-1HE4G5.html?solution=1-1HE4G5">1-1HE4G5</a>,\n');
                fprintf('  which rebases a group of windows DLLs. This has some known side effects which you\n');
                fprintf('  should consider. If you choose to make the changes, restart MATLAB and run\n');
                fprintf('  this utility again.\n');
            end

            if ~isempty(cell2mat(strfind(modules,'wr_nspr4')));
                fprintf('* The location of wr_nspr4.dll may be causing problems, consider <a href="http://www.mathworks.com/support/bugreports/details.html?rp=334120">Bug Report 334120</a>.\n');
            end

            fprintf('* If the list of software modules above includes DLLs located in the MATLAB\n');
            fprintf('  installation directory, check your startup.m or matlabrc.m files to see if\n');
            fprintf('  they are running code that is not essential.\n');

            fprintf('* If the list of software modules above includes DLLs from applications other than\n');
            fprintf('  Windows or MATLAB, consider uninstalling the application if it is not essential,\n');
            fprintf('  then restart MATLAB and run this utility again. A tool such as <a href="http://www.microsoft.com/technet/sysinternals/utilities/ProcessExplorer.mspx">Process Explorer</a>\n');
            fprintf('  can help identify the source and manufacturer of DLLs MATLAB is using. You could\n');
            fprintf('  also contact the software manufacturer to ask if the DLL can be safely rebased.\n');
        end
    end

end

%% 3GB Switch setting information
virtual=virtinfo;
fprintf('\n3GB switch status:\n')
if virtual ==2047
    fprintf('  The MATLAB process limit has been detected as %dMB, therefore the 3GB switch\n',virtual);
    fprintf('  in your system''s boot.ini file is NOT SET. If you add this switch you can gain\n');
    fprintf('  an additional 1GB of memory space for MATLAB. See this <a href="http://www.microsoft.com/whdc/system/platform/server/PAE/PAEmem.mspx">Microsoft Web Page</a>\n');
    fprintf('  describing the /3GB switch (or <a href="http://www.google.com/search?hl=en&q=3gb&btnG=Google+Search">search Google</a>).\n');
else
    fprintf('  The MATLAB process limit has been detected as is %dMB, therefore the 3GB switch\n  in your system''s boot.ini is SET.\n',virtual);
end

function virtualTotal = virtinfo
% Calculates total memory for MATLAB process
str = evalc('feature memstats');
ind = findstr(str,'MB');
LEN = 20;

%     Virtual Memory (Address Space):
%         In Use:                              536 MB (21851000)
%         Free:                               1511 MB (5e78f000)
%         Total:                              2047 MB (7ffe0000)

retval = str((ind(9)-2):-1:ind(9)-LEN);
virtualTotal = str2double(fliplr(retval));

