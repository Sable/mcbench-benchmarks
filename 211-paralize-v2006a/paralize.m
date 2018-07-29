function [varargout]=paralize(funstr,varargin)
%PARALIZE: Parallellization function.
%Inputs:  funstr   - The function to evaluate (multiple times), e.g. 'eig'
%         P1,P2,.. - Input parameters to function given by funstr
%Output:  Q1,Q2,.. - The multidimensional outputs of the function
%Call:    [Q1,Q2,...]=paralize(funstr,P1,P2,...)
%Option:  If paralize is called with the single argument funstr='kill', 
%         all server processes related to current directory are terminated.
%         If the argument is 'hosts' then server hosts will be listed
%Use:     Prior to running paralize, the server function serve has to be
%         started on the computers that are going to serve paralize

%Copyright: Thomas Abrahamsson, Chalmers University of Technology, Sweden
%Written: Dec 30, 1998
%    
%  Fixing a bug in Line 24 (originally 20), which caused, that the example 
%  from the documentation did not work under current Windows
%           Andrzej Karbowski, Warsaw University of Technology, Poland
%         Oct 11, 2006

% --------------------------------------------------------------------------------
%                                                                         Initiate
%                                                                         --------
delete('process*.mat');
if nargin>1 & ~exist(funstr,'file') & ~exist(funstr,'builtin'),error(['Function ' funstr ' doesn''t seam to exist']);end
if exist('lock','file'),delete('lock');end   

% --------------------------------------------------------------------------------
%                                                  Kill the processes if requested
%                                                  or report name of hosts
%                                                  -------------------------------
if nargin==1,
   if strcmp(deblank(lower(funstr)),'kill')
      fclose(fopen('killproc','w'));
      return
   elseif strcmp(deblank(lower(funstr)),'hosts')
      if exist('hostnames','file'),delete('hostnames');end
      fclose(fopen('givename','w'));
      disp('Wait a few secs while I''m collecting info ...')
      disp(' ')
      pause(10)
      disp('========================================================================')
      disp('HOST and computer type (with MATLAB 5.2 LU and Sparse benchmarks)')
      disp('------------------------------------------------------------------------')
      if exist('hostnames','file')
         type hostnames
         delete hostnames
      else
         disp('No host seams to be awake.')
      end
      disp('------------------------------------------------------------------------')
      disp('If same host name occurs more than once, the same host run many sessions')
      disp('========================================================================')
      disp(' ');disp(' ');disp(' ');
      delete('givename');
      return
   end
end
      

% --------------------------------------------------------------------------------
%                                               Unpack the varargin cell structure
%                                               Check dimensions
%                                               ----------------------------------
[n,m_in]=size(varargin);m_out=nargout;
arginstr=[];savestr=[];K=1;
for I=1:m_in
  eval(['P' int2str(I) '=varargin{' int2str(I) '};']);
  arginstr=[arginstr 'P' int2str(I) ','];
  savestr=[savestr 'P' int2str(I) ' '];
  eval(['[i,j,k]=size(P' int2str(I) ');']);
  if (K==1 & k~=1), K=k;end
  if (k~=1 & k~=K),
    error('Arguments must be scalars, two-dimensional matrices or three-dimensional of same size')
  end
end
argoutstr=[];loadstr=[];
for I=1:m_out
  argoutstr=[argoutstr 'Q' int2str(I) ','];
  loadstr=[loadstr 'Q' int2str(I) ' '];
end

arginstr=arginstr(1:length(arginstr)-1);   
argoutstr=argoutstr(1:length(argoutstr)-1);   

if isempty(argoutstr)
   whattodo=[funstr '(' lower(arginstr) ');'];
else
   whattodo=['[' lower(argoutstr) ']=' funstr '(' lower(arginstr) ');'];
end
loadwhat=lower(loadstr);

% --------------------------------------------------------------------------------
%                                 Warning message if no paralellization take place
%                                 ------------------------------------------------
if K==1,
   disp('Input argument''s third dimension is one. Not suitable for parallellization.')
end

% --------------------------------------------------------------------------------
%                                                                Save data to disk
%                                                                -----------------
fprintf(1,'Initiating process: ');
for I=1:K
  if I==K,fprintf(1,[int2str(I) '.']);else,fprintf(1,[int2str(I) ',']);end
  for II=1:m_in,
    eval(['[i,j,k]=size(P' int2str(II) ');'])
    if k==1,
      eval(['p' int2str(II) '=P' int2str(II) ';'])
    else
      eval(['p' int2str(II) '=P' int2str(II) '(:,:,' int2str(I) ');'])
    end      
  end
  eval(['process_no=' int2str(I) ';'])
  eval(['save processin_' int2str(I) ' ' lower(savestr) 'process_no whattodo loadwhat']);
end   
fprintf(1,'\n');

% --------------------------------------------------------------------------------
%                                                 Retreive the results and pack in
%                                                 the cell array varargout
%                                                 --------------------------------
cases=1:K;caseread=0;
fprintf(1,'Reading data of #:  ');
while ~isempty(cases)
   if exist('errormsg','file')
      type('errormsg')
      delete('process_*');
      delete('errormsg')
      error('Paralize terminates');
   end
   files=dir('processout_*.mat');
   if ~isempty(files)
      file=files(1,1).name(:)';
      istat=0;
      eval(['load ' file],'istat=1;')
      if istat~=1
        fprintf(1,[int2str(process_no) ' ']);           
        delete(file);
        for II=1:m_out
          eval(['Q' int2str(II) '(:,:,' int2str(process_no) ')=q' int2str(II) ';'],'keyboard')
        end
        cases(find(cases==process_no))=[];caseread=[caseread, process_no];
      end
   end
end
fprintf(1,'\n');
      
for I=1:m_out
   eval(['varargout{' int2str(I) '}=Q' int2str(I) ';'])
end
