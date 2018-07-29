% Weighted nonlinear fit by chi^2 minimazation.
% 
% wnonlinfit returns parameters,errors,chi2dof,probablility and a vector
% containing all chi^2 that accured during the search. If the chi^2/dof
% values are worse than a defined value (default is 2) random changes are
% done to the initial guesses in order to find a better guess.
%
%   [parameters errors chi2dof]=wnonlinfit(x,y,yerr,func,beta0,options)
%   
%
% x,y,yerr are the data variables.
% 
% func is the model that is to be used. It must be a function handle in the
% form func=@(xdata,betav) ... . So that the result of func(x,beta0) is a vector of size(x).
% betav are the variables that are to be fitted. 
% 
% beta0 is the initial guess. 
% 
% Important: All text input is in latex
% 
% Options:
% 
% Options are entered like: wnonlinfit(x,y,yerr,func,beta0,'optionname',value,'optionname2',value2)
% 
% 
% 
% chitol: scalar in ]0,inf[                     Defines chi^2/dof tolerance. 
%                                               Routine searches for better guesses until chi^2<chitol*dof
%                                               Default: 2
% 
% 
% label:{'xaxis' 'yaxis' 'varname1'...}         Defines label of axis and arguments
%                                               Default: {'xaxis' 'yaxis' '$c_1$' '$c_2$'}
% 
% 
% plot: 'on' , true or 'off' , false            Defines whether plot is created. Plotting takes a lot of time)
%                                               Default: true
% 
% 
% header:   'headerstring' or                   Defines header in the legend. Use str if only one coloumn or 
%           {'first col' 'second col'}          cell if multiple coloumns. Use '' for empty coloumn.
%                                               Default: 'Nonlinear Fit'
%                   
% errprec                                       Defines how many numerics
%                                               of value and error are
%                                               printed in the legend.
%                                               Default: 2
% 
% 
% axis: [xmin xmax ymin ymax]			Define axis for plot
%						Default: calculated from data
% 
% format: [ xsize(cm) ysize(cm) ]               Defines size of the plots.
%                                               Default: [16 14]
% 
% 
% position: [xpos ypos]                         Defines position of legend. Use stupid input to swap legend.
%                                               Default: northwest or northeast depending on data
% 
% 
% grid: 'off' or 'y' or 'x' or 'on'             Defines whether and which kind of grid is plotted
%                                               Default: false
% 
% 
% printchi: 'off' or 'on'                       Defines whether chi^2/dof
%                                               is printed in legend
%                                               Default: true
% 
% 
% print: 'on' , true , 1 or 'off' , false , 0   Defines whether information is printed on command window
%                                               Default: true
% 
% 
% 
% Written by: Jannick Weisshaupt (jannick@physik.hu-berlin.de)
% Paramtext by: Franziska Flegel
%
% Feel free to share, change or do whatever you want with this script.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% %%% Example (should run on its own. Just copy to test and understand): 
% 
% 
% beta1=[0 4 10 ];
% beta0=[2 6 12 ];
% 
% fitfunc=@(x,betav) betav(3)*sqrt(2*pi)*abs(betav(2)) *normpdf(x,betav(1),abs(betav(2)));
% 
% % creation of data
% error=0.05;
% x=[0:0.5:10];
% y=fitfunc(x,beta1);
% y=y+randn(size(y))*error;
% yerr=error.*ones(size(y));
% 
% % Labels and options
% textposition=[];
% headercell={'Nonlinear Fit'  '$f(x)=\frac{A_0}{\sqrt{2\pi\sigma^2}}\exp{\frac{-(x-\mu)^2}{2\sigma}}$' ''};
% mylabel={'xaxis','yaxis [cm]','$\mu$','$\sigma$' '$A_0$'};
% 
% % Actual fit
% [beta betaerr chi prob chiminvec]=wnonlinfit(x,y,yerr,fitfunc,beta0...
%     ,'chitol',5,'label',mylabel,'position',textposition,...
%     'header',headercell,...
%     'printchi','off');
% 
% % Print as pdf
%  print -dpdf -cmyk test.pdf 





