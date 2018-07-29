%
% exclude(varargin)
%
% Function excludes the figure handles sent in from being closed.  Allowing
% the user to call 'close all' without closing those figures excluded.
%
% To close use include, delete, or 'close all force'.
%
% Uses:  exclude 1 7:10
%        exclude([1:2:10])
%
% See also: INCLUDE
%

% Jeffrey A Ballard, July 23, 2009
% ballard@arlut.utexas.edu

function exclude(varargin)

if nargin<1
    return
end

for ii=1:length(varargin)
    if ischar(varargin{ii})
        hfigs = eval(varargin{ii});
    else
        hfigs = varargin{ii};
    end
    for jj=1:length(hfigs)
        temp = get(hfigs(jj),'CloseRequestFcn');
        setappdata(hfigs(jj),'CloseFunction',temp);
        set(hfigs(jj),'CloseRequestFcn','')
    end
end