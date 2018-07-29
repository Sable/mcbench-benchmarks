RawDir='C:\My Dropbox\Ryan_LBL\CARES\STXMData\Raw\T0_100628\1203LST'  %% directory where raw data is found
FinDir='C:\My Dropbox\Ryan_LBL\CARES\STXMData\Fin\T0_100628\1203LST';  %%
ProcDir(RawDir,FinDir) %% process all data folders
SingStackProc(RawDir,FinDir,'11_100715023',[])%% Process just one data folder (indicate name) 

%% Carbon K edge routines
Snew=Diffmaps(Snew,.35);
Snew=PartLabelCompSize(Snew);

%%_________________________________________________________________________
%%_________________________________________________________________________
%% The following is an example from Mexico City where there are several
%% different samples that we wish to compare statistically. The routine
%% defines the directories where the stxm data structures are found, then
%% the script, DirLabel, loops through each directory and saves the
%% statistical information for later analysis. This is a mess and will
%% hopefully be improved in the future. 

DirStr{1}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T0\535\fin';  %% Directory containing aligned stack data in OD as .mat file
DirStr{2}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T0\1030\fin';  %% Directory containing aligned stack data in OD as .mat file
DirStr{3}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T0\1235\Fin';  %% Directory containing aligned stack data in OD as .mat file

DirStr{4}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T1\840CST\Fin';  %% Directory containing aligned stack data in OD as .mat file
DirStr{5}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T1\1300CST\Fin';  %% Directory containing aligned stack data in OD as .mat files
DirStr{6}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T1\1800CST\Fin';  %% Directory containing aligned stack data in OD as .mat files

DirStr{7}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T2\1430CST\Fin';  %% Directory containing aligned stack data in OD as .mat files
DirStr{8}='C:\RyanM_LBL\Milagro\Mar22Data\MatFiles\T2\1900CST\Fin';  %% Directory containing aligned stack data in OD as .mat files
site={'T0 5:35','T0 10:35','T0 12:35','T1 8:35','T1 13:00','T1 18:00','T2 14:30','T2 19:30'};
% site={'T0 12:35','T1 13:00','T1 18:00','T2 14:30','T2 19:30'};
ResultPath='C:\RyanM_LBL\Milagro\Analysis\NewAnalysis\';
[LabelCnt,avgspec,PartSiz,PartLab,CompSize,OCSpec,RadScans,RadStd,SingRad,OutOCCmp]=...
    DirLabel(DirStr,site,0,ResultPath,0.35);

%%_________________________________________________________________________
%%_________________________________________________________________________
%%)
%% If you were lucky enough to have DirLabel run you can try and run the
%% following to plot your results. 


% RadScanSiteBox(SingRad,site)
% RadScanSiteBoxMilag(SingRad,site,LabelCnt)
% % ChemSizDistBatch(PartSiz,PartLab,site)
% % 
% save C:\RyanM_LBL\Milagro\Analysis\NewAnalysis\SummaryData12EarlyIncSp35.mat %% C:\RyanM_LBL\Milagro\Analysis\NewAnalysis
% % 
% %% Produce Component size distributions
% CoreSizeDist(CompSize{5})
% kfrac=KRelCount(CompSize,1)
% CoreSizeDist_Comb(CompSize,4,site,[1,2,3],'Area')
%% Produce bar plot of particle types
% temp=zeros(5,8);
% cnt=1;
% for i=1:8
%     temp(1,i)=length(find(PartLab{i}==5));
%     cnt=cnt+1;
% end
% temp(2:end,:)=LabelCnt
% LabelSum=sum(temp);
% LabelCntNorm=zeros(size(temp));
% for i=1:length(LabelSum)
%     LabelCntNorm(:,i)=temp(:,i)./LabelSum(i);
% end

% ChemFrac(LabelCntNorm(:,[3,5:end])',site)
% ChemFrac(LabelCntNorm',site)
% ExportMatrixXls(LabelCntNorm,site,'ChemFrac090805','C:\RyanM_LBL\Milagro\Analysis\NewAnalysis\')
% for i=1:length(site)
% [sp2out1(i),dsp21(i)]=PercSp2Spec(avgspec{i});
% end
% for i=1:length(site)
% [sp2out2(i),dsp22(i)]=PercSp2Spec(OCSpec{i});
% end
% %% Plot average spectra at each site
% site={'T0 12:35CST','T1 13:00CST','T1 18:00CST','T2 14:30CST','T2 19:30CST'};
% PlotNexafsSpecCell(OCSpec,site)
