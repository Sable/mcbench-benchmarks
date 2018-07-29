function Line=findlyap(MainHandles)
%FINDLYAP  determines the Lyapunov exponents and dimension
%
%    The alogrithm employed in this toolbox for determining Lyapunov
%    exponents is according to the algorithms proposed in
%
%    [1] A. Wolf, J. B. Swift, H. L. Swinney, and J. A. Vastano,
%        "Determining Lyapunov Exponents from a Time Series," Physica D,
%        Vol. 16, pp. 285-317, 1985.
%
%    [2] J. P. Eckmann and D. Ruelle, "Ergodic Theory of Chaos and Strange
%        Attractors," Rev. Mod. Phys., Vol. 57, pp. 617-656, 1985.
%
%    The algorithm given in [1] is used for first-order systems while
%    the QR-based algorithm proposed in [2] is applied for higher order
%    systems.

%   by Steve W. K. SIU, July 5, 1998.


%Print the results to the file every iteration
PrintStep=10;
%Display the results on the screen every iteration
DisplayStep=1;

%Clear the current axis objects
cla;
v=axis;
xc=(v(2)+v(1))/2;	%Center of the axis box [xc,y]
y=(v(4)+v(3))/2;
aW=v(2)-v(1);		%Axis width
x=xc-1/4*aW;

%Display the text "Loading... Please wait!"
th=text(x,y,'Loading... Please wait!','Color','r','FontSize',15,...
   	'FontAngle','italic');
drawnow;
%Clear the bottom text if any
set(MainHandles(1),'String','');

%Get the data stored in 'UserData' of the setting button
DATA=get(MainHandles(4),'UserData');
%Restore the data input by the user
output=DATA(1);		%Output checkbox: "on"=1; "off"=0
LEout=DATA(2);			%Output Lyapunov exponents to file: "yes"=1; "no"=0
LEprec=DATA(3);      %Precision of the output Lyapunov exponents
LDout=DATA(4);			%Output Lyapunov dimension to file: "yes"=1; "no"=0
LDprec=DATA(5);      %Precision of the Lyapunov dimension
IntMethod=DATA(6);	%Integration method: 1=Discrete map, 2=ODE45, 3=ODE23
							% 4=ODE113, 5=ODE23S, 6=ODE15S
InitialTime=DATA(7);	%Initial time
FinalTime=DATA(8);	%Final time
TimeStep=DATA(9);		%Time step
RelTol=DATA(10);		%Relative tolerance
AbsTol=DATA(11);		%Absolute tolerance
plot1=DATA(12);		%Plot imediately: 1="checked", 0="unchecked"
plot2=DATA(13);		%Plot according to specified iterations
ItrNum=DATA(14);		%No. of iteration for updating the plot
Color=DATA(15);		%Line Color option
							%Line color: 1="blue", 2="balck", 3="green", 4="red",
                     %5="yellow", 6="magenta", 7="cyan"
DiscardItr=DATA(16);	%Iterations to be discarded
UpdateStepNum=DATA(17);	%Lyapunov exponents updating steps
linODEnum=DATA(18);	%No. of linearized ODEs
ic=DATA(19:length(DATA));	%Initial conditions

%Get the output file and ODE function names stored in
%'UserData' of the "Start" button.
%Handles(2) is the handle of "Start" button
NAMES=get(MainHandles(2),'UserData');
OutputFile=rmspace(NAMES(1,:));
odefun=rmspace(NAMES(2,:));

%Construct a look-up table for the line colors
COLORS='bkgrymc';
%Map the "Line color" pop-up menu position to the look-up table
LineColor=COLORS(Color);	

%Construct a look-up table for integration methods
Methods=char('Discrete map', 'ode45','ode23','ode113','ode23s','ode15s');
ODEsolver=strcat(Methods(IntMethod,:));

%Dimension of the linearized system (total: d x d ODEs)
d=sqrt(linODEnum);
%Initial conditions for the linearized ODEs
Q0=eye(d);
IC=[ic(:);Q0(:)];
ICnum=length(IC);		%Total no. of initial coniditions
%One iteration: Duration for updating the LEs
Iteration=UpdateStepNum*TimeStep;	
DiscardTime=DiscardItr*Iteration+InitialTime;

