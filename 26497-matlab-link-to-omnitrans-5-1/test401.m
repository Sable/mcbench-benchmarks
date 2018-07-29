% test401. Scratch Test more complex Omnitrans queries.

% OtMatlab: Matlab interface to the Omnitrans transport planning software

% Copyright (c) 2008, VORtech Computing
% Copyright (c) 2010, Omnitrans International

% All rights reserved.

% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:

%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of VORtech Computing and Omnitrans International nor the names 
%       of its contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
      
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

% 2006-06-06 Created (Johan Meijdam, VORtech)

function test401()
dbdir = 'C:\Obj\BOSS_offline\basis20060410\NWB2005-II';

olddir = pwd;
eval(['cd ''' dbdir '''']);
OtStart();

% test query
width = 10;
begin_time = 1345;
end_time = 1355;
sql = ['SELECT control."controlnr", ' ...
   'c5d1."time", ' ...
   'c5d1."monload", ' ...
   'c5d1."monspeed" ' ...
   'FROM ' ...
   '"..\selectionobjects" sel, ' ...
   '"..\control2link" c2l, ' ...
   '"..\line" line, ' ...
   'control, ' ...
   'control2data1 c2d1, ' ...
   'control5data1 c5d1 ' ...
   'WHERE ' ...
   'sel."selectionnr" = 0 AND ' ...
   'sel.objectnr = c2l.linknr AND ' ...
   'sel.direction = c2l.direction AND ' ...
   'sel.objectnr = line.linenr AND ' ...
   'line."linetype" = 1 AND ' ...
   'c2l.controlnr = control.controlnr AND ' ...
   'control.controlnr = c2d1.controlnr AND '...
   'control.controlnr = c5d1.controlnr AND ' ...
   'c5d1."purpose" = 1 AND ' ...
   'c5d1."mode" = 1 AND ' ...
   'c5d1."time" >= ' num2str(begin_time) ' AND ' ...
   'c5d1."time" <= ' num2str(end_time) ' AND ' ...
   'c5d1."user" = 1 AND ' ...
   'c2d1."serienr" = 18 AND ' ...
   'control."active" = 1 ' ...
   'ORDER BY control."controlnr", c5d1."time"']

hquery = OtQueryNew(sql);
rv = OtQueryOpen(hquery);
if rv==1
   fd = OtQueryFields(hquery);
   printArr(fd, width);
   if 1 == 1
      maxitems = 10;
      OtQueryFirst(hquery);
      while ~OtQueryEof(hquery) && maxitems > 0
         ga = OtQueryGetAll(hquery);
         printArr(ga, width);
         maxitems = maxitems - 1;
         OtQueryNext(hquery);
      end
   end
   OtQueryClose(hquery);
else
   disp(['OtQueryOpen returned ' num2str(rv)]);
   disp('Query:');
   disp(sql);
end
OtQueryFree(hquery);

OtStop();
eval(['cd ''' olddir '''']);
end

function printArr(arr, width)
line = [];
for i=1:size(arr,1)
   if nargin > 1
      word = sprintf('%*.*s', width, width, arr(i,:));
   else
      word = arr(i,:);
   end
   line = [line ' ' word];
end
disp(line);
end