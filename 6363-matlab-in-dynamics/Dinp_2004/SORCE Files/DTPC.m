                      function dtpc
% *****************************************************************
%                     P r o g r a m    DTPC
% *****************************************************************
%
%  PURPOSE:
%     Resolve numerically differential equations of plane motion 
%     of a particle in polar coordinates
%         m*(rtt-r*ft^2)    = Fr(t,r,f,rt,ft,rtt,ftt),
%         m*(r*ftt+2*rt*ft) = Ff(t,r,f,rt,rt,rtt,ftt)
%     plots trajectory and graphics of coordinates and velocity.
%
%  INPUT DATA:
%     m    - mass of the body ;
%     Fr   - sum of projections of forces on axis [r] ;
%     Ff   - sum of projections of forces on axis [f] ;
%     r0   - initial value of the coordinate r ;
%     f0   - initial value of the coordinate f ;
%     v0   - initial value of velocity ;
%     alfa - angle between v0 and polar axis p;
%     Tend - upper bound of the integration ;
%     eps  - precision of the integration ;
%     np   - number of parameters .
%     P{1}, P{2}, ..., P{np} - names of the parameters (array of cells);
%
%  NOTES:
%   1. The coordinates are designed by the symbols 'r'- radius, 
%      'f'-polar angle. There first derivatives by 'rt', 'ft' and 
%      second by 'rtt', 'ftt';
%   2. If the second derivatives of the coordinates are present in the 
%      right sides of DE's, the problem can be solved only if 'rtt' and
%      'ftt' are present linearly!
%   3. The physical names of the parameters are assigned to the
%      cells of the array P like this: P{1}='m', P{2}='c',...;
%   4. All the data can be input from file or in interactive mode.
%   5. Even the most sample problems can't be solved analytically
%      in polar coordinates!
% 
%  EXAMPLE of DATA FILE:
% % Dynamics of a particle, moving
% % on a horizontal plane under action 
% % of an elastic and an resistance force.
%   m    =  'm';
%   Fr   = '-c*r - k*rt';
%   Ff   = '-k*r*ft';
%   r0   = 'r0';
%   f0   = 'f0';
%   v0   = 'v0';
%   alfa = 'alfa';
%   Tend = 20;
%   eps  = 1.e-8;
%   np   = 3;
%   P{1} = 'm';
%   P{2} = 'c';
%   P{3} = 'k';

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
    m    = input(' Mass of the body m : ','s'             );
    Fr   = input(' Expression of the projection Fr : ','s');
    Ff   = input(' Expression of the projection Ff : ','s');
    r0   = input(' Initial coordinate r0 : '              );
    f0   = input(' Initial coordinate f0 : '              );
    v0   = input(' Initial velocity v0 : '                );
    alfa = input(' Angle alfa : '                         );
    Tend = input(' Upper bound of the integration Tend : ');
    eps  = input(' Precision of the calculations eps : '  );
    np   = input(' Number of parameters  np : '           );
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
%            Differential Equations of Motion 
% =========================================================
 
             syms t r rt rtt f ft ftt
             deq1 = m*(rtt-r*ft^2) - Fr;
             deq2 = m*(r*ftt+2*rt*ft) - Ff;
             
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
% Entering the new variables y1, y2, y3, y4 
   deq1 = subs(deq1, {r,f,rt,ft},{'y(1)','y(2)','y(3)','y(4)'});
   deq2 = subs(deq2, {r,f,rt,ft},{'y(1)','y(2)','y(3)','y(4)'});
% Determinig inercial coefficients and right sides of DE's b1 and b2 
   a11 = maple('coeff',deq1,rtt);
   a12 = maple('coeff',deq1,ftt);
   a21 = maple('coeff',deq2,rtt);
   a22 = maple('coeff',deq2,ftt);
   b1 = -subs(deq1,{rtt,ftt},{'0','0'});
   b2 = -subs(deq2,{rtt,ftt},{'0','0'});
% Opening the file for writing file-function
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
   fprintf(Fid,['%% ',titl,'\n']);
%       Determing inertial matrix A and vector b   
   fprintf(Fid,'%% Inertial matrix A \n');
   fprintf(Fid,[' A(1,1) = ', char(a11),';\n']);
   fprintf(Fid,[' A(1,2) = ', char(a12),';\n']);
   fprintf(Fid,[' A(2,1) = ', char(a21),';\n']);
   fprintf(Fid,[' A(2,2) = ', char(a22),';\n']);
   fprintf(Fid,'%% Rigth sides of DE''s \n');
   fprintf(Fid,[' b(1) = ', char(b1),';\n']);
   fprintf(Fid,[' b(2) = ', char(b2),';\n']);
%       Writing the first derivatives
   fprintf(Fid,'%% The first derivatives\n');
   fprintf(Fid,' a = A\\b'';\n');
   % Zabelegka: 
   % Kogato silite Fr i Ff ne zavisiat iavno ot uskoreniiata,
   % det(A) = r --> V koordinatnoto nachalo delene na nula !!!
   % Nekorekten metod za chisleno reshenie !!!
   fprintf(Fid,' yt(1) = y(3); \n');
   fprintf(Fid,' yt(2) = y(4); \n');
   fprintf(Fid,' yt(3) = a(1); \n');
   fprintf(Fid,' yt(4) = a(2); \n');
   fprintf(Fid,' yt = yt'';\n');
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
% Check-up type of r0, f0, v0 and alfa 
% and correct it if needed
if ischar(r0)
    r0 = str2num(r0);
    if isempty(r0), r0 = input(' r0 = '); end