function [beta,betaerr,chi2dof,prob,chiminvec] = wnonlinfit(x,y,yerr,func,beta0,varargin)
N=length(beta0);

%%%%%%%%%%%%%%%%%%%%%%% Testing %%%%%%%%%%%%%%%%%%%
ytest=func(x,beta0);

if nargin-length(varargin)<5
    error('Few input variables')
end

if length(yerr)==1
    yerr=yerr *ones(size(y));
end
if length(x)~=length(y) || length(y)~=length(yerr)
    error('Data must have same size')
end

if any(size(y)~=size(ytest))
    error('Function values must have same size as y values')
end



if any(yerr==0)
    error('Fool! Errors with value 0 are not allowed.')
end

if any(y+yerr==y)
    warning('MATLAB:wnonlinfit:small_error_warning','Fool! Errors are smaller than machine accuracy.\nThis might lead to very strange results')
end

if any(isnan(ytest)) || any(isinf(ytest))
    error('MATLAB:wnonlinfit:badguess','Test your function fool! Infinite or NAN values encountered with your bad starting guesses.')
end


% Optional arguments

p = inputParser;

p.addParamValue('plot',1);
p.addParamValue('label',[]);
p.addParamValue('chitol',2)
p.addParamValue('position',[])
p.addParamValue('print',1)
p.addParamValue('format',[16 14])
p.addParamValue('grid',false)
p.addParamValue('header','Nonlinear Fit')
p.addParamValue('printchi',true)
p.addParamValue('axis',[]);
p.addParamValue('errprec',2);

p.parse(varargin{:});

stringcell=p.Results.label;
position=p.Results.position;
chitol=p.Results.chitol;
plotbool=p.Results.plot;
printbool=p.Results.print;
gridbool=p.Results.grid;
format=p.Results.format;
textheader=p.Results.header;
chibool=p.Results.printchi;
axisin=p.Results.axis;
errprec=p.Results.errprec;

%%%%%% Convert optional input
if islogical(gridbool)
    if gridbool
        xgridstr='on';
        ygridstr='on';
    else
        xgridstr='off';
        ygridstr='off';
    end
end
if ischar(gridbool)
    if any(strcmpi(gridbool,{'y','yaxis','y-axis','yachse'}))
        xgridstr='off';
        ygridstr='on';
    elseif any(strcmpi(gridbool,{'x','xaxis','x-axis','xachse'}))
        xgridstr='on';
        ygridstr='off';
    elseif any(strcmpi(gridbool,{'off' 'n' 'no' 'non' 'neither'}))
        xgridstr='off';
        ygridstr='off';
    elseif any(strcmpi(gridbool,{'y','yes','ja','oui','si','on','true'}))
        xgridstr='on';
        ygridstr='on';
    else
        warning('MATLAB:locicalvar:inaprinput','Inapropriate input for grid. Standard value off is used')
        xgridstr='off';
        ygridstr='off';
    end
end

plotbool=logicalvar(plotbool,'plot');
printbool=logicalvar(printbool,'print');
chibool=logicalvar(chibool,'printchi');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if printbool==1
    fprintf('\n------------------------------------------ Nonlinear Fitting ------------------------------------------\nDegrees of Freedom=%i',(length(x)-N))
end
i=1;
testbin=0;
dof=(length(y)-N);

if printbool==1
    fprintf('     Iteration:   ')
    fprintf('%i',i)
end
options = optimset('Display','off');


if exist('lsqnonlin','file')
    [betavec(1,:) chiminvec(1,1)]=lsqnonlin(@(betav) (y-func(x,betav))./yerr ,beta0,[],[],options);
else
    [betavec(i,:) chiminvec(i,1)]=fminsearch(@(betav) chi2(x,y,yerr,@(y) func(y,betav)),beta0.*(1+((i-51)/100+1)*randn(size(beta0))),options);
    
end

