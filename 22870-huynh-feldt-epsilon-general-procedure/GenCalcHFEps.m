function [EpsHF EpsList EpsGG]=GenCalcHFEps(Y,BTFacs,WInFacs,S)
%function [EpsHF EpsList EpsGG]=GenCalcHFEps(Y,BTFacs,WInFacs,S)
%
% This will calculate the Geisser-Greenhouse and Huynh-Feldt epsilon value
% for the general case when given a univariate dataset with any amount of 
% between or within subject factors. 
%
% After calling this function, the intention is to multiply the degrees of
% freedom for tests in a repeated measures ANOVA by the corresponding
% epsilon value given by this code to obtain a corrected p-value. The
% F-statistic does not change as a result of this.
%
% Inputs:   
%           Y-  A column vector of the dependent variable (the value
%               measured) for each data point.
%      BTFacs-  A matrix of between subject factors. Must have the same
%               number of rows as Y. Each factor is down a different column
%               of BTFacs, and the value in each row denotes the level of 
%               that factor for each corresponding datapoint in Y. If there
%               are no between subject factors, input an empty matrix, [].
%     WInFacs-  A matrix of within subject factors. Must have the same
%               number of rows as Y. Each factor is down a different column
%               of WInFacs, and the value in each row denotes the level of 
%               that factor for each corresponding datapoint in Y.
%           S-  A column vector of subject numbers corresponding to each
%               datapoint in Y. Must have the same number of rows as Y. If
%               left empty, the program assumes all subjects are entered in
%               the same order for all combinations of factors.
%
% Outputs:
%       EpsHF-  A row vector of all the possible values for the Huynh-Feldt
%               epsilon, correspondding to all main effects for ecah within
%               subject factor, and all interactions of within subject
%               factors.
%     EpsList-  A cell array of a text list of the effects corresponding to
%               the positions in EpsHF. For example 'A' means a main effect
%               for the first (within subject) factor, 'AB' means a 2way 
%               interaction for the first two (within subject) factors, 
%               etc.
%       EpsGG-  The Geisser-Greenhouse epsilon values, in teh same form as
%               EpsHF.
%
% The Huynh-Feldt epsilon value is less conservative while maintaining the
% proper Type I error rate, which is why the program title focuses on that.
% The Geisser-Greenhouse epsilon is calculated first as part of the 
% process of calculating the Huynh-Feldt value, so I've allowed it to be 
% optionally returned as well. 
%
% This code follows a procedure described in Huynh(1978), but includes a 
% modification of the last step, as described in Chen & Dunlap(1994).
%
% I've tested this with results from SPSS for a couple of sample datasets
% I've found in various websites, and it gives results that match
% According to what I've seen and read though, SPSS and SAS give results
% for EpsHF that are wrong when both between and with-in factors are
% present, and thus they slightly differ from the results this program,
% although the results for EpsGG are identical. To reproduce the SPSS 
% results, uncomment line 153. See other comments near there for references
% on why I think SPSS/SAS is wrong.
%
%
% References:
%
% Huynh H. "Some approximate tests for repeated measurement designs", 
% Psychometrika (1978) 
%
% Chen, RS and Dunlap, WP "A MonteCarlo STudy on the Performance of a 
% Corrected Formula for eps(tilda) suggested by Lecoutre", Journal of
% Educational Statistics (1994)
%
% written on 090202 by Matthew Nelson


if nargin<2 || isempty(BTFacs);    
    BT.nFacs=1;
    BT.nTreats=1;
    g=1;
else
    BT.Facs=BTFacs;
    BT.nFacs=size(BTFacs,2);
    BT.GNums=cell(1,BT.nFacs);
    BT.nTreats=repmat(0,1,BT.nFacs);
    %BT.dfs=BT.nTreats;
    for iBF=1:BT.nFacs
        BT.GNums{iBF}=unique(BT.Facs(:,iBF));
        BT.nTreats(iBF)=length(BT.GNums{iBF});
    end
    %BTdfs=BTnTreats-1; %I don't think this is ever used...
    
    g=prod(BT.nTreats);     
end

if nargin<3 || isempty(WInFacs);
    disp('In GenCalcHFEps- no Within Factors entered; leaving without calculating any epsilons')
    return
else
    WIn.Facs=WInFacs;
    WIn.nFacs=size(WIn.Facs,2);
    WIn.GNums=cell(1,WIn.nFacs);
    WIn.nTreats=repmat(0,1,WIn.nFacs);
    %WIn.dfs=WIn.nTreats;
    WIn.FacMult=WIn.nTreats;
    for iBF=1:WIn.nFacs
        WIn.GNums{iBF}=unique(WIn.Facs(:,iBF));
        WIn.nTreats(iBF)=length(WIn.GNums{iBF});
    end
    %WIn.dfs=WIn.nTreats-1; %I don't think this is ever used...
    
    WIn.nCombs=prod(WIn.nTreats);
    %Calc FactMult for determining curComb later
    for iFac=1:WIn.nFacs-1
        WIn.FacMult(iFac)=prod(WIn.nTreats(iFac+1:end));
    end
    WIn.FacMult(end)=1;
