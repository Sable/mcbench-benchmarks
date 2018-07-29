function keep(varargin)
%   function keep(var1,var2, ...)
%   "keep" keeps the caller workspace variables of your choice and clear the rest.
%       It compliments "clear" and its usage is similar but only for variables.
%       String matches will work similarly to "clear", e.g. keep var*
%   Examples:    
%   "keep" by itself does nothing and keeps all variables.
%       compare with: "clear" by itself deletes all variables and removes links
%       for global variables to the caller's workspace.
%   "keep global"   will keep all global variables deleting workspace variables
%   "keep global var1" will keep global var1, deleting the remaining global variables
%       while keeping the remaining workspace variables. 
%   "keep global -regexp expr1" will keep global variables matching the regular
%       expression expr1.
%   "keep -regexp expr1" will keep workspace variables matching the regular
%       expression expr1.
%
%   based upon KEEP by Xiaoning (David) Yang 1998, 1999
%   written by Mirko Hrovat 03/10/2005      mhrovat@email.com
%   modified by Mirko Hrovat 06/27/2006
%       - to account for empty sets for variables to be deleted.
%       Differences of this version from the other version of KEEP.
%           - eliminated error message if workspace is empty
%           - insured that global variable links were not removed from the workspace
%           - added support for "global" key word
%           - allowed wildcard and regexp matching
%           - uses setxor, intersect, & union to determine the variable set to be deleted.
sep={''','''};
if nargin==0 || isempty(varargin{1}),       
    return,                         % do nothing if no arguments     
end     
arglist=varargin;                   % list has the list of variables to keep
vars = evalin('caller','who');      % vars has workspace varaibles as well as linked globals
glbls  = who('global');             % glbls has all global variables

if strcmpi(arglist{1},'global')
    %   no more variables listed, delete workspace but keep globals
    if nargin==1 || isempty(arglist{2}),
        lsrs = setxor(vars,intersect(vars,glbls));
            % intersection of vars & glbls gives linked globals
            % xor of vars & linked glbls gives the rest of the workspace
            
    else                    %   keep regular variables and keep only the listed globals
        % kprs are the list of global variables to keep
        kprs = who(arglist{:});
        lsrs = setxor(glbls,kprs);
        if ~isempty(lsrs),  %   if any global lsrs found then add keyword global 
            lsrs = {'global',lsrs{:}};
        end
    end
else                        %   keep listed regular variables and keep all globals
    nargs=length(arglist);
    list=cell(2,nargs);
    list(1,:)=arglist;
    list(2,:)=repmat(sep,[1,nargs]);                % need to add separators to list
    list(2,nargs)={''')'};
    kprs = evalin('caller',['who(''',list{:}]);     % kprs are the list of variables to keep
    % Need to make a union of vars & glbls in case some global variables are
    %   not linked to the workspace in order to get all variables. 
    % union of kprs & glbls gets all variables except those to be deleted
    % union of vars & glbls gets all possible variables
    lsrs = setxor(union(vars,glbls),union(kprs,glbls));
end

% now create the list of loser variables
nargs=length(lsrs);
if nargs>0,                 % only execute if there are variables to lose.
    list=cell(2,nargs);
    list(1,:)=lsrs;
    list(2,:)=repmat(sep,[1,nargs]);        % need to add separators to list
    list(2,nargs)={''')'};
    evalin('caller',['clear(''',list{:}]);
end
%-------------------- the end ----------------------