if chiminvec(1)>dof*chitol
    for i=2:50
        if printbool==1;
            if i<10
                fprintf('\b');
            else
                fprintf('\b\b');
            end
            fprintf('%i',i)
        end

        if exist('lsqnonlin','file')
            [betavec(i,:) chiminvec(i,1)]=lsqnonlin(@(betav) (y-func(x,betav))./yerr ,beta0.*(1+randn(size(beta0))/5),[],[],options);
        else
            [betavec(i,:) chiminvec(i,1)]=fminsearch(@(betav) chi2(x,y,yerr,@(y) func(y,betav)),beta0.*(1+((i-51)/100+1)*randn(size(beta0))),options);
        end



        if chiminvec(i)<dof*chitol+sum(y)*eps
            if printbool==1
                fprintf('     Success (Chi2dof<%0.1f) ',chitol)
            end
            break
        end
        if i==10 && max(func(x,betavec(i,:)))-min(func(x,betavec(i,:)))>10*eps*min(func(x,betavec(i,:)))
            if numel(find(abs((min(chiminvec)-chiminvec)/chiminvec(1))<0.01))>=(numel(chiminvec))

                if printbool==1
                    fprintf('     Success (Same chi^2 (0.1%% Tol.) for 10 iterations)')
                end

                testbin=1;
                break
            end
        end
        if i==22 && max(func(x,betavec(i,:)))-min(func(x,betavec(i,:)))>10*eps*min(func(x,betavec(i,:)))
            if numel(find(abs((min(chiminvec)-chiminvec)/chiminvec(1))<0.05))>=(numel(chiminvec)-2)
                if printbool==1
                    fprintf('     Success (Same chi^2 (1%% Tol.) for 20 iterations)')
                end
                testbin=1;
                break
            end
        end
    end
elseif printbool==1
    fprintf('     Success (Chi2dof<%0.1f)',chitol)
end

[chimin nchimin]=min(chiminvec);
beta=betavec(nchimin,:);

if chimin>dof*chitol+sum(y)*eps && testbin==0
    for i=51:250
        if printbool==1
            if i<100
                fprintf('\b\b');
            else
                fprintf('\b\b\b');
            end
        end
        if printbool==1
            fprintf('%i',i)
        end
        if exist('lsqnonlin','file')
            [betavec(i,:) chiminvec(i,1)]=lsqnonlin(@(betav) (y-func(x,betav))./yerr ,beta0.*(1+((i-51)/100+1)*randn(size(beta0))),[],[],options);
        else
            [betavec(i,:) chiminvec(i,1)]=fminsearch(@(betav) chi2(x,y,yerr,@(y) func(y,betav)),beta0.*(1+((i-51)/100+1)*randn(size(beta0))),options);
        end
        if chiminvec(i,1)<((i-51)/10+1)*dof*chitol
            if printbool==1
                fprintf('     Success (Chi2dof<%0.2f)',((i-51)/10+1)*chitol)
            end
            break
        end

        if i==100 && max(func(x,betavec(i,:)))-min(func(x,betavec(i,:)))>10*eps*min(func(x,betavec(i,:)))
            if numel(find(abs((min(chiminvec)-chiminvec)/min(chiminvec))<0.05))>=(numel(chiminvec)-10)
                fprintf('     Success (Same chi^2 (5%% Tol) for 90 iterations)')
                break
            end
        end

        if i==250
            fprintf('    Did not fulfill criterias before reaching the maximum iteration number')
        end

    end

    [chimin nchimin]=min(chiminvec);
    beta=betavec(nchimin,:);
end


chiminvec=chiminvec/dof;
chi2dof=chimin/dof;
Q=chi2cdf(chimin,dof);
if Q>0.5
    prob=(1-Q)*2;
else
    prob=Q*2;
end

if printbool==1
    fprintf('   Chi2dof=%1.2f  p=%1.2f\n',[chi2dof prob])
end

betaerr=errorfit(x,y,yerr,func,beta);

if any(isnan(betaerr)) && printbool==1
    warning('MATLAB:wnonlinfit:fzeronan','Fzero failed at finding errors. Test your function!')
end



% Plotting


