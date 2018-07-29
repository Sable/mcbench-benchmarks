function ROCout=roc(varargin)
% ROC - Receiver Operating Characteristics.
% The ROC graphs are a useful tecnique for organizing classifiers and
% visualizing their performance. ROC graphs are commonly used in medical
% decision making.
%
% Syntax: ROCout=roc(x,thresholds,alpha,verbose)
%
% Input: x - This is a Nx2 data matrix. The first column is the column of the data value;
%            The second column is the column of the tag: unhealthy (1) and
%            healthy (0).
%        Thresholds - If you want to use all unique values in x(:,1) 
%            then set this variable to 0 or leave it empty; 
%            else set how many unique values you want to use (min=3);
%        alpha - significance level (default 0.05)
%        verbose - if you want to see all reports and plots (0-no; 1-yes by
%        default);
%
% Output: if verbose = 1
%         the ROCplots, the sensitivity and specificity at thresholds; the Area
%         under the curve with Standard error and Confidence interval and
%         comment.
%         if ROCout is declared, you will have a struct:
%         ROCout.AUC=Area under the curve (AUC);
%         ROCout.SE=Standard error of the area;
%         ROCout.ci=Confidence interval of the AUC
%         ROCout.co=Cut off points
%         ROCdata.xr and ROCdata.yr points for ROC plot
%
% USING roc WITHOUT ANY DATA, IT WILL RUN A DEMO
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2008) ROC curve: compute a Receiver Operating Characteristics curve.
% http://www.mathworks.com/matlabcentral/fileexchange/19950

%Input Error handling
args=cell(varargin);
nu=numel(args);
if isempty(nu)
    error('Warning: almost the data matrix is required')
elseif nu>4
    error('Warning: Max four input data are required')
end
default.values = {[165 1;140 1;154 1;139 1;134 1;154 1;120 1;133 1;150 1;...
146 1;140 1;114 1;128 1;131 1;116 1;128 1;122 1;129 1;145 1;117 1;140 1;...
149 1;116 1;147 1;125 1;149 1;129 1;157 1;144 1;123 1;107 1;129 1;152 1;...
164 1;134 1;120 1;148 1;151 1;149 1;138 1;159 1;169 1;137 1;151 1;141 1;...
145 1;135 1;135 1;153 1;125 1;159 1;148 1;142 1;130 1;111 1;140 1;136 1;...
142 1;139 1;137 1;187 1;154 1;151 1;149 1;148 1;157 1;159 1;143 1;124 1;...
141 1;114 1;136 1;110 1;129 1;145 1;132 1;125 1;149 1;146 1;138 1;151 1;...
147 1;154 1;147 1;158 1;156 1;156 1;128 1;151 1;138 1;193 1;131 1;127 1;...
129 1;120 1;159 1;147 1;159 1;156 1;143 1;149 1;160 1;126 1;136 1;150 1;...
136 1;151 1;140 1;145 1;140 1;134 1;140 1;138 1;144 1;140 1;140 1;159 0;...
136 0;149 0;156 0;191 0;169 0;194 0;182 0;163 0;152 0;145 0;176 0;122 0;...
141 0;172 0;162 0;165 0;184 0;239 0;178 0;178 0;164 0;185 0;154 0;164 0;...
140 0;207 0;214 0;165 0;183 0;218 0;142 0;161 0;168 0;181 0;162 0;166 0;...
150 0;205 0;163 0;166 0;176 0;],0,0.05,1};
default.values(1:nu) = args;
[x threshold alpha verbose] = deal(default.values{:});
if isvector(x)
    error('Warning: X must be a matrix')
end
if ~all(isfinite(x(:))) || ~all(isnumeric(x(:)))
    error('Warning: all X values must be numeric and finite')
end
x(:,2)=logical(x(:,2));
if all(x(:,2)==0)
    error('Warning: there are only healthy subjects!')
end
if all(x(:,2)==1)
    error('Warning: there are only unhealthy subjects!')
