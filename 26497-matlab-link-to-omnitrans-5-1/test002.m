% test002 Test reading strings from two tables at the same time.

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

% 2006-02-28 Created (Johan Meijdam, VORtech) 

function test002()
   OtStart();
   htable1 = OtTableNew();
   OtTableSetName(htable1, [testdir() 'name.DB']);
   htable2 = OtTableNew([testdir() 'name.DB']);
   if OtTableOpen(htable1) ~= 1 || OtTableOpen(htable2) ~= 1
      error('OtTableOpen failed')
   end

   count = 0;
   while ~OtTableEof(htable1)
      disp(['TABLE1: ' OtTableGet(htable1, 'name')]);
      OtTableNext(htable1);
      if mod(count, 2) == 0
         disp(['TABLE2: ' OtTableGet(htable2, 'name')]);
         OtTableNext(htable2);            
      end
      count = count + 1;
   end

   OtTableClose(htable2);
   OtTableFree(htable2);
   OtTableClose(htable1);
   OtTableFree(htable1);
   OtStop();
end