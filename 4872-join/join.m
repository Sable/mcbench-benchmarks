function s = join(d,varargin)
%S=JOIN(D,L) joins a cell array of strings L by inserting string D in
%            between each element of L.  Meant to work roughly like the
%            PERL join function (but without any fancy regular expression
%            support).  L may be any recursive combination of a list 
%            of strings and a cell array of lists.
%
%For any of the following examples,
%    >> join('_', {'this', 'is', 'a', 'string'} )
%    >> join('_', 'this', 'is', 'a', 'string' )
%    >> join('_', {'this', 'is'}, 'a', 'string' )
%    >> join('_', {{'this', 'is'}, 'a'}, 'string' )
%    >> join('_', 'this', {'is', 'a', 'string'} )
%the result is:
%    ans = 
%        'this_is_a_string'
%
%Written by Gerald Dalley (dalleyg@mit.edu), 2004

if (length(varargin) == 0), 
    s = '';
else
    if (iscell(varargin{1}))
        s = join(d, varargin{1}{:});
    else
        s = varargin{1};
    end
    
    for ss = 2:length(varargin)
        s = [s d join(d, varargin{ss})];
    end
end