end
if nu>=2
    if isempty(threshold)
        threshold=0;
    else
        if ~isscalar(threshold) || ~isnumeric(threshold) || ~isfinite(threshold)
            error('Warning: it is required a numeric, finite and scalar THRESHOLD value.');
        end
        if threshold ~= 0 && threshold <3
            error('Warning: Threshold must be 0 if you want to use all unique points or >=2.')
        end
    end
    if nu>=3
        if isempty(alpha)
            alpha=0.05;
        else3
            if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha)
                error('Warning: it is required a numeric, finite and scalar ALPHA value.');
            end
            if alpha <= 0 || alpha >= 1 %check if alpha is between 0 and 1
                error('Warning: ALPHA must be comprised between 0 and 1.')
            end
        end
    end
    if nu==4
        verbose=logical(verbose);
    end
end
clear args default nu

tr=repmat('-',1,100);
lu=length(x(x(:,2)==1)); %number of unhealthy subjects
lh=length(x(x(:,2)==0)); %number of healthy subjects
z=sortrows(x,1);
if threshold==0
    labels=unique(z(:,1));%find unique values in z
else
    K=linspace(0,1,threshold+1); K(1)=[];
    labels=quantile(unique(z(:,1)),K)';
end
labels(end+1)=labels(end)+1;
ll=length(labels); %count unique value
a=zeros(ll,2); b=a; c=zeros(ll,1);%array preallocation
ubar=mean(x(x(:,2)==1),1); %unhealthy mean value
hbar=mean(x(x(:,2)==0),1); %healthy mean value
for K=1:ll
    if hbar<ubar
        TP=length(x(x(:,2)==1 & x(:,1)>labels(K)));
        FP=length(x(x(:,2)==0 & x(:,1)>labels(K)));
        FN=length(x(x(:,2)==1 & x(:,1)<=labels(K)));
        TN=length(x(x(:,2)==0 & x(:,1)<=labels(K)));
    else
        TP=length(x(x(:,2)==1 & x(:,1)<labels(K)));
        FP=length(x(x(:,2)==0 & x(:,1)<labels(K)));
        FN=length(x(x(:,2)==1 & x(:,1)>=labels(K)));
        TN=length(x(x(:,2)==0 & x(:,1)>=labels(K)));
    end
    M=[TP FP;FN TN];
    a(K,:)=diag(M)'./sum(M); %Sensitivity and Specificity
    b(K,:)=[a(K,1)/(1-a(K,2)) (1-a(K,1))/a(K,2)]; %Positive and Negative likelihood ratio
    c(K)=trace(M)/sum(M(:)); %Efficiency
end
b(isnan(b))=Inf;

if hbar<ubar
    xroc=flipud(1-a(:,2)); yroc=flipud(a(:,1)); %ROC points
    labels=flipud(labels);
else
    xroc=1-a(:,2); yroc=a(:,1); %ROC points
end