end

if nargin<4 || isempty(S)
    S=[];
    N=length(Y)/ (WIn.nCombs*prod(BT.nTreats));     %if S is not input, we assume that there is data for each subject in each cell... 
else    N=length(unique(S))/prod(BT.nTreats);   %divide the num of unique subjects by the num of BT subj treatments to get the N for each ind. cell
end

%Now Calc Z (SSP) matrix using recursive loops
Z=repmat(0,WIn.nCombs,WIn.nCombs);
Z=BTRLoop(1, repmat(1,length(Y),1),Z, N,Y,BT,WIn,S );

%Calc M matrices using other program
[M EpsList]=GenOrthogComps(WIn.nTreats);

%combine M and Z to calc epsilons
EpsHF=repmat(0,1,length(M));
EpsGG=EpsHF;

%calc totN, used for HF calc below
totN=N*prod(BT.nTreats);
for im=1:length(M)      
    S=M{im}*Z*M{im}';
    r=length(S);
    
    %calc EpsGG
    NumSS=0;
    for is1=1:r
        NumSS=NumSS+S(is1,is1);
    end
    DenSS=0;
    for is1=1:r
        for is2=1:r
            DenSS=DenSS+S(is1,is2)^2;
        end
    end           
    EpsGG(im)=(NumSS^2)/(r*DenSS);
    
    %Calc EpsHF
    EpsHF(im)=( (totN-g+1)*r*EpsGG(im)-2)/( r*(totN-g-r*EpsGG(im)) ); 
    %EpsHF(im)=( N*r*EpsGG(im)-2)/( r*(N-g-r*EpsGG(im)) ); %I have observed that to match SAS and SPSS, you would want to use this line of code instead of the line above it  
                                                           %BUT... According to what I've read, SPSS and SAS are wrong in this respect...
                                                           %see: http://archives.devshed.com/forums/development-94/huynh-feldt-r-vs-sas-bug-293023.html  
                                                           % and: Chen, RS and Dunlap, WP "A MonteCarlo STudy on teh Performance of a Corrected Formula for eps suggested by Lecoutre",
                                                           % Journal of Educational Statistics (1994) 
end

%these vals can't be more than 1
EpsGG=min(EpsGG,1);
EpsHF=min(EpsHF,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Z=BTRLoop(curFac,curSelInds,Z, N,Y,BT,WIn,S )

for iT=1:BT.nTreats(curFac)
    if BT.nTreats(curFac)==1 && BT.nFacs==1
        nextSelInds=curSelInds;
    else
        nextSelInds=curSelInds & BT.Facs(:,curFac)==BT.GNums{curFac}(iT);
    end
    if curFac==BT.nFacs                     %for DevMat         for FacLevList
        DevMat= WInRLoop(1, nextSelInds, repmat(0,WIn.nCombs,N),repmat(0,1,WIn.nFacs), N,Y,WIn,S );
        Z=Z+DevMat*DevMat';
    else
        Z=BTRLoop(curFac+1, nextSelInds,Z ,N,Y,BT,WIn,S  );
    end
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function DevMat=WInRLoop(curFac,curSelInds,DevMat,FacLevList, N,Y,WIn,S )

%if curFac==1;       DevMat=repmat(0,WIn.nCombs,N);      end

for iT=1:WIn.nTreats(curFac)
    FacLevList(curFac)=iT;
    if curFac==WIn.nFacs
        finSelInds = curSelInds & WIn.Facs(:,curFac)==WIn.GNums{curFac}(iT);
        curComb=sum( (FacLevList-1).*WIn.FacMult )+1;
                
        if isempty(S)
            DevMat(curComb,:)=Y(finSelInds)-mean(Y(finSelInds));    %works if subjects are all input in the same order...
        else
            [junk finSelInds2]=sort(S(finSelInds));     %still assuming one val for each subj, but not assuming that they've been input in teh proper order... NOTE- this could be changed later if it'es ever needed to account for more than one val per subject...
            tmpInds=find(finSelInds);
            DevMat(curComb,:)=Y(tmpInds(finSelInds2))-mean(Y(finSelInds));
        end
    else        
        DevMat=WInRLoop(curFac+1, curSelInds & WIn.Facs(:,curFac)==WIn.GNums{curFac}(iT) , DevMat,FacLevList, N,Y,WIn,S );
    end
end


