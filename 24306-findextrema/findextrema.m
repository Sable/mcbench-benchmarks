function [iHi,iLo,iCr] = findextrema(x)
%FINDEXTREMA find indices of local extrema and zero-crossings.
%   [IMAX,IMIN,ICRS] = FINDEXTREMA(X) returns the indices of local maxima
%   in IMAX, minima in IMIN and zero-crossing in ICRS for input vector X.
%
%   Example:
%       x = [0 1 0 0 -1 -1 -2 -2 1 0];
%       [i1,i2,i3] = findextrema(x)
%       % Returns:
%       %   i1 = 2 9
%       %   i2 = 8
%       %   i3 = 1 4 8 10
%
%   See also FIND.

% Siyi Deng; 05-29-2009;
% sdeng@uci.edu; UCI HNL;

%% BSD license;
% Copyright (c) 2009, Siyi Deng;
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
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

%% Generate Plot for demo;
% x = [1 2 1 3 3 3 3 4 4 4 4 3 3 3 2 2 2 1 3 3 2 2 6 6 6 5 5 4 4 4 1 1 2]-3;
% figure; plot(x); set(gca,'xtick',0:numel(x)+2); ylim([-4 4])
% [iP,iT,iC] = findextrema(x),
% hold on; plot(iP,x(iP),'r*'); plot(iT,x(iT),'g*'); plot(iC,x(iC),'ks');
% legend({'Data','Peak','Trough','Zero-Crossing'},'location','NorthWest'); 

%% Code starts here;
if ~isvector(x), error('Input must be a vector;'); end
dx = diff(x);
gz = dx > 0;
lz = dx < 0;
ez = dx == 0;
hi = gz(1:end-1) & lz(2:end); 
hasCorner = any(ez);
if hasCorner
    cornerVec = double(gz(1:end-1) & ez(2:end))+...
        double(ez(1:end-1) & lz(2:end)).*2+...
        double(ez(1:end-1) & gz(2:end)).*110+...
        double(lz(1:end-1) & ez(2:end)).*100;
    cornerLoc = find(cornerVec);
    cornerType = diff(cornerVec(cornerLoc));
    n = find(cornerType == 1); % plateu;
    hi(ceil((cornerLoc(n+1)+cornerLoc(n))/2)) = true;
end
iHi = find(hi)+1;
if nargout > 1
    lo = gz(2:end) & lz(1:end-1);
    if hasCorner
        u = find(cornerType == 10); % valley;
        lo(ceil((cornerLoc(u+1)+cornerLoc(u))/2)) = true;
    end
    iLo = find(lo)+1;
end
if nargout > 2
    xc = (x(1:end-1).*x(2:end)) < 0;
    xz = false(length(x)+2,1);
    xz(2:end-1) = x == 0;
    if any(xz)
        xc(fix((find(~xz(1:end-1) & xz(2:end))+...
            find(~xz(2:end) & xz(1:end-1)))/2)) = true;
    end
    iCr = find(xc);
end

end % FINDEXTREMA;

