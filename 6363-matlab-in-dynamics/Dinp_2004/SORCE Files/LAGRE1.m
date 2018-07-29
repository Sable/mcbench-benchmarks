                    function lagre1
% ***************************************************************
%                   P r o g r a m   LAGRE1
% ***************************************************************
%
%  PURPOSE:
%    Derive differential equation of motion of a mechanical system 
%    with one degree of freedom by means of Lagrange equation 
%          d/dt(dL/dqt) - dL/dq = QN(t,q,qt)
%    Resolve the equation numerically and plots the graphics
%    of the coordinate, velocity and phase plane.
%    If possible, the program could solve the problem analytically.
%
%  INPUT DATA:
%    L    - expression of the Lagrangian L = L(t,q,qt);
%    QN   - generalized non potential force QN = QN(t,q,qt);
%    q0   - initial value of the coordinate;
%    qt0  - initial value of the velocity;
%    Tend - upper bound of the integration;
%    eps  - precision of the calculations;
%    np   - number of parameters .
%    P{1}, P{2}, ..., P{np} - names of the parameters (array of cells);
%
%  NOTES:
%   1. The coordinate is designed by the symbol 'q' and velocity by 'qt';
%   2. The physical names of the parameters are assigned to the
%      cells of the array P like this: P{1}='m', P{2}='c',...;
%   3. For analytical solution the values of Tend, eps, np and P are not
%      needed.
%   4. Initial values q0, qt0 must to be entered as strings, even though
%      they represent numbers!
%   5. All the data can be input from file or in interactive mode.
% 
%  EXAMPLE of DATA FILE:
%   % Data for problem ...
%    L    = '1/2*a*qt^2 + 9.81*l*cos(q)';
%    QN   = '-k*qt';
%    q0   = '0.5'; ( or q0 = 'q0';)
%    qt0  = '10';  ( or qt0 = 'qt0';)
%    Tend = 20;
%    eps  = 1.e-7;
%    np   = 3;
%    P{1} = 'a';
%    P{2} = 'l';
%    P{3} = 'k';

