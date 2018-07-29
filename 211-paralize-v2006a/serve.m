function serve(id,direc)
%SERVE: This function serves the processes initiated by the function PARALIZE
%Use:   Start MATLAB. Then call SERVE and this function will run forever
%       serving the function PARALIZE. It may be terminated by the call 
%       paralize('kill') given from another MATLAB session.
%Input: id  - server identifier - an integer number, unique for every instance
%       dir - (Optional) directory specification. Makes this directory
%             the current
%Call:  serve(id, dir)

% Copyright: Thomas Abrahamsson, Chalmers University of Technology, Sweden
% Written: Dec 30, 1998
%
% Adaptation to current Matlab (R2006b), and multicore Windows environment
% plus some cosmetics:
%            Andrzej Karbowski, Warsaw University of Technology, Poland
%          Oct 21, 2006
%Modified: Oct 23 2006, Fix for mixed Matlab 5, Matlab 6 and Matlab 7 environment /TA 

% --------------------------------------------------------------------------------
%                                                    Change directory if requested
%                                                    -----------------------------
if nargin==2,
   eval(['cd ' direc]);
end
direc=pwd;
chid=int2str(id);
mylockf=['lock' chid ];
rand('state',sum(100*clock)); % every instance should have a different delay 
                              % at the end of the main loop
% --------------------------------------------------------------------------------
%                                                                         Initiate
%                                                                         --------
if exist('killproc','file'), delete('killproc'); end

% --------------------------------------------------------------------------------
%                                                                    Start serving
%                                                                    -------------
disp(['Running SERVE in ' pwd '. Terminate by paralize(''kill'').'])
disp('-'),disp(' ')
while ~exist('killproc','file')
   if exist('givename','file')
      times=servebench;
      fid=fopen('hostnames','at');
      hostname=getenv('HOST');if isempty(hostname),hostname=getenv('COMPUTERNAME');end
      fprintf(fid,[hostname ' (' computer '), bench=[' num2str(times(1)) ',' num2str(times(2)) ']\n']);
      fclose('all');
      pause(15);%Wait until function paralize has done its job
   end
   if ~exist('lock*','file'),
      iret1=0;
      eval('fclose(fopen(mylockf,''w''));','iret1=1;');%If iret=1 someone else was quicker
                                                        %Unfortunately, it doesn't work under Windows
      if ~iret1,
         files=dir('processin_*.mat');
         if ~isempty(files)
            file=files(1,1).name(:)';           
            lfiles=dir('lock*'); 
            locksize=size(lfiles); nlocks=locksize(1);
            if nlocks==1;
               iret2=0;
               eval(['load ' file ';'],'iret2=1;');
               if ~iret2,
                  delete(file);
                  delete(mylockf);
                  disp(['Evaluating ' whattodo ' for process number ' int2str(process_no)]);
                  iret3=0;
                  eval(whattodo,'iret3=1;')
                  if ~iret3,
                     if strcmp(computer,'PCWIN')
                        eval(['save ' direc '\processout_' int2str(process_no) ' process_no ' loadwhat ' -V4'],'disp(123),break')
                     else
                        eval(['save ' direc '/processout_' int2str(process_no) ' process_no ' loadwhat ' -V4'],'break')
                     end
                  else
                     if ~exist('errormsg','file')
                        fid=fopen('errormsg','wt');
                        fprintf(fid,['Host ' getenv('HOST') ' reports:\n']);
                        fprintf(fid,[lasterr '\n']);
                        fclose('all');
                     end
                  end
               else
                  delete(mylockf);
               end
            else
               delete(mylockf);
            end 
         else
            delete(mylockf);
         end
      end
   end
   direc2=pwd;%Update direc if the process has changed the current directory
   if ~strcmp(direc,direc2)
      disp(['Now running SERVE in ' pwd '. Terminate by paralize(''kill'').'])
      direc=direc2;
   end
   pause(rand) % random delay not longer than 1 second for every instance   
end
quit

function times=servebench
%SERVEBENCH  Extract from MATLAB Benchmark
count=5;
% LU
n = 167;A = randn(n,n);tic,for k = 1:count,lu(A);end,times(1) = toc;
% Sparse
n = 36;A = delsq(numgrid('L',n));b = sum(A)';spparms('autommd',0);
tic,for k = 1:count,x = A\b;end,times(2) = toc;
times=10*times/count;
