function assigns=structvars(varargin)
%STRUCTVARS - print a set of assignment commands that, if executed, would 
%assign fields of a structure to individual variables of the same name (or vice
%versa).
%
%Examples: Given structure myStruct, with fields a,b,c, & d
%
% (1) structvars(myStruct)   %assign fields to variables
% 
%         ans =
% 
%         a = myStruct.a;     
%         b = myStruct.b;     
%         c = myStruct.c;     
%         d = myStruct.d;     
% 
% (2) structvars(3,myStruct)   %split the last result across 3 columns
% 
%         ans =
% 
%         a = myStruct.a;     c = myStruct.c;     d = myStruct.d;     
%         b = myStruct.b;                                             
% 
% (3) structvars(3,myStruct,0)  %assign variables to fields 
% 
%         ans =
% 
%         myStruct.a = a;    myStruct.c = c;    myStruct.d = d;    
%         myStruct.b = b; 
%
%The routine is useful when you want to pass many arguments to a function
%by packing them in a structure. The commands produced by structvars(...)
%can be conveniently copy/pasted into the file editor at the location in the file
%where the variables need to be unpacked.
%
%
%SYNTAX I:
%
%     assigns=structvars(InputStructure,RHS)
% 
%     in:
%         InputStructure: A structure
%         RHS: Boolean. If true (default), dot indexing expressions will be on the 
%             right hand side.
% 
%     out:
% 
%      assigns: a text string containing the commands (see Examples above) 
% 
% 
% 
%        NOTE: If the name of the variable passed as InputStructure cannot be 
%               determined via inputname() a default name of 'S' will be used.
%
%
%SYNTAX II: 
%
%  assigns=structvars(nCols,...)
%
%Same as syntax I, but assignment strings will be split across nCols
%columns.
%
%
% by Matt Jacobson
%
% Copyright, Xoran Technologies, Inc. 2009
%


if isnumeric(varargin{1}), 
    nCols=varargin{1};
    varargin(1)=[];
    idx=2;
else
    nCols=1;
    idx=1;
end
    
nn=length(varargin);
S=varargin{1};
if nn<2, RHS=true; else RHS=varargin{2}; end
    
fields=fieldnames(S);

sname=inputname(idx); 
if isempty(sname), sname='S'; end


if RHS
    
 assigns= cellfun(@(f) [f ' = ' sname '.' f ';     '],fields,'uniformoutput',0);
 
else %LHS
    
 assigns= cellfun(@(f) [ sname '.' f ' = ' f ';    '],fields,'uniformoutput',0);
    
end

L0=length(assigns);
L=ceil(L0/nCols)*nCols;
Template=false(nCols,L/nCols);
Template(1:L0)=true;
Template=Template.';


Table=cell(size(Template));
Table(:)={' '};
Table(Template)=assigns;


for ii=1:nCols,
 TextCols{ii}=strvcat(Table(:,ii));
end


assigns=[TextCols{:}];