end
if ischar(f0)
    f0 = str2num(f0);
    if isempty(f0), f0 = input(' f0 = '); end
end
if ischar(v0)
    v0 = str2num(v0);
    if isempty(v0), v0 = input(' v0 = '); end
end
if ischar(alfa)
    alfa = str2num(alfa);
    if isempty(alfa), alfa = input(' alfa = '); end
end
while 1  
    if flag2 == 1
        disp(' ');
        eps  = input(' Precision of the computations eps: '  );
        Tend = input(' Upper bound of the integration Tend: ');
        r0   = input(' Initial coordinate r0 : '             );
        f0   = input(' Initial coordinate f0 : '             );
        v0   = input(' Initial velocity v0 : '               );
        alfa = input(' Angle alfa : '                        );
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
    inic = [r0 f0 v0*cos(alfa-f0) v0*sin(alfa-f0)/r0]; % initial conditions
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
                  '[0 Tend],inic,options',parameters,');']);

    % Plotting graphs
   
    tmin  = min(t);      tmax  = max(t);
    y1min = min(y(:,1)); y1max = max(y(:,1)); 
    y2min = min(y(:,2)); y2max = max(y(:,2));
    y3min = min(y(:,3)); y3max = max(y(:,3));
    y4min = min(y(:,4)); y4max = max(y(:,4));
    dy1   = y1max - y1min;
    dy2   = y2max - y2min;
    dy3   = y3max - y3min;
    dy4   = y4max - y4min;
    xmin  = y1min - 0.1*dy1; xmax  = y1max + 0.1*dy1;
    Xmin  = y2min - 0.1*dy2; Xmax  = y2max + 0.1*dy2;
    ymin  = y3min - 0.1*dy3; ymax  = y3max + 0.1*dy3;
    Ymin  = y4min - 0.1*dy4; Ymax  = y4max + 0.1*dy4;

    figure % 1
    % Coordinate r
    comet(t, y(:,1))
    plot( t, y(:,1), [tmin,tmax], [0,0], 'k');
    axis([tmin, tmax, xmin, xmax]);
    xlabel('Time {\itt}'); ylabel('{\itr}'); grid;
    title('Coordinate {\itr} = {\itr}({\itt})'); pause;
    figure % 2
    % Phase plane rt = rt(r)
    comet(y(:,1),y(:,3))
    plot( y(:,1),y(:,3), [xmin, xmax], [0,0], 'k',...
                   [0,0],[ymin, ymax], 'k' );
    axis([xmin, xmax, ymin, ymax]);  
    xlabel('Coordinate {\itr}'); ylabel('dr/dt'); grid;
    title('Phase plane {\itrt} = {\itrt}({\itr})'); pause;
    figure % 3
    % Coordinate f
    comet(t, y(:,2))
    plot( t, y(:,2), [tmin, tmax], [0,0], 'k');
    axis([tmin, tmax, Xmin, Xmax]);
    xlabel('Time {\itt}'); ylabel('{\phi}'); grid;
    title('Coordinate {\phi} = {\phi}({\itt})'); pause;
    figure % 4
    % Phase plane ft = ft(f)
    comet(y(:,2),y(:,4))
    plot( y(:,2),y(:,4), [Xmin, Xmax], [0,0], 'k',...
                   [0,0],[Ymin, Ymax], 'k' );
    axis([Xmin, Xmax, Ymin, Ymax]);  
    xlabel('Coordinate {\phi}'); ylabel('d{\phi}/dt'); grid;
    title('Phase plane {\phi}{\itt} = {\phi}{\itt}({\phi})'); pause;
    figure % 5
    % Velocity Vf = Vf(r)
    Vf = y(:,1).*y(:,4);
    Vfmin = min(Vf); Vfmax = max(Vf);
    dVf = Vfmax - Vfmin;
    Vmin = Vfmin - 0.1*dVf;
    Vmax = Vfmax + 0.1*dVf;
    comet(y(:,1),Vf);
    plot( y(:,1),Vf, [xmin, xmax], [0,0], 'k',...
               [0,0],[Vmin, Vmax], 'k');
    axis([xmin, xmax, Vmin, Vmax]);  
    xlabel('Coordinate {\itr}'); ylabel('{\itVf}'); grid;
    title('Velocity {\itVf} = {\itVf}({\itr})'); pause;
    figure % 6
    % Trajectory of the particle
    comet( y(:,1).*cos(y(:,2)), y(:,1).*sin(y(:,2))) 
    polar( y(:,2), y(:,1)), grid on
    title('Trajectory of the particle'); pause;
    figure % 7
    % Velocity
    v = sqrt(y(:,3).^2 + y(:,1).^2.*y(:,4).^2);
    vmin = min(v); vmax = max(v);
    dv = vmax - vmin;
    comet(t, v)
    plot( t, v, [tmin,tmax], [0,0], 'k');
    axis([tmin, tmax, vmin - 0.1*dv, vmax + 0.1*dv]);
    xlabel('{\itt}'); ylabel('{\itv}'); grid;
    title('Velocity {\itv} = {\itv}({\itt})'); pause; close;
    flag2 = 1;
    close all
    disp(' ');
    ans = input(' Would you like to continue? (Y/N): ','s');
    if ans == 'n' | ans == 'N', break, end
end

%  ********************* End of Program DTPC **********************