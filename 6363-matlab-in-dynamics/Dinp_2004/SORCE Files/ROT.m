                    function rot
% ***************************************************************
%                   P r o g r a m   ROT
% ***************************************************************
%
%  PURPOSE:
%     Resolve numerically differential equation of rotational motion
%     of a body
%                      Jz*d2f/dt2 = Mz(t,f,w)
%     and plots graphics of coordinate, velocity and phase plane.
%     If possible, the program could solve the problem analytically.
%
%  INPUT DATA:
%     Jz   - moment of inertia of the body ;
%     Mz   - rotational moment  Mz = Mz(t,f,w);
%     f0   - initial value of the coordinate ;
%     w0   - initial value of the angular velocity ;
%     Tend - upper bound of the integration ;
%     eps  - precision of the integration ;
%     np   - number of parameters .
%     P{1}, P{2}, ..., P{np} - names of the parameters (array of cells);
%
%  NOTES:
%   1. The coordinate is designed by the symbol 'f' and velocity by 'w';
%   2. The physical names of the parameters are assigned to the
%      cells of the array P like this: P{1}='Jz', P{2}='c',...;
%   3. For analytical solution the values of Tend, eps, np and P are not
%      needed. 
%   4. The parameters Jz, f0 and w0 have to be entered only as
%      strings, even though they represent numbers!
%   5. All the data can be input from file or in interactive mode.
%
%  EXAMPLE of DATA FILE:
%   % Data File for problem ...
%     Jz   = 'Jz'; ( or Jz = '0.15';)
%     Mz   = '-k*w - c*f'; % k, c - parameters
%     f0   = 'f0'; ( or f0 = '0.33';)
%     w0   = 'w0'; ( or w0 = '7';)
%     Tend = 20;
%     eps  = 1.e-8;
%     np   = 3;
%     P{1} = 'Jz';
%     P{2} = 'k';
%     P{3} = 'c';

% ---------------------------------------------------------
%               DATA INPUT OF THE PROBLEM
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
    disp(' ');
    Jz   = input(' Moment of inertia of the body Jz : ','s'      );
    Mz   = input(' Expression of the rotational moment Mz : ','s');
    f0   = input(' Initial coordinate f0 : '                     );
    w0   = input(' Initial velocity w0 : '                       );
    Tend = input(' Upper bound of the integration Tend : '       );
    eps  = input(' Precision of the calculations eps : '         );
    np   = input(' Number of parameters  np : '                  );
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
%            Differential Equation of Motion
% =========================================================

                 syms f w D2f 
                 Mz = subs(Mz, 'w', 'Df');
                 deq = Jz*D2f - Mz;

% ---------------------------------------------------------
%                  ANALYTICAL SOLUTION
% =========================================================

 disp(' ');
 ans = input(' Would you like analytical solution? (Y/N): ','s');
 if ans =='Y' | ans == 'y'
    if ~isstr(f0), f0 = num2str(f0); end % Repairing user
    if ~isstr(w0), w0 = num2str(w0); end % input errors!
    syms f
    inicond = ['f(0)=',f0,',Df(0)=',w0];
    f = dsolve(char(deq), inicond, 't');
    if ~isempty(f)
        disp(' ');
        disp('   Low of Motion   ');
        disp(' ***************** ');
        disp(' ');
        disp('f = '); pretty(f)
        disp(' ');
        fname = input(' Name of file to write solution: ','s');
        save(fname, 'f');
    end
       disp(' ');
       ans = input(' Would you like numerical solution? (Y/N): ','s');
       if ans == 'N' | ans == 'n', return, end 
       f = 'f'; % Clear contents of f
 end

% ---------------------------------------------------------
%                  NUMERICAL SOLUTION
% ========================================================= 