%MATLAB's ODE functions will give the intermediate solutions if 
%the duration between the initial time and the final time is only
%one time step, this will slow down the whole iteration process. 
%To avoid this, reduce the time step by half.
if (UpdateStepNum==1 & IntMethod~=3)
   TimeStep=TimeStep/2;
end

T1=InitialTime;
T2=T1+Iteration;
TSpan=[T1:TimeStep:T2];
%Absolute tolerance of each components is set to the same value
options=odeset('RelTol',RelTol,'AbsTol',ones(1,ICnum)*AbsTol);

%Initialize variables
n=0;			%Iteration counter
k=0;			%Effective iteration counter
				% (discarded iterations are not counted)
h=1;			%No. of line handles sets (1 set = d line handles)
delLine=0;  %Indicator for deleting the drawn lines            
Sum=zeros(1,d);
xData=[];
yData=[];
Line=[];
bufferSize=10000; %Max. no. of data can be stored in the buffer before creating a new line.
if ( output & (LEout | LDout) )
   %If the output file cannot be opened, warn the user
   msg=['Unable to open "' sprintf(OutputFile) '".'];
   Warn='errordlg(msg,''ERROR'',''replace''); problem=1;';
   eval('fid=fopen(OutputFile,''wt''); problem=0;',Warn)
   %Construct a look-up table for precision format
   Prec=char('%.4f','%.6f','%.8f','%.10f','%.12f');
   %Map the pop-up menu position to its corresponding format
   LEprecision=strcat(Prec(LEprec,:));
   LDprecision=strcat(Prec(LDprec,:));
   if ~problem
      fprintf(fid,'Time');
      if LEout
         for i=1:d
            Str1=['\tLE%d'];
            fprintf(fid,Str1,i);
         end
      end
      if LDout
         Str2=['\tLD'];
         fprintf(fid,Str2); 
      end
      fprintf(fid,'\n');
   end
else
   problem=0;
end

%Start the stop watch
tic;
%Get the state of the "Stop" button
stop=get(MainHandles(3),'UserData');
if DiscardTime>0
   %Display the text "Discarding transient steps..."
   set(MainHandles(1),'String','Discarding transient steps...');
end

A=[];

