function legend_handle = labelplot( p , o , str , i)
%LABELPLOT Creates an automatic legend based on 'Tag'
%
%  For every plotted data run, set the 'Tag' string to the label of the data.
%  E.g.:     p1 = plot(x,y);
%            p2 = plot(a,b,'Tag','A vs. B');
%            p3 = plot(c,d,'Tag','C vs. D');
%  Calling LABELPLOT will create a legend equivalent to:
%            legend([p2 p3],'A vs. B','C vs. D')
%
%  Optional additional arguments 1 & 2 specify legend attributes: 
%  (see `help legend' for more information)
%    labelplot( <location> )
%    labelplot([], <orientation> )
%
%  <location> defaults to 'northoutside' and <orientation> defaults to 
%  'vertical' except when <location> is 'northoutside' or 'southoutside'.
%
%  Optional argument 3 specifies a legend label:
%    labelplot([],[], <label string> )
%  with a default of the empty string.
%
%  Optional argument 4 specifies a text interpreter:
%    labelplot([],[],[], <interpreter> )
%  where <interpreter> can be 'none' (default), 'tex', or 'latex'.
%
%
% Please report bugs and feature requests for
% this package at the development repository:
%  <http://github.com/wspr/matlabpkg/>
%
% LABELPLOT  v0.5a  2009/22/06  Will Robertson
% Licence appended.

%% Set up default legend placement
% These can/should be adjusted to suit.
if nargin < 1 || isempty(p), p = 'northoutside'; end
if nargin < 2 || isempty(o)
  if isequal(p,'northoutside') || isequal(p,'southoutside')
    o = 'horizontal';
  else
    o = 'vertical';
  end
end
if nargin < 3 || isempty(str), str = ''; end
if nargin < 4 || isempty(i), i = 'none'; end

%% Grab the data plots and their 'Tag' strings, make the legend
% For empty 'Tag's, delete the corresponding data plot from the
% legend index.
ch = findobj(gca,'Type','line','-not','UserData','colourplot:ignore');
strings = get(ch,'Tag');
if length(ch) > 1
  % Remove empty tags:
  legend_index = cellfun('isempty',strings);
  ch = ch(~legend_index);
  strings = strings(~legend_index);
  % Turns out that legends are created first in, last out with
  % respect to the ordering of the respective axes children vector.
  % So we reverse the order to get it back to normal.
  legend_h = legend(ch(end:-1:1),strings(end:-1:1),'location',p,'orientation',o);
  set(legend_h,'interpreter',i);
end

%% Place the legend label
%
% The font and fontsize is the same as the legend, which is inherited from
% the figure. This can be altered by something like
%    set(findobj('Tag','legendtitle'),'FontSize',14)
% but note that savefig.m (same author) will overwrite this kind of thing.

if exist('legend_h','var')==1 && ~isequal(str,'')
  fontname = get(legend_h,'FontName');
  fontsize = get(legend_h,'FontSize');
  text(0.5,1,str,...
    'Parent',legend_h,...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom',...
    'Tag','legendlabel',...
    {'FontName','FontSize'},{fontname,fontsize},...
    'Interpreter',i);
end

%% Outputs

% Don't put a box around the legend:
legend boxoff

if nargout==1
  legend_handle = legend_h;
end

return

% Copyright (c) 2006-2009, Will Robertson, wspr 81 at gmail dot com
% All rights reserved.
%
% Distributed under the BSD licence in accordance with the wishes of the
% Matlab File Exchange.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ''AS IS'' AND ANY
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
% THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