if plotbool==1;

    dtextint = get(0, 'defaultTextInterpreter');
    set(0, 'defaultTextInterpreter', 'latex');

    if isempty(stringcell)
        stringcell={'x-axis' 'y-axis'};
        for i=1:N
            stringcell{i+2}=sprintf('$c_%i$',i);
        end
    end

    N2=length(stringcell)    ;
    if 2<=N2<N+2
        for i=1:N+2-N2
            stringcell{i+N2}=sprintf('$c_%i$',i);
        end
    end

    breiterr=(x(length(x))-x(1))/100;
end
% Residuen
residue=(y-func(x,beta))./yerr;
mresidue=mean(residue);


% Normalverteilungstests
if length(residue)>10 && printbool
    [kstestbin pks]=kstest(residue,[],0.05,'unequal');
    titlestr='\nResidues:\n';
    if kstestbin
        titlestr=[titlestr 'Residues are not standard normally distributed 5%% Signifikanz. p=' num2str(pks,3) '\n' ];
    else
        titlestr=[titlestr 'The null hypothesis that the sample came from a standard normally distributed \npopulation could not be rejected with 5%% significance. p=' num2str(pks,3) '\n' ];
    end

    if exist('swtest','file')
        
        [normtest p]=swtest(residue,0.05,0);
        titlestr=[titlestr '\n'];
        if normtest
            titlestr=[titlestr 'Residues are not normally distributed 5%% Signifikanz. p=' num2str(p,3) '\n' ];
        else
            titlestr=[titlestr 'The null hypothesis that the sample came from a normally distributed \npopulation could not be rejected with 5%% significance. p=' num2str(p,3) '\n' ];
        end


    end

    fprintf(titlestr)
end
if plotbool

    figure(2);
    clf;
    set(gca,'FontSize',12)
    resfig=plot(x,residue,'ko');
    hold on
    plot(x,mresidue*ones(size(x)),'r')
    hold off


    axisx1=(min(x) -(max(x)-min(x))/30);
    axisx2=(max(x) +(max(x)-min(x))/30);

    axisy1=min(residue) -(max(residue)-min(residue))/40;
    axisy2=max(residue) +(max(residue)-min(residue))/40;

    axis([axisx1 axisx2 axisy1 axisy2])


    xlabel(stringcell{1},'fontsize',16)
    ylabel('Residues','fontsize',16)
    legend('Residues','Mean of residues','Location','NorthOutside')
    set(resfig                            , ...
        'LineWidth'       , 1           , ...
        'Marker'          , 'o'         , ...
        'MarkerSize'      , 5           , ...
        'MarkerEdgeColor' , [.3 .3 .3]  , ...
        'MarkerFaceColor' , [.7 .7 .7]  );

    set(gca, ...
        'Box'         , 'off'     , ...
        'TickDir'     , 'out'     , ...
        'TickLength'  , [.02 .02] , ...
        'XMinorTick'  , 'on'      , ...
        'YMinorTick'  , 'on'      , ...
        'YGrid'       , ygridstr  , ...
        'XGrid'       , xgridstr  , ...
        'XColor'      , [0 0 0], ...
        'YColor'      , [0 0 0], ...
        'LineWidth'   , 1         );

    set(gcf, 'PaperPositionMode', 'manual');    % Macht, dass du das selbst einstellen darfst.
    set(gcf, 'PaperUnits', 'centimeters');                 % Macht, dass du die Groessen in Inches angeben kannst. (Es geht auch z.B. 'centimeters')
    set(gcf, 'PaperSize', format);                       % Einstellen der gewuenschten Groesse.
    set(gcf, 'PaperPosition', [0 0 format(1)*1.05 format(2)]);


    % Fit mit Daten
    figure(1);
    clf;
    set(gca,'FontSize',12)

if isempty(axisin)

    axisx1=(min(x) -(max(x)-min(x))/30);
    axisx2=(max(x) +(max(x)-min(x))/30);

    [miny Iminy]=min(y);
    [maxy Imaxy]=max(y);

    axisy1=min(y)-yerr(Iminy) -(max(y)-min(y))/40;
    axisy2=max(y)+yerr(Imaxy) +(max(y)-min(y))/40;
    
    axisin=[axisx1 axisx2 axisy1 axisy2];
