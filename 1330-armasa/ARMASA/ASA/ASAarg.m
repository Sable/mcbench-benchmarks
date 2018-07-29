function varargout = ASAarg(arg_in,arg_name,arg_type,varargin)
%ASAARG Input argument arrangement
%   [VAR1,...,VARn] = ASAARG(VARARGIN,NAME_DEF,TYPE_DEF,LIST1,...,LISTm) 
%   assigns values to n variables VARn, using the variable length input 
%   argument list VARARGIN of a function m-file. Variables VARn must be 
%   defined by the cell arrays of strings NAME_DEF and TYPE_DEF, 
%   regarding the order of the output arguments VARn. Cell arrays of 
%   strings LISTm define allowed sequences of input arguments, that could 
%   occur in VARARGIN, by placing a maximum of n arguments, as named by 
%   NAME_DEF, in a desired order. If multiple sequences LISTn have equal 
%   length (referring to an equal number of arguments), the first 
%   sequence is selected that matches the types of arguments defined by 
%   TYPE_DEF. Types are defined by entering names of functions (as 
%   strings in TYPE_DEF), that check an argument by returning either 
%   false (0) or true (1), like ISNUMERIC or ISCHAR. An equal number of 
%   names and types must be defined in corresponding order by NAME_DEF 
%   and TYPE_DEF respectively. Any output argument VARn that does not 
%   occur in the matching sequence is declared empty.
%   
%   In addition, the function control variable 'ASAcontrol' may be added 
%   to the end of NAME_DEF while placing 'isstruct' at the end of 
%   TYPE_DEF. 'ASAcontrol' may not be used in any argument list LISTm, 
%   since ASAARG presumes it is allowed for ASACONTROL to occur at the 
%   end of each list (including an empty list). This feature is 
%   implemented to facilate the use of ASACONTROL, by avoiding an 
%   inconvenient number of allowed input lists, LISTm.
%   
%   Example:
%   
%   After writing the m-file,
%   
%     function [out1,out2] = test(varargin)
%     [out1,out2] = ASAarg(varargin, ...
%        {'arg1';'arg2'},{'isnumeric';'ischar'}, ...
%        {},{'arg2'},{'arg1'},{'arg1;'arg2');
%   
%   calling '[out1,out2] = test(1,'abc')' returns,
%   
%     out1 = 1
%     out2 = abc
%   
%   calling '[out1,out2] = test(1)' returns,
%   
%     out1 = 1
%     out2 = []
%   
%   calling '[out1,out2] = test('abc')' returns,
%   
%     out1 = []
%     out2 = abc
%   
%   calling '[out1,out2] = test' returns,
%   
%     out1 = []
%     out2 = []
%   
%   Other examples can be found in "educational" ARMASA functions.
%   
%   See also: ASACONTROL

n_arg_def = length(arg_name);
n_arg_in = length(arg_in);
n_seq = length(varargin);

if isequal(arg_name{n_arg_def},'ASAcontrol')
   varargin{end+1}={'ASAcontrol'};
   for i = 1:n_seq
      seq = varargin{i};
      seq{end+1} = 'ASAcontrol';
      varargin{end+1} = seq;
   end
   n_seq = 2*n_seq+1;
end

counter = 1;
for i = 1:n_seq
   seq = varargin{i};
   l_seq = length(seq);
   if l_seq == n_arg_in
      seq_match(counter) = i;
      l_seq_match = l_seq;
      counter = counter+1;
   end
end

n_match = counter-1;
i = 0;
if n_match == 0
   caller_stack=dbstack;
   stack_length=length(caller_stack);
   if stack_length==1
      caller='workspace';
   else
      [caller_path caller]=fileparts(caller_stack(2).name);
   end
   error(ASAerr(1,caller));
else
   type_match=zeros(n_arg_def,n_match);
   empty_match=type_match;
   for i=1:n_match
      counter = 0;
      arg_test = varargin{seq_match(i)};
      k=0;
      m=0;
      match=0;
      for k=1:l_seq_match
         while isequal(match,0)
            m=m+1;
            match = isequal(arg_test{k},arg_name{m});
            if match==1
               test = arg_type{m};
               eval(['check=' test '(arg_in{k});']);
               type_match(m,i)=all(check);
            elseif isequal(arg_test{k},'mkempty')
               empty_match(m,i)=1;
               match = 1;
            end
         end
         match =0;
      end
   end
end

sum_type_match=sum(type_match,1);
sum_empty_match=sum(empty_match,1);
full_match=(sum_type_match+sum_empty_match)==l_seq_match;
match_loc=find(full_match);

if isempty(match_loc)
   caller_stack=dbstack;
   stack_length=length(caller_stack);
   if stack_length==1
      caller='workspace';
   else
      [caller_path caller]=fileparts(caller_stack(2).name);
   end
   error(ASAerr(2,caller));
else
   match_loc=match_loc(1);
   k=1;
   for m=1:n_arg_def
      if type_match(m,match_loc)
         varargout{m}=arg_in{k};
         k=k+1;
      elseif empty_match(m,match_loc)
         varargout{m}=[];
         k=k+1;
      else
         varargout{m}=[];
      end
   end
end

function chk = iscellorcharstr(var)

if iscellstr(var) | ischar(var)
   chk = 1;
else
   chk = 0;
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl

