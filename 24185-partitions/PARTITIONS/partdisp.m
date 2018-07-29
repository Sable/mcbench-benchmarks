function [] = partdisp(C,K)
%PARTDISP displays the partition cell array output from PARTITIONS.
% Pass in the result of PARTITIONS for a formatted display to the command
% window.  If a second argument was passed to PARTITIONS, pass the same
% argument to PARTDISP.
%
% Example:
%    
%       C = partitions(['a','b','c'],2); % See help for PARTITIONS
%       partdisp(C,2)
%
%  See also,  celldisp, disp, display, fprintf
%
% Author:  Matt Fig
% Contact:  popkenai@yahoo.com
% Date:  5/19/2009

if nargin>2
    error('A maximum of two input argument is allowed.')
end

if ~iscell(C)
    error('This function is only useful on the output from PARTITIONS.')
end

L = length(C);
fprintf('\n')

if iscell(C{1}{1})
    if ischar(C{1}{1}{1})
        f = '%s ';
        if nargin==1
            fprintf('%s',['The ',num2str(L),' partitions of set {'])
            for ii = 1:length(C{1})
                for jj = 1:length(C{1}{ii})
                    fprintf('%s ',C{1}{ii}{jj})
                end
            end
            fprintf('\b%s\n','}:')
        else
            fprintf('%s',['The ',num2str(L),' partitions of set {'])
            for ii = 1:length(C{1})
                for jj = 1:length(C{1}{ii})
                    fprintf('%s ',C{1}{ii}{jj})
                end
            end
            fprintf('\b%s\n',['} of length ',num2str(K),':'])
        end
    else
        f = '%g ';
        if nargin==1
            disp(['The ',num2str(L),' partitions of set {',...
                num2str([C{1}{1}{:}],'%g '), '}:'])
        else
            fprintf('%s',['The ',num2str(L),' partitions of set {'])
            for ii = 1:length(C{1})
                for jj = 1:length(C{1}{ii})
                    fprintf('%g ',C{1}{ii}{jj})
                end
            end
            fprintf('\b%s\n',['} of length ',num2str(K),':'])
        end
    end

    for ii = 1:length(C)
        for jj = 1:length(C{ii})
            fprintf('{')
            for kk = 1:length(C{ii}{jj})
                fprintf(f,C{ii}{jj}{kk})
            end
            fprintf('\b} ')
        end
        fprintf('\n')
    end
else
    if ischar(C{1}{1})
        f = '%s ';
        if nargin==1
            disp(['The ',num2str(L),' partitions of set {',[C{1}{:}],'}:'])
        else
            disp(['The ',num2str(L),' partitions of set {', [C{1}{:}],...
                '} of length ',num2str(K),':'])
        end
    else
        f = '%g ';
        if nargin==1
            disp(['The ',num2str(L),' partitions of set {',...
                num2str([C{1}{:}],'%g '), '}:'])
        else
            disp(['The ',num2str(L),' partitions of set {',...
                num2str([C{1}{:}],'%g '), '} of length ',num2str(K),':'])
        end
    end

    for ii = 1:length(C)
        for jj = 1:length(C{ii})
            fprintf('{')
            fprintf(f,C{ii}{jj})
            fprintf('\b} ')
        end
        fprintf('\n')
    end
end

fprintf('\n')



