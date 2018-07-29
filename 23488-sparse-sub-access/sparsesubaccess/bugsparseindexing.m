% Script to report the bug of inconsistent
% Behavior when linear indexing sparse matrix on 32-bit platform
% Bruno Luong <b.luong@fogale.fr>

if ~isempty(strfind(computer(),'64'))
    fprintf('Test valid only on 32-bit machine\n')
    return
end

if datenum(version('-date'))>datenum('03-Apr-2009')
    fprintf('This bug could be already fixed after v.2009A (?).\n')  
end

m=66050;
n=65026;
icritical=mod(m*n,2^32)+1;
S=sparse([1 m],[1 n],[1 2],m,n) % Error not occurs for size=3e5

ind=[1 icritical];

disp('ind')
disp(ind)

% Flag to tell if Matlab is buggy
Buggy = 0;

% OK, access both index separately
disp('OK: access both index separately')
disp('S(ind(1))'); 
disp(S(ind(1))) % 1
disp('S(ind(2))');
disp(S(ind(2))); % 2

% Not OK, access both index at the same time
try
    % ??? Index exceeds matrix dimensions.
    disp('Not OK: access both index at the same time');
    disp('S(ind)');
    disp(S(ind)); % error
catch
    Buggy = 1;
    fprintf('\t-> Error: %s\n\n', lasterr());
end

% OK, acess with large double linear index 
disp('OK: acess with large double linear index ');
disp('S(icritical)');
disp(S(icritical)); % 2

disp('OK: acess with "small" double linear index ');
disp('S(icritical-1)');
disp(S(icritical-1)); % 0

% Not OK, acess with large integer linear index 
try
    % ??? Index exceeds matrix dimensions.
    disp('Not OK: acess with large integer linear index ');
    disp('S(int32(icritical))');
    disp(S(int32(icritical))); % error
catch
    Buggy = 1;
    fprintf('\t-> Error: %s\n\n', lasterr());
end

if Buggy
    fprintf('You have a matlab that have a bug in linear indexing\n');
else
    fprintf('Congratulation your sparse linear-index is working fine\n');
end