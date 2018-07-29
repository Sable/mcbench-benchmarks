% test003 Test reading from the link5_2data1 table.

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

% 2006-03-13 Created (Johan Meijdam, VORtech)

function test003()
OtStart();
htable = OtTableNew();
OtTableSetName(htable, [testdir() 'TunnelConstruction\link5_2data1.DB']);
count = 0;
tic;
for i=1:60
   if OtTableOpen(htable) ~= 1
      error('OtTableOpen failed')
   end
   while ~OtTableEof(htable)
      count = count + 1;
      f01 = OtTableGet(htable, 'linknr');
      f02 = OtTableGet(htable, 'purpose');
      f03 = OtTableGet(htable, 'mode');
      f04 = OtTableGet(htable, 'time');
      f05 = OtTableGet(htable, 'user');
      f06 = OtTableGet(htable, 'result');
      f07 = OtTableGet(htable, 'iteration');
      f08 = OtTableGet(htable, 'direction');
      f09 = OtTableGet(htable, 'transitlinenr');
      f10 = OtTableGet(htable, 'load');
      f11 = OtTableGet(htable, 'cost');
      f12 = OtTableGet(htable, 'dynspeed');
      f13 = OtTableGet(htable, 'density');
      OtTableNext(htable);
   end
   OtTableClose(htable);
end
toc
OtTableFree(htable);
OtStop();
disp(['lines: ' num2str(count)]);
end