st=[1 mean(xroc) 1]; L=[0 0 0]; U=[Inf 1 Inf];
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',L,'Upper',U,'Startpoint',st);
ft_ = fittype('1-1/((1+(x/C)^B)^E)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'B', 'C', 'E'});
cfit = fit(xroc,yroc,ft_,fo_);

xfit=linspace(0,1,500);
yfit=feval(cfit,xfit);
Area=trapz(xfit,yfit); %estimate the area under the curve
%standard error of area
Area2=Area^2; Q1=Area/(2-Area); Q2=2*Area2/(1+Area);
V=(Area*(1-Area)+(lu-1)*(Q1-Area2)+(lh-1)*(Q2-Area2))/(lu*lh);
Serror=realsqrt(V);
%confidence interval
ci=Area+[-1 1].*(realsqrt(2)*erfcinv(alpha)*Serror);
if ci(1)<0; ci(1)=0; end
if ci(2)>1; ci(2)=1; end
m=zeros(1,4); 
%z-test
SAUC=(Area-0.5)/Serror; %standardized area
p=1-0.5*erfc(-SAUC/realsqrt(2)); %p-value

if verbose
    %Performance of the classifier
    if Area==1
        str='Perfect test';
    elseif Area>=0.90 && Area<1
        str='Excellent test';
    elseif Area>=0.80 && Area<0.90
        str='Good test';
    elseif Area>=0.70 && Area<0.80
        str='Fair test';
    elseif Area>=0.60 && Area<0.70
        str='Poor test';
    elseif Area>=0.50 && Area<0.60
        str='Fail test';
    else
        str='Failed test - less than chance';
    end
    %display results
    disp('ROC CURVE ANALYSIS')
    disp(' ')
    disp(tr)
    str2=['AUC\t\t\tS.E.\t\t\t\t' num2str((1-alpha)*100) '%% C.I.\t\t\tComment\n'];
    fprintf(str2)
    disp(tr)
    fprintf('%0.5f\t\t\t%0.5f\t\t\t%0.5f\t\t%0.5f\t\t\t%s\n',Area,Serror,ci,str)
    disp(tr)
    fprintf('Standardized AUC\t\t1-tail p-value\n')
    if p<1e-4
        fprintf('%0.4f\t\t\t\t%0.4e',SAUC,p)
    else
        fprintf('%0.4f\t\t\t\t%0.4f',SAUC,p)
    end
    if p<=alpha
        fprintf('\t\tThe area is statistically greater than 0.5\n')
    else
        fprintf('\t\tThe area is not statistically greater than 0.5\n')
    end
    disp(' ')
    %display graph
    H=figure;
    set(H,'Position',[4 402 560 420])
    hold on
    plot([0 1],[0 1],'k');
    plot(xfit,yfit,'marker','none','linestyle','-','color','r','linewidth',2);
    H1=plot(xroc,yroc,'bo');
    set(H1,'markersize',6,'markeredgecolor','b','markerfacecolor','b')
    hold off
    xlabel('False positive rate (1-Specificity)')
    ylabel('True positive rate (Sensitivity)')
    title(sprintf('ROC curve (AUC=%0.4f)',Area))
    axis square
end

if p<=alpha
    ButtonName = questdlg('Do you want to input the true prevalence?', 'Prevalence Question', 'Yes', 'No', 'Yes');
    if strcmp(ButtonName,'Yes')
        ButtonName = questdlg('Do you want to input the true prevalence as:', 'Prevalence Question', 'Ratio', 'Probability', 'Ratio');
        switch ButtonName
            case 'Ratio'
                prompt={'Enter the Numerator or the prevalence ratio:','Enter the denominator or the prevalence ratio:'};
                name='Input for Ratio prevalence';
                Ratio=str2double(inputdlg(prompt,name));
                POD=Ratio(1)/diff(Ratio); %prior odds
            case 'Probability'
                prompt={'Enter the prevalence probability comprised between 0 and 1:'};
                name='Input for prevalence';
                pr=str2double(inputdlg(prompt,name));
                POD=pr/(1-pr); %prior odds
        end
        d=[1./(1+1./(b(:,1).*POD)) 1./(1+(b(:,2).*POD))];
        d((a(:,1)==0 & a(:,2)==1),1)=NaN;
        d((a(:,1)==1 & a(:,2)==0),2)=NaN;
        table=[labels'; a(:,1)'; a(:,2)';c';d(:,1)'.*100; d(:,2)'.*100;]';
        if verbose
            disp('ROC CURVE DATA')
            disp(tr)
            fprintf('Cut-off \tSensitivity\tSpecificity\tEfficiency\tPos.Pred.\tNeg.Pred.\n')
            fprintf('%0.2f\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.2f\t\t%0.2f\n',table')
            disp(tr)
            disp(' ')
        end
    else
        table=[labels'; a(:,1)'; a(:,2)';c']';
        if verbose
            disp('ROC CURVE DATA')
            disp(tr)
            fprintf('Cut-off \tSensitivity\tSpecificity\tEfficiency\n')
            fprintf('%0.2f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',table')
            disp(tr)
            disp(' ')
        end
    end
    CSe=find(table(:,2)==max(table(:,2)),1,'first'); %Max sensitivity cut-off
    CSp=find(table(:,3)==max(table(:,3)),1,'last'); %Max specificity cut-off
    CEff=find(table(:,4)==max(table(:,4)),1,'first'); %Max efficiency cut-off
    d=realsqrt(xroc.^2+(1-yroc).^2); %apply the Pitagora's theorem
    [~,CE]=min(d); %Cost-effective cut-off
    xg=linspace(0,max(table(:,1)),500);
    st=[1 mean(table(:,1)) 1]; U=[Inf max(table(:,1)) Inf];
    fo_ = fitoptions('method','NonlinearLeastSquares','Lower',L,'Upper',U,'Startpoint',st);
    fitSe = fit(table(:,1),table(:,2),ft_,fo_);
    st=[-1 mean(table(:,1)) 1]; L=[-Inf 0 0]; U=[0 max(table(:,1)) Inf];
    fo_ = fitoptions('method','NonlinearLeastSquares','Lower',L,'Upper',U,'Startpoint',st);
    fitSp=fit(table(:,1),table(:,3),ft_,fo_);
    st=[min(table(:,4)) 1 mean(table(:,1)) max(table(:,4)) 1]; L=[0 0 0 0 0]; U=[1 Inf max(table(:,1)) 1 Inf];
    ft_ = fittype('D+(A-D)/((1+(x/C)^B)^E)','dependent',{'y'},'independent',{'x'},'coefficients',{'A', 'B', 'C', 'D', 'E'});
    fo_ = fitoptions('method','NonlinearLeastSquares','Lower',L,'Upper',U,'Startpoint',st);
    fitEff=fit(table(:,1),table(:,4),ft_,fo_);
    if verbose
        H2=figure;
        set(H2,'Position',[570 402 868 420])
        hold on
        HSE = plot(xg,feval(fitSe,xg),'marker','none','linestyle','-','color','r','linewidth',2);
        HCSe=plot([table(CSe,1) table(CSe,1)],[0 1],'marker','none','linestyle','--','color','r','linewidth',2);
        HSP = plot(xg,feval(fitSp,xg),'marker','none','linestyle','-','color','g','linewidth',2);
        HCSp=plot([table(CSp,1) table(CSp,1)],[0 1],'marker','none','linestyle','--','color','g','linewidth',2);
        HEFF = plot(xg,feval(fitEff,xg),'marker','none','linestyle','-','color','b','linewidth',2);
        HCEff=plot([table(CEff,1) table(CEff,1)],[0 1],'marker','none','linestyle','--','color','b','linewidth',2);
        HCO=plot([table(CE,1) table(CE,1)],[0 1],'marker','none','linestyle','--','color','m','linewidth',2);
        hold off
        legend([HSE HCSe HSP HCSp HCO HEFF HCEff],...
            'Sensitivity',sprintf('Max Sensitivity cutoff: %0.4f',table(CSe,1)),...
            'Specificity',sprintf('Max Specificity cutoff: %0.4f',table(CSp,1)),...
            sprintf('Cost effective cutoff: %0.4f',table(CE,1)),...
            'Efficiency',sprintf('Max Efficiency cutoff: %0.4f',table(CEff,1)),...
            'Location','BestOutside')
        axis([xg(1) xg(end) 0 1.1])

        fprintf('1) Max Sensitivity Cut-off point= %0.2f\n',table(CSe,1))
        fprintf('2) Max Specificity Cut-off point= %0.2f\n',table(CSp,1))
        fprintf('3) Cost effective Cut-off point= %0.2f\n',table(CE,1)), 
        fprintf('4) Max Efficiency Cut-off point= %0.2f\n',table(CEff,1))
        m=table([CSe CSp CE CEff],1);
    end
else
    table=NaN;
end


if nargout
    ROCout.AUC=Area; %Area under the curve
    ROCout.SE=Serror; %standard error of the area
    ROCout.ci=ci; % 95% Confidence interval
    ROCout.co=m; % cut off points
    ROCout.xr=xroc; %graphic x points
    ROCout.yr=yroc; %graphic y points
    ROCout.table=table;
end