elseif (isnumeric(axisin) && length(axisin)==4)
    axisx1=axisin(1);
    axisx2=axisin(2);
else
    warning('Matlab:wnonlinfit:badaxisin','Bad axis input. Default is used')
    
    axisx1=(min(x) -(max(x)-min(x))/30);
    axisx2=(max(x) +(max(x)-min(x))/30);

    [miny Iminy]=min(y);
    [maxy Imaxy]=max(y);

    axisy1=min(y)-yerr(Iminy) -(max(y)-min(y))/40;
    axisy2=max(y)+yerr(Imaxy) +(max(y)-min(y))/40;
    
    axisin=[axisx1 axisx2 axisy1 axisy2];
end

    xplot=linspace(axisx1,axisx2,500)';
    endfitplot=func(xplot,beta);
    hFit=plot(xplot,endfitplot,'k');

    axis(axisin);

    % Text positioning
    max1=max(endfitplot(1:250));
    max2=max(endfitplot(251:498));
    if isempty(position)  && max1<=max2
        position(1)=axisin(1)+(x(length(x))-x(1))/40;
        position(2)=axisin(4);
    elseif isempty(position) && max1>max2
        position(1)=axisin(2)-(axisin(2)-axisin(1))/2;
        position(2)=axisin(4);
    end


    hold on
    hE=errorbar(x,y,yerr ,'bo','MarkerSize',5);
    hold off
    xlabel(stringcell{1},'Interpreter','Latex','fontsize',16);
    ylabel(stringcell{2},'Interpreter','Latex','fontsize',16);
    strings=cell(1,N);
    for i=1:N
        strings{i}=stringcell{i+2};
    end


    parameters=paramtext(textheader,beta,betaerr,errprec,chi2dof,prob,strings);
    if ~chibool
        parameters=parameters(1:length(parameters)-3);
    end
    
    
    text(position(1),position(2),parameters,'VerticalAlignment',...
        'top','fontsize',14,'BackgroundColor',[0.95 0.95 0.95],'EdgeColor','k','Margin',1)



    set(hFit,'LineWidth',2);

    hE_c                   = ...
        get(hE     , 'Children'    );
    errorbarXData          = ...
        get(hE_c(2), 'XData'       );
    errorbarXData(4:9:end) = ...
        errorbarXData(1:9:end) - breiterr;
    errorbarXData(7:9:end) = ....
        errorbarXData(1:9:end) - breiterr;
    errorbarXData(5:9:end) = ...
        errorbarXData(1:9:end) + breiterr;
    errorbarXData(8:9:end) = ...
        errorbarXData(1:9:end) + breiterr;
    set(hE_c(2), 'XData', errorbarXData);

    set(hE                            , ...
        'LineStyle'       , 'none'      , ...
        'Marker'          , '.'         , ...
        'Color'           , [0.3 0.3 0.3]  );

    set(hE                            , ...
        'LineWidth'       , 1           , ...
        'Marker'          , 'o'         , ...
        'MarkerSize'      , 5           , ...
        'MarkerEdgeColor' , [.3 .3 .3]  , ...
        'MarkerFaceColor' , [.7 .7 .7]  );

    set( gca                       , ...
        'FontName'   , 'Helvetica' );

    set(gca, ...
        'Box'         , 'off'     , ...
        'TickDir'     , 'out'     , ...
        'TickLength'  , [.02 .02] , ...
        'XMinorTick'  , 'on'      , ...
        'YMinorTick'  , 'on'      , ...
        'YGrid'       , ygridstr  , ...
        'XGrid'       , xgridstr  , ...
        'XColor'      , [0 0 0], ...
        'YColor'      , [0 0 0], ...
        'LineWidth'   , 1         );


    set(gcf, 'PaperPositionMode', 'manual');    % Macht, dass du das selbst einstellen darfst.
    set(gcf, 'PaperUnits', 'centimeters');                 % Macht, dass du die Groessen in Inches angeben kannst. (Es geht auch z.B. 'centimeters')
    set(gcf, 'PaperSize', format);                       % Einstellen der gewuenschten Groesse.
    set(gcf, 'PaperPosition', [0 0 format(1)*1.05 format(2)]);


    set(0, 'defaultTextInterpreter', dtextint);