% Input the name of the file-function
disp(' ');
fname = input(' Name of the File-function to be generated: ','s');
flag1 = 'Y';
if exist([cd,'\',fname]) % Search only in current directory!
    disp(' ');
    disp([' A file-function with name ',fname,' already exist !'])
    flag1 = input(' Overwrite it ? (Y/N): ', 's');
end

% ---------------------------------------------------------
%              GENERATING THE FILE-FUNCTION
% ---------------------------------------------------------

if ( flag1 == 'Y' | flag1 == 'y' )
   Mz = subs(Mz,{'f','Df'},{'y(1)','y(2)'});
% Opening the file for writing file-function
   [Fid,mes] = fopen([fname,'.m'],'wt');
% Generating the string with physical parameters: Jz, c ...
   strpar = '';
   for j = 1:np
      strpar = [strpar,',',P{j}];
   end
   titl = input(' Denomination of the Problem: ','s');
%       Writing the headline of the File-function
   fprintf(Fid,['function yt = ',fname,'(t,y',strpar,')\n']);
   fprintf(Fid,['%% ',titl]);
%       Writing the first derivatives
   fprintf(Fid,'\n%% The first derivatives\n');
   fprintf(Fid, '  yt(1) = y(2); \n');
   fprintf(Fid,['  yt(2) = ',char(Mz/Jz),'; \n']);
   fprintf(Fid,'  yt = yt'';\n');
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
% Check-up type of f0 and w0 and correct
% it if needed
if ischar(f0)
    f0 = str2num(f0);
    if isempty(f0), f0 = input(' f0 = '); end
end
if ischar(w0)
    w0 = str2num(w0);
    if isempty(w0), w0 = input(' w0 = '); end
end
while 1
    if flag2 == 1
        disp(' ');
        eps  = input(' Precision of the computations eps: ');
        Tend = input(' Upper bound of the integration Tend: ');
        f0   = input(' Initial coordinate f0: ');
        w0   = input(' Initial velocity w0: ');
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
    y0 = [f0 w0]; % initial conditions
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
    
    tmin  = min(t); 
    tmax  = max(t);
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
    % Coordinate f = f(t)
    figure % 1
    comet(t,y(:,1))
    plot(t,y(:,1),[tmin tmax],[0 0],'k'), grid on
    axis([tmin, tmax, xmin, xmax]);
    set(gca,'FontName','Arial Cyr','FontSize',12);
    title('Low of motion {\phi} = {\phi}({\itt})')
    xlabel('{\itt}'); ylabel('{\phi}'); pause
    % Angular velocity w = w(t)
    figure % 2
    comet(t,y(:,2))
    plot(t,y(:,2),[tmin tmax],[0 0],'k'), grid on
    axis([tmin, tmax, ymin, ymax]);
    set(gca,'FontName','Arial','FontSize',12);
    title('Angular velocity {\omega} = {\omega}({\itt})')
    xlabel('{\itt}'); ylabel('{\omega}'); pause
    % Coordinate and Velocity
    figure % 3
    subplot(2,1,1), plot(t,y(:,1),[tmin tmax],[0 0],'k')
    grid on, axis([tmin, tmax, xmin, xmax]);
    set(gca,'FontName','Arial','FontSize',12);
    title('Low of motion {\phi} = {\phi}(t)')
    subplot(2,1,2), plot(t,y(:,2),[tmin tmax],[0 0],'k')
    grid on, axis([tmin, tmax, ymin, ymax]);
    set(gca,'FontName','Arial','FontSize',12);
    title('Angular velocity {\omega} = {\omega}(t)')
    pause
    % Phase Plane
    figure % 4 
    subplot(1,1,1)
    comet(y(:,1),y(:,2))
    plot(y(:,1),y(:,2), [xmin,xmax],[0 0],'k',...
                  [0 0],[ymin,ymax],'k'), grid on
    axis([xmin, xmax, ymin, ymax]);         
    set(gca,'FontName','Arial Cyr','FontSize',12);
    title(' Phase Plane {\omega} = {\omega}({\phi})')
    xlabel('{\phi}'), ylabel('{\omega}'), pause
    flag2 = 1;
    % close all
    disp(' ');
    ans = input(' Would you like to continue? (Y/N): ','s');
    if ans == 'n' | ans == 'N', break, end
end

%  ***************** End of Program ROT ********************
