function [varargout]=jpar_client(funstr,varargin)
%jpar_client: Parallellization function.
%Inputs:  funstr   - The function to evaluate (multiple times), e.g. 'eig'
%         P1,P2,.. - Input parameters to function given by funstr
%Output:  Q1,Q2,.. - The multidimensional outputs of the function
%Call:    [Q1,Q2,...]=jpar_client(funstr,P1,P2,...)
%Option:  If jpar_client is called with the single argument funstr='kill', 
%         all server processes related to current directory are terminated.
%         If the argument is 'hosts' then server hosts will be listed
%Use:     Prior to running jpar_client, the server function serve has to be
%         started on the computers that are going to serve jpar_client

%Copyright: Thomas Abrahamsson, Chalmers University of Technology, Sweden
%Written: Dec 30, 1998
%    
%  Fixing a bug in Line 24 (originally 20), which caused, that the example 
%  from the documentation did not work under current Windows
%           Andrzej Karbowski, Warsaw University of Technology, Poland
%         Oct 11, 2006


javaaddpath jpar.jar;
hostname = 'localhost';
rmiRegistryPort = 1099;
client = matlab.jpar.client.JParClientImpl(hostname, rmiRegistryPort);

if ~client.isInitialized
    fprintf(2, 'jpar: client initialization failed\n');
    clear tmp client;
    javarmpath jpar.jar;
    return;
end

% --------------------------------------------------------------------------------
%                                                                         Initiate
%                                                                         --------
if nargin>1 & ~exist(funstr,'file') & ~exist(funstr,'builtin'),error(['Function ' funstr ' doesn''t seam to exist']);end

% --------------------------------------------------------------------------------
%                                                  Kill the processes if requested
%                                                  or report name of hosts
%                                                  -------------------------------
if nargin==1,
   if strcmp(deblank(lower(funstr)),'kill')
      client.killSolvers();
      clear client;
      javarmpath jpar.jar;
      return;
   elseif strcmp(deblank(lower(funstr)),'hosts')
      solvers = client.getSolvers();
      for I=1:length(solvers),
          fprintf(1, 'Free solver is alvalible on: %s\n', char(solvers(I)));
      end;
      fprintf(1, 'Total free solvers alvalible: %d\n', length(solvers));
      clear client;
      javarmpath jpar.jar;
      return;
   end
end
% --------------------------------------------------------------------------------
%                                               Unpack the varargin cell structure
%                                               Check dimensions
%                                               ----------------------------------
[n,m_in]=size(varargin);m_out=nargout;

if m_out == 0,
    m_out = 1;
end

arginstr=[];savestr=[];K=1;
for I=1:m_in
  eval(['P' int2str(I) '=varargin{' int2str(I) '};']);
  arginstr=[arginstr 'P' int2str(I) ','];
  eval(['[i,j,k]=size(P' int2str(I) ');']);
  if (K==1 & k~=1), K=k;end
  if (k~=1 & k~=K),
    error('Arguments must be scalars, two-dimensional matrices or three-dimensional of same size')
  end
end
argoutstr=[];loadstr=[];
for I=1:m_out
  argoutstr=[argoutstr 'Q' int2str(I) ','];
end

arginstr=arginstr(1:length(arginstr)-1);   
argoutstr=argoutstr(1:length(argoutstr)-1);   

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
fprintf(1,'\n');
for I=1:K
  fprintf(1,[int2str(I) ' -- ']);
  for II=1:m_in,
    eval(['[i,j,k]=size(P' int2str(II) ');'])
    if k==1,
      eval(['p' int2str(II) '=P' int2str(II) ';'])
    else
      eval(['p' int2str(II) '=P' int2str(II) '(:,:,' int2str(I) ');'])
    end      
    eval(['pII = p' int2str(II) ';']);
    tmp = convm2java(pII);
    eval(['p' int2str(II) '= tmp;']);
  end
  eval(['caseres = client.createTask(' int2str(m_out) ',''' argoutstr ''',''' funstr ''', {' lower(arginstr) '});']);
  cases(I) = caseres;
end
for II=1:m_in,
    eval(['clear p' int2str(II) ';']);
end
fprintf(1,'\n');

% --------------------------------------------------------------------------------
%                                                 Retreive the results and pack in
%                                                 the cell array varargout
%                                                 --------------------------------

%cases;
fprintf(1,'Reading data...');
client.waitForTask();
fprintf(1,' done\n');
fprintf(1,'\n');

for I=1:K,
    taskID = cases(I);
    res = client.getResult(taskID);
    for II=1:m_out
        eval(['tmp = res(' int2str(II) ');'],'keyboard');
        tmp = convj2matlab(tmp);
        eval(['Q' int2str(II) '(:,:,' int2str(I) ')=tmp;'],'keyboard');
    end
end

for I=1:m_out
   eval(['varargout{' int2str(I) '}=Q' int2str(I) ';'], 'keyboard');
end

% keyboard;

client.clearResults();

clear tmp client;
javarmpath jpar.jar;