end
beta=beta';
betaerr=betaerr';
end

%%%%%% Other functions

function [x] = logicalvar(x,varargin )
ww=varargin{1};

if isnumeric(x)
    if x==1
        x=true;
    elseif x==0
        x=false;
    else
        warning('MATLAB:locicalvar:inaprinput',['Inapropriate input for ',ww,'. Standard value true is used'])
        x=true;  
    end
end

if ischar(x)
    if any(strcmpi(x,{'y','yes','ja','oui','si','on'}))
        x=true;
    elseif any(strcmpi(x,{'n','no','nein','non','off'}))
        x=false;
    else
        warning('MATLAB:locicalvar:inaprinput',['Inapropriate input for ',ww,'. Standard value true is used'])
        x=true;
    end
end

end


function [chi] = chi2(x,y,err,func)

% Returns chi^2 value for chi=chi2(x,y,yerr,function)

if length(err)==1
    err=err*ones(size(y));
end
if length(x)~=length(y) || length(y)~=length(err)
    error('Data must have same size')
end
chi=sum( ((func(x)-y)./err).^2) ;
end


function [betaerr] = errorfit(x,y,yerr,func,beta,chimin)
if nargin>5

    chimin2=chi2(x,y,yerr,@(y) func(y,beta));

    if abs((chimin2-chimin)/chimin)>0.001
        warning('MATLAB:errorfit:wrongchimin','wrong chimin');
    end

end

if nargin<6
    chimin=chi2(x,y,yerr,@(y) func(y,beta));
end

N=length(beta);
if N==1
    mchi=1;
    funcerr=@(x,beta1) func(x,beta1);

    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1))-chimin-mchi,beta(1))-beta(1));

elseif N==2
    mchi=2.3;

    funcerr=@(x,beta1,beta2) func(x,[beta1 beta2]);
    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1,beta(2)))-chimin-mchi,beta(1))-beta(1));

    betaerr(2)=abs(fzero(@(beta2) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta2))-chimin-mchi,beta(2))-beta(2));

elseif N==3

    mchi=3.53;

    funcerr=@(x,beta1,beta2,beta3) func(x,[beta1 beta2 beta3]);
    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1,beta(2),beta(3)))-chimin-mchi,beta(1))-beta(1));

    betaerr(2)=abs(fzero(@(beta2) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta2,beta(3)))-chimin-mchi,beta(2))-beta(2));

    betaerr(3)=abs(fzero(@(beta3) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta3))-chimin-mchi,beta(3))-beta(3));


elseif N==4

    mchi=4.8;
    funcerr=@(x,beta1,beta2,beta3,beta4) func(x,[beta1 beta2 beta3 beta4]);
    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1,beta(2),beta(3),beta(4)))-chimin-mchi,beta(1))-beta(1));

    betaerr(2)=abs(fzero(@(beta2) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta2,beta(3),beta(4)))-chimin-mchi,beta(2))-beta(2));

    betaerr(3)=abs(fzero(@(beta3) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta3,beta(4)))-chimin-mchi,beta(3))-beta(3));

    betaerr(4)=abs(fzero(@(beta4) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta4))-chimin-mchi,beta(4))-beta(4));

elseif N==5

    mchi=6.1;
    funcerr=@(x,beta1,beta2,beta3,beta4,beta5) func(x,[beta1 beta2 beta3 beta4 beta5]);
    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1,beta(2),beta(3),beta(4),beta(5)))-chimin-mchi,beta(1))-beta(1));

    betaerr(2)=abs(fzero(@(beta2) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta2,beta(3),beta(4),beta(5)))-chimin-mchi,beta(2))-beta(2));

    betaerr(3)=abs(fzero(@(beta3) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta3,beta(4),beta(5)))-chimin-mchi,beta(3))-beta(3));

    betaerr(4)=abs(fzero(@(beta4) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta4,beta(5)))-chimin-mchi,beta(4))-beta(4));

    betaerr(5)=abs(fzero(@(beta5) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta5))-chimin-mchi,beta(5))-beta(5));

