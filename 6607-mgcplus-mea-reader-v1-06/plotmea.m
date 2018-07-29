function plotmea(CHINFO,textflag);
% PLOTMEA
%           plotmea(CHINFO[,textflag])
%
%           This function displays measurement data of a CP42 mea-file in
%           several subplots. Different signals of one channel are shown
%           together in one subplot (e. g. Gross, PV1 and PV2 part of a
%           signal are shown together).
%
%           The input argument "textflag" is optional. Its default value is
%           zero. When it is specified with 1, then the location of the
%           change of status is marked. If it is 2, then additionaly the
%           new status value is displayed beside the position.
%           The status is an additional information inside the measurement
%           data. The state of limit value switches, the error and warning
%           state of a measurement channel are combined in a byte value,
%           representing the state of the measurement.
%
%           Typcial Use Case:
%           [a1,a2]=cp42mea;        Read in CP42 measurement data
%           plotmea(a2);            Display measurement data
%
%           Or use:
%           [a1,a2]=cp42mea('y');
%
%           If the signals have a sample rate trigger, the fast measurement
%           rate periods are highlighted yellow.
%
%           Even merged data files can be shown very nice with this function.
%           Example:
%               [a1,a2]=cp42mea(file1);
%               [b1,b2]=cp42mea(file2);
%               plotmea([a2,b2]);

if nargin<2,
    textflag=0;
end
if isempty(CHINFO),                 % No input argument leads outside
    return;
end
if ~isfield(CHINFO,'Subchannel'),
    disp('may be, you try to plot a catman binary file ?!');
    disp('That is not possible with plotmea.m !');
    return;
end

cnt=length(CHINFO);
oldinfo=[-1,-1,-1];
graph=0;

% Evaluate Number of needed Subplots
for p=1:cnt,
    kanal=CHINFO(p).Channelnumber;
    unterkanal=CHINFO(p).Subchannel;
    signal=CHINFO(p).SigTypus;
    newinfo=[kanal,unterkanal,signal];
    
    bed1=~((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)));
    bed2=((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)) & (newinfo(3)==oldinfo(3)));
    
    if bed1 | bed2,
        graph=graph+1;
    end
    oldinfo=newinfo;
end
oldinfo=[-1,-1,-1];

% if more than 6 subplots are needed, the function is left.
if graph>6,
    disp('Too much information for complete graphical presentation');
    return;
end
% Build up the graph
graphakt=0;
for p=1:cnt,
    kanal=CHINFO(p).Channelnumber;
    unterkanal=CHINFO(p).Subchannel;
    signal=CHINFO(p).SigTypus;
    newinfo=[kanal,unterkanal,signal];
    
    bed1=~((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)));
    bed2=((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)) & (newinfo(3)==oldinfo(3)));
    
    if bed1 | bed2,
        graphakt=graphakt+1;
        hold off;
        subplot(graph,1,graphakt);
        % Analyze Time Axis for Sample Rates
        % The analysis is done for each new subplot,
        % because CHINFO can be composed of data
        % of independent mea-Files !
        % (Not the case, when it is called direct from
        % CP42MEA !)
        tx=CHINFO(p).timeax;
        dtx=diff(tx(:).');
        dtx=[dtx(1),dtx];
        
        statusmarke=0;
        if textflag~=0,       
            if isfield(CHINFO(p),'status'),
                stati=CHINFO(p).status;
                dst=[1,diff(stati)];
                kistatus=find(dst~=0);
                if ~isempty(kistatus),
                    xmark=tx(kistatus);
                    ymark=CHINFO(p).data;
                    ymark=ymark(kistatus);
                    labelmark=num2str(stati(kistatus).');
                    statusmarke=1;
                end
            end 
        end
          
        if any(dtx==0),
            disp('At least two Samples with same time stamp !');
        else
            df=round(1 ./dtx);
            fmin=min(df);
            fmax=max(df);
            if fmax~=fmin,
                flimit=0.5*(fmin+fmax);
                idxmin=findgrup(df<flimit,1);
                idxmax=findgrup(df>flimit,1);
                tmin=tx(idxmin);
                tmax=tx(idxmax);
                ymax=max(CHINFO(p).data);
                ymin=min(CHINFO(p).data);
                FL1=[tmin;flipud(tmin)];
                FL2=[tmax;flipud(tmax)];
                YL1=ones(4,size(tmin,2));
                YL1(1,:)=ymin;
                YL1(2,:)=ymin;
                YL1(3,:)=ymax;
                YL1(4,:)=ymax;
                YL2=ones(4,size(tmax,2));
                YL2(1,:)=ymin;
                YL2(2,:)=ymin;
                YL2(3,:)=ymax;
                YL2(4,:)=ymax;
                if size(YL2)==size(FL2),
                    filha=fill(FL2,YL2,'y');
                    set(filha,'EdgeColor','None');
                end
                hold on;
            end
        end

        ploha=plot(CHINFO(p).timeax,CHINFO(p).data,'b-');
        if statusmarke,
            hold on;
            plot(xmark,ymark,'bx');
            if textflag>1
                teha=text(xmark,ymark,labelmark);
                set(teha,'FontSize',9);
            end
            hold off;
        end
        set(gca,'FontSize',8,'Color',[1,1,1]);
        yha=ylabel(CHINFO(p).Unit);
        set(yha,'FontSize',8);
        hti=title(CHINFO(p).ChannelName);
        set(hti,'FontSize',8);
        hold on;
    else
        plot(CHINFO(p).timeax,CHINFO(p).data,'m-');
    end
    oldinfo=newinfo;
end
xha=xlabel('Time [s]');
set(xha,'FontSize',8);
set(gcf,'Name','CP42 measurement file','NumberTitle','Off');

function K=findgrup(a,modus);
% FINDGRUP
%		K=FINDGRUP(A,[MODUS])
%		Start and Endpositions of 1-Groups of the
%       binary vector A are determined.
%       If the optional argument MODUS (Default = 0)
%       is not used, then leading and finishing
%       1-Groups are neglected.
%
%		Example:
%		(1)	:	>> a=[1,1,1,0,0,0,1,1,0,0,0,1,1,1];
%				>> ki=findgrup(a) % or ki=findgrup(a,0)
%
%				ki=[7;
%				    8]
%
%		(2)	:	>> ki=findgrup(a,1)
%
%				ki=[ 1, 7,12;
%				     3, 8,14]

if nargin==1, modus=0; end

a=a(:).';

if modus~=0, a=[0,a,0]; end

if isempty(find(a)) | isempty(find(~a)),
	K=[];
	return;
end

% Where starts and ends Group of 1 ?
d=diff(a);

kmin=find(d>0) + 1; kmin=kmin(:);
kmax=find(d<0) + 1; kmax=kmax-1; kmax=kmax(:);

if a(1)==1, kmax=kmax(2:length(kmax)); end
if a(length(a))==1, kmin=kmin(1:length(kmin)-1); end
K=[kmin,kmax].';
if modus~=0, K=K-1; end			% END OF FINDGRUP

    
    