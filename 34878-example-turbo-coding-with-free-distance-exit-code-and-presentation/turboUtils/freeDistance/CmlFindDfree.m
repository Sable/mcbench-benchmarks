function [ dfree, Nfree, wfree ] = CmlFindDfree( varargin )
%CMLFINDDFREE Summary of this function goes here
%   Detailed explanation goes here

%Setup input files
CmlToGarello(varargin{:});

% determine location of CmlHome
load( 'CmlHome.mat' );

fprintf('Calling Garellos turbo program, this step could take a while\n');
[status output] = system(strcat(cml_home, '\..\turboUtils\freeDistance\turbo.exe'));

splitoutput = regexp(output,'\n','split');

dfree = -1;
Nfree = -1;
wfree = -1;

for i=1:length(splitoutput)
    if strncmp('Error', splitoutput{i}, 5)
        %Error: make sure user knows
        fprintf('WARNING: Call to Turbo seemed to generate error:\n%s\n', splitoutput{i});
    end
    
    if strncmp('dfree', splitoutput{i}, 5)
        dfree = sscanf(splitoutput{i}, 'dfree=%d');
    end    
    
    if strncmp('Nfree', splitoutput{i}, 5)
        Nfree = sscanf(splitoutput{i}, 'Nfree=%d');
    end   
    
    if strncmp('wfree', splitoutput{i}, 5)
        wfree = sscanf(splitoutput{i}, 'wfree=%d');
    end   
end