% ---------------------------------------------------------
%                DATA INPUT OF THE PROBLEM
% =========================================================

 clear
 disp(' ');
 disp(' How will you input the data ?    ');
 disp('     1. From a data file;         ');
 disp('     2. In interactive mode.      ');
 ans = input(' Number of Your choice : '  );
 flag = 0;
 if ans == 1
    while 1
       disp(' ');
       indat = input(' Input the name of the data file :', 's');
       if exist([cd,'\',indat]) % Search only in current directory
          eval(indat);
          flag = 1; break  % Successful
        else               % Unsuccessful
          disp(' ');
          disp([' File ',indat,' not exist!'])
          disp(' You have to:')
          disp(' 1. Enter another DATA file name, or')
          disp(' 2. Input the DATA interactively !')
          ans2 = input(' Your choice, please: ');
          if ans2 == 2, break , end
       end
    end
 end
if flag == 0  
    %Input of the data in-line mode
    L    = input(' Expression of the Lagrangian  L : ','s' );
    QN   = input(' Generalized unpotential force QN : ','s');
    q0   = input(' Initial value of the coordinate q0 : '  );
    qt0  = input(' Initial value of the velocity qt0 : '   );
    Tend = input(' Upper bound of the integration Tend : ' );
    eps  = input(' Precision of the calculations eps : '   );
    np   = input(' Number of parameters  np : '            );
    % Asigning names of the parameters
    if np > 0
       disp(' ');
       disp(' Enter names of the parameters:')
       for i = 1:np
           ii = num2str(i);
           P{i} = input([' Name of parameter P',ii,': '],'s');
       end
    end 
 end
 
% ---------------------------------------------------------
%       Deriving Differential Equation of Motion
% =========================================================

 syms t q qt qtt Dq D2q
 Lqt = diff(L,qt);
 deq = diff(Lqt,q)*qt + diff(Lqt,qt)*qtt + ...
       diff(Lqt,t) - diff(L,q) - QN;
 deq = subs(deq,{qt,qtt},{Dq,D2q});
 deq = simple(deq);
 disp(' ');
 disp('    D i f f e r e n t i a l   E q u a t i o n ')
 disp(' ***********************************************')
 disp(' ');
 disp([' DEq: ', char(deq),' = 0'])
%
% ---------------------------------------------------------
%                  ANALYTICAL SOLUTION
% =========================================================

 disp(' ');
 ans = input(' Would you like analitical solution? (Y/N): ','s');
 if ans =='Y' | ans == 'y'
    if ~isstr(q0) , q0  = num2str(q0) ; end % Repairing user
    if ~isstr(qt0), qt0 = num2str(qt0); end % input errors!   
    inicond = ['q(0)=',q0,',Dq(0)=',qt0];
    q = dsolve(char(deq), inicond, 't');
    if ~isempty(q)
        disp(' ');
        disp('   Low of Motion   ');
        disp(' ***************** ');
        disp(' ');
        disp('q = '); pretty(q)
        disp(' ');
        fname = input(' Name of file to write solution: ','s');
        save(fname, 'q');
    end
       disp(' ');
       ans = input(' Would you like numerical solution? (Y/N): ','s');
       if ans == 'N' | ans == 'n', return, end 
       q = 'q'; % Clear analytical solution from q ! 
 end

% ---------------------------------------------------------
%                  NUMERICAL SOLUTION
% ========================================================= 

% Input the name of the file-function
disp(' ');
fname = input(' Name of the File-function to be generated: ','s');
flag1 = 'Y';
if exist([cd,'\',fname]) % Search only in curent directory!
    disp(' ');
    disp([' A file-function with name ',fname,' already exist !'])
    flag1 = input(' Overwrite it ? (Y/N): ', 's');
end

% ---------------------------------------------------------
%              GENERATING THE FILE-FUNCTION
% ---------------------------------------------------------

if ( flag1 == 'Y' | flag1 == 'y' )
   qtt = solve(deq, 'D2q'); % Second derivative
   qtt = subs(qtt, {q,Dq},{'y(1)','y(2)'}); % Canonization
% Opening the file to write file-function
   [Fid,mes] = fopen([fname,'.m'],'wt');
% Generating the string with physical parameters: m, c ...
   strpar = '';
   for j = 1:np
      strpar = [strpar,',',P{j}];
   end
   disp(' ');
   titl = input(' Denomination of the Problem: ','s');
%       Writing the headline of the File-function
   fprintf(Fid,['function yt = ',fname,'(t,y',strpar,')\n']);
   fprintf(Fid,['%% ',titl]);
%       Writing the first derivatives
   fprintf(Fid,'\n%% The first derivatives\n');
   fprintf(Fid, '  yt(1) = y(2); \n');
   %fprintf(Fid,['  yt(2) = ',char(b/a),'; \n']);
   fprintf(Fid,['  yt(2) = ',char(qtt),'; \n']);
   fprintf(Fid,'  yt = yt''; \n');
   fprintf(Fid,['%% *** End of File-function ',fname,' ***']);
   fclose(Fid);
   edit(fname)
end

% ---------------------------------------------------------
%        INTEGRATION AND VISUALIZATION OF THE REZULTS
% ---------------------------------------------------------

flag2 = 0;
% Initial entering values of the parameters and generating
% the string with parameters 'P{1}, P{2}, ..., P{np}' to be
% passed to the File-function as actual arguments 
if np > 0
   PP = P; % Saving the physical names of the parameters in PP 
   parameters = ' ';
   disp(' ');
   disp(' Input the numerical values of the parameters: ')
   for i = 1:np
       i = num2str(i);
       eval(['P{',i,'}=input([''   '',P{',i,'},'' = '']);']);
       parameters = [parameters,',P{',i,'}'];
   end 
 else
   parameters = [];
end
% Check-up type of q0 and qt0 and correct
% it if needed
if ischar(q0)
    q0 = str2num(q0);
    if isempty(q0), q0 = input(' q0 = '); end
end
if ischar(qt0)
    qt0 = str2num(qt0);
    if isempty(qt0), qt0 = input(' qt0 = '); end
end
while 1
    if flag2 == 1
        disp(' ');
        eps  = input(' Precision of the computations eps: ');
        Tend = input(' Upper bound of the integration Tend: ');
        q0   = input(' Initial coordinate q0: ');
        qt0  = input(' Initial velocity qt0: ');
        if np > 0
          P = PP; % Restoring the names of the parameters !
          disp(' ');
          disp(' Input the numerical values of the parameters: ')
          for i = 1:np
              i = num2str(i);
              eval(['P{',i,'}=input([''   '',P{',i,'},'' = '']);']);
          end 
        end
    end
    y0 = [q0 qt0]; % initial conditions
    options = odeset('AbsTol',eps,'RelTol',100*eps);
    % Choosing of the Solver
    disp('                                        ');
    disp('      Choose the proper Solver:         ');
    disp('  -------------------------------       ');
    disp(' A. Non stiff differential equations    ');
    disp('   1. ode45   - middle precision;       ');
    disp('   2. ode23   - low precision;          ');
    disp('   3. ode113  - from low to upper.      ');
    disp('                                        ');
    disp(' B. Stiff differential equations        ');
    disp('   1. ode15s  - from low to upper;      ');
    disp('   2. ode23s  - low precision;          ');
    disp('   3. ode23t  - middle precision;       ');
    disp('   4. ode23tb - low precision.          ');
    disp('                                        ');
    solver = input(' The name of the Solver: ','s');
   
    % Integration of the Differential Equations
        
    eval(['[t,y] = feval(solver,eval([''@'',fname]),',...
                  '[0 Tend],y0,options',parameters,');']);
    % Plotting graphs
    tmin  = min(t); tmax = max(t);
    y1min = min(y(:,1));
    y1max = max(y(:,1));
    y2min = min(y(:,2));
    y2max = max(y(:,2));
    dy1   = y1max - y1min;
    dy2   = y2max - y2min;
    xmin  = y1min - 0.1*dy1;
    xmax  = y1max + 0.1*dy1;
    ymin  = y2min - 0.1*dy2;
    ymax  = y2max + 0.1*dy2;
    % Coordinate q = q(t)
    figure % 1
    comet(t,y(:,1))
    plot(t,y(:,1),[tmin tmax],[0 0],'k'), grid on
    axis([tmin, tmax, xmin, xmax]);
    set(gca,'FontName','Arial Cyr','FontSize',12);
    title('Low of motion {\itq} = {\itq}({\itt})')
    xlabel('{\itt}'); ylabel('{\itq}'); pause
    % Velocity qt = qt(t)
    figure % 2
    comet(t,y(:,2))
    plot(t,y(:,2),[tmin tmax],[0 0],'k'), grid on
    axis([tmin, tmax, ymin, ymax]);
    set(gca,'FontName','Arial','FontSize',12);
    title('Velocity {\it qt} = {\it qt}({\itt})')
    xlabel('{\itt}'); ylabel('{\it qt}'); pause
    % Coordinate and Velocity
    figure % 3
    subplot(2,1,1), plot(t,y(:,1),[tmin tmax],[0 0],'k')
    grid on, axis([tmin, tmax, xmin, xmax]);
    set(gca,'FontName','Arial','FontSize',12);
    title('Low of motion {\itq} = {\itq}({\itt})')
    subplot(2,1,2), plot(t,y(:,2),[tmin tmax],[0 0],'k')
    grid on, axis([tmin, tmax, ymin, ymax]);
    set(gca,'FontName','Arial','FontSize',12);
    title('Velocity {\it qt} = {\it qt}({\itt})'), pause
    % Phase Plane
    figure % 4
    subplot(1,1,1)
    comet(y(:,1),y(:,2))
    plot(y(:,1),y(:,2), [xmin, xmax],[0 0],'k',...
                  [0 0],[ymin, ymax],'k'), grid on
    axis([xmin, xmax, ymin, ymax]);         
    set(gca,'FontName','Arial Cyr','FontSize',12);
    title(' Phase Plane {\it qt} = {\it qt}({\itq})')
    xlabel('{\itq}'), ylabel('{\it qt}'), pause
    flag2 = 1;
    close all
    disp(' ');
    ans = input(' Would you like to continue? (Y/N): ','s');
    if ans == 'n' | ans == 'N', break, end
end

%  *************** End of Program LAGRE1 ******************
