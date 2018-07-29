% function [datapeaks datavalleys] = findpeak(plotswitch,datain)
% This program finds peaks
% Arguments: 
%   ploswitch: 0 or 1 : disable or enable plots (for debugging)
%   datain: 1D variable
% Dependencies:
% 
% Copyright (c) 2011, Arun Ramakrishnan
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the <organization> nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function [datapeaks datavalleys] = findinflections(plotswitch,datain)
% datain = gconv;
datad1=[diff(datain)];
mp = find(datad1>0);
mn = find(datad1<=0);

datapeaks = [];
for pindex = 1:length(mp)
    [maxvalue, maxindex] = max(datain(mp(pindex):mn(min(find(mn>mp(pindex))))));
    if ~isempty(maxindex)
        datapeaks = cat(1,datapeaks, floor(mean(maxindex))+mp(pindex)-1);
    end
end
datapeaks= unique(datapeaks);

datavalleys = [];
for pindex = 1:length(mn)
    [minvalue, minindex] = min(datain(mn(pindex):mp(min(find(mp>mn(pindex))))));
    if ~isempty(minindex)
        datavalleys = cat(1,datavalleys, floor(mean(minindex))+mn(pindex)-1);
    end
end
datavalleys= unique(datavalleys);

if (plotswitch) 
    plot(1:length(datain),datain,'k-',mp,datain(mp),'b.',mn,datain(mn),'r.',datapeaks,datain(datapeaks),'g.',datavalleys,datain(datavalleys),'c.');
end