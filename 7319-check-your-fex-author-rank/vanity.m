function vanity
% VANITY    Display your File Exchange downloads and rank statistics, 
%           add them to a history file (fex.mat in work directory, by
%           default), and play Handel's Hallelujah chorus if rank has 
%           improved. Modify  code by entering URL of own author page
%           and location of history file, if desired.
% EXAMPLE : vanity (Oh, the FEX code metrics..)  
% AUTHOR  : Dimitri Shvorob, dimitri.shvorob@vanderbilt.edu, 7/15/07
file = [matlabroot '\work\fex.mat'];
page = urlread('http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&objectId=1095920');
d = findby('Downloads:\s(\d*)');
r = findby('Rank:\s(\d*)');
if ~exist(file,'file')
   h = [now d r];      %#ok
   save(file,'h')
   disp('History file created')
   fprintf('Current downloads/rank: %d/%d \n',d,r)
else                   
   load(file) 
   fprintf('Former  downloads/rank: %d/%d \nCurrent downloads/rank: %d/%d \n',h(end,2),h(end,3),d,r)    %#ok
   if r < h(end,3) 
      s = load('handel');
      sound(s.y,s.Fs) 
   end
   h = [h; [now d r]]; %#ok
   save(file,'h')
end   

function[n] = findby(pattern)
s = regexp(page,pattern,'tokens'); 
n = str2double(cell2mat(s{1}));
end

end

