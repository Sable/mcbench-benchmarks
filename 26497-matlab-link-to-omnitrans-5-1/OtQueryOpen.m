% OtQueryOpen Open an Omnitrans query.
%
% Usage:
%    iret = OtQueryOpen(hquery)
%
% IMPORTANT: Always check the return value.
% The return value should be equal to 1, otherwise
% later calls to the OtQuery interface may cause application crashes.
%

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

function iret = OtQueryOpen(hquery)
   if nargout < 1 
      error('OtQueryOpen: always check the return value.');
   end
   iret = Ot('query.open', hquery);
end