%String that contains the integration command
IntegrationStr=['[t,X]=',ODEsolver,'(odefun,TSpan,IC,options);'];
%Main loop
while (~stop & ~problem)
   n=n+1;
   %Integration
   if IntMethod>1
      eval(IntegrationStr);
   else	%If it is a discrete map
      for i=1:UpdateStepNum
         X(i,:)=(feval(odefun,IC))';
      end
   end
   [rX,cX]=size(X);
   L=cX-linODEnum;      %No. of initial conditions for 
                        %the original system
   for i=1:d
      m1=L+1+(i-1)*d;
      m2=m1+d-1;
      A(:,i)=(X(rX,m1:m2))';
   end
   %QR decomposition
   if d>1
      %The algorithm for 1st-order system doesn't require
      %QR decomposition
      [Q,R]=qr(A);
      if T2>DiscardTime
         Q0=Q;
      else
         Q0=eye(d);
      end
   else
      R=A;
   end
      
   
   %Delete the text "Loading...Please wait!" 
   %before the first iteration
   if n==1
      delete(th);
      drawnow;
      %Display the final time
      set(MainHandles(11),'String',FinalTime);
   end
   
  %Any zero diagonal element will cause overflow
  %in the following calculation, so discard this step.
   permission=1;
   for i=1:d
      if R(i,i)==0
         permission=0;
         break;
      end
   end
  %To determine the Lyapunov exponents
   if (T2>DiscardTime & permission)
      k=k+1;
      T=k*Iteration;
      TT=n*Iteration+InitialTime;
      %There are d Lyapunov exponents
      Sum=Sum+log(abs(diag(R))');
      lambda=Sum/T;
      
      %Sort the Lyapunov exponents in descenting order
      Lambda=fliplr(sort(lambda));
      %To calculate the Lyapunov dimension (or Kaplan-Yorke dimension)
      LESum=Lambda(1);			
      LD=0;
      if (d>1 & Lambda(1)>0)
         for N=1:d-1
            if Lambda(N+1)~=0
               LD=N+LESum/abs(Lambda(N+1));
               LESum=LESum+Lambda(N+1);
               if LESum<0
                  break;
               end
            end
         end
      end
      %Store the [x,y] data for plotting
      [rxD,cxD]=size(xData);
      [ryD,cyD]=size(yData);
      if rxD<=bufferSize
         xData=[xData;TT];
         yData=[yData;lambda];
      else
         %When the buffers are full, refresh them
         %Max. size of buffers = 10000 data
         xData=[xData(rxD);TT];
         yData=[yData(ryD,:);lambda];
         h=h+1;		%add one set of line handles
         delLine=0;	%After refreshing the buffers, the
                     % previous drawn lines must not be deleted
      end
      
      if ( output & ~problem & (LEout | LDout) & rem(k,PrintStep)==0)
         fprintf(fid,'%.2f',TT);
         if LEout
            for i=1:d
               Str1=['\t',LEprecision];
               fprintf(fid,Str1,Lambda(i));
            end
         end
         if LDout
            Str2=['\t',LDprecision];
            fprintf(fid,Str2,LD);
         end
         fprintf(fid,'\n');
      end

      %Draw lines immediately if "update the plot immediately" was chosen.
      if (plot1==1 | plot2==1 & rem(k,ItrNum)==0)
         if delLine
            %Clear the previous drawn line if any
            delete(Line(h,:));
         end
      	%Draw d lines      
         for i=1:d
            %Set "Erase Mode" to "none" for increasing speed (less refresh)
            Line(h,i)=line('EraseMode','none','Color',LineColor,...
                      'xData',xData,'yData',yData(:,i));
            %Force MATLAB to draw immediately
            drawnow;
         end
         delLine=1;	%Set a flag to indicate that the lines now can be deleted
      end
      %Display the calculated Lyapunov exponents
      if rem(k,DisplayStep)==0
         set(MainHandles(1),'String',[num2str(Lambda),blanks(3),'( ',num2str(LD),' )']);
      end
   end
   

   %To see whether "Stop" is pressed
   stop=get(MainHandles(3),'UserData');
   
   %Display current time, and time used
   set(MainHandles(10),'String',num2str(round(T2)));		%Current time
   set(MainHandles(12),'String',num2str(round(toc)));		%Used time
   drawnow;
   
   %If calculation is finished or "stop" button is pressed, exit the loop.
   if (stop | T2>=FinalTime)
      %Reset the "Erase mode" to normal
      set(Line,'EraseMode','normal');
      %Show the final results (for making sure the final results being shown if DisplayStep>1)
      if (T2>DiscardTime & permission)
         set(MainHandles(1),'String',[num2str(Lambda),blanks(3),'( ',num2str(LD),' )']);
      end
      break;
   end
   %Update the initial conditions and time span for the next iteration
   if IntMethod>1
      ic=X(rX,1:L);
      T1=T1+Iteration;
      T2=T2+Iteration;
      TSpan=[T1:TimeStep:T2];
   else %For discrete map
      ic=X(UpdateStepNum,1:L);
      T2=T2+Iteration;
   end
   IC=[ic(:);Q0(:)];
end		%End of main loop

if T2>=FinalTime
   set(MainHandles([2,4,13,15]),'Enable','On');
   set(MainHandles(3),'Enable','Off');
end
if (output & ~problem)
   fclose(fid);
end

%----------------Subroutine-----------------------------------
function outStr=rmspace(inStr)
%RMSPACE		Function for removing the beginning and ending
%				spaces of a string

%Remove spaces at the end of the string
outStr=strcat(inStr);
%Delete spaces at the beginning of the string
if ~isempty(outStr)
   while isspace(outStr(1))
   	outStr=outStr(2:length(outStr));
   end
end