elseif N==6

    mchi=7.3;
    funcerr=@(x,beta1,beta2,beta3,beta4,beta5,beta6) func(x,[beta1 beta2 beta3 beta4 beta5 beta6]);

    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1,beta(2),beta(3),beta(4),beta(5),beta(6)))-chimin-mchi,beta(1))-beta(1));

    betaerr(2)=abs(fzero(@(beta2) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta2,beta(3),beta(4),beta(5),beta(6)))-chimin-mchi,beta(2))-beta(2));

    betaerr(3)=abs(fzero(@(beta3) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta3,beta(4),beta(5),beta(6)))-chimin-mchi,beta(3))-beta(3));

    betaerr(4)=abs(fzero(@(beta4) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta4,beta(5),beta(6)))-chimin-mchi,beta(4))-beta(4));

    betaerr(6)=abs(fzero(@(beta5) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta5,beta(6)))-chimin-mchi,beta(5))-beta(5));
    
    betaerr(6)=abs(fzero(@(beta6) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta(5),beta6))-chimin-mchi,beta(6))-beta(6));

elseif N==7

    mchi=8.6;
    funcerr=@(x,beta1,beta2,beta3,beta4,beta5,beta6,beta7) func(x,[beta1 beta2 beta3 beta4 beta5 beta6 beta7]);

    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1,beta(2),beta(3),beta(4),beta(5),beta(6),beta(7)))-chimin-mchi,beta(1))-beta(1));

    betaerr(2)=abs(fzero(@(beta2) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta2,beta(3),beta(4),beta(5),beta(6),beta(7)))-chimin-mchi,beta(2))-beta(2));

    betaerr(3)=abs(fzero(@(beta3) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta3,beta(4),beta(5),beta(6),beta(7)))-chimin-mchi,beta(3))-beta(3));

    betaerr(4)=abs(fzero(@(beta4) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta4,beta(5),beta(6),beta(7)))-chimin-mchi,beta(4))-beta(4));

    betaerr(5)=abs(fzero(@(beta5) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta5,beta(6),beta(7)))-chimin-mchi,beta(5))-beta(5));
    
    betaerr(6)=abs(fzero(@(beta6) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta(5),beta6,beta(7)))-chimin-mchi,beta(6))-beta(6));
    
    betaerr(7)=abs(fzero(@(beta7) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta7))-chimin-mchi,beta(7))-beta(7));

    elseif N==8

    mchi=9.9;
    funcerr=@(x,beta1,beta2,beta3,beta4,beta5,beta6,beta7,beta8) func(x,[beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8]);

    betaerr(1)=abs(fzero(@(beta1) chi2(x,y,yerr,@(y) funcerr(y,beta1,beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8)))-chimin-mchi,beta(1))-beta(1));

    betaerr(2)=abs(fzero(@(beta2) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta2,beta(3),beta(4),beta(5),beta(6),beta(7),beta(8)))-chimin-mchi,beta(2))-beta(2));

    betaerr(3)=abs(fzero(@(beta3) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta3,beta(4),beta(5),beta(6),beta(7),beta(8)))-chimin-mchi,beta(3))-beta(3));

    betaerr(4)=abs(fzero(@(beta4) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta4,beta(5),beta(6),beta(7),beta(8)))-chimin-mchi,beta(4))-beta(4));

    betaerr(5)=abs(fzero(@(beta5) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta5,beta(6),beta(7),beta(8)))-chimin-mchi,beta(5))-beta(5));
    
    betaerr(6)=abs(fzero(@(beta6) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta(5),beta6,beta(7),beta(8)))-chimin-mchi,beta(6))-beta(6));
    
    betaerr(7)=abs(fzero(@(beta7) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta7,beta(8)))-chimin-mchi,beta(7))-beta(7));

    betaerr(8)=abs(fzero(@(beta8) chi2(x,y,yerr,@(y) funcerr(y,beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta8))-chimin-mchi,beta(8))-beta(8));
    
end

end
