clear
clc
global StopByUser 
StopByUser = 0;

warning off all
FSMethodOpt          = {'SFFS','ReliefF','SFS','SFBS',};
CCREstMethodToUseOpt = {'ProposedAB','Resubstitution'};
DatasetToUseOpt      ={'finalvecBREASTCANCER','finalvecSUSAS', ...
                           'finalvecSONAR', 'finalvecCOLONCANCER'};
MahalInfoLossMethod = 'on';

for IndexFSMethod = 1:3
    for IndexCCRMethod = 2:2
        for IndexDS = 2:4
        DatasetToUse      = DatasetToUseOpt{IndexDS};
        CCREstMethodToUse = CCREstMethodToUseOpt{IndexCCRMethod};
        FSMethod          = FSMethodOpt{IndexFSMethod};
        %------------------ Feature Selection  --------------------
        figure
        if strcmp(FSMethod,'SFS')||strcmp(FSMethod,'SFFS')
            [ResultMat, ConfMatOpt, Tlapse, OptimumFeatureSet,...
                OptimumCCR]= ForwSel_main(...
                              DatasetToUse,CCREstMethodToUse,...
                              MahalInfoLossMethod, FSMethod, []);
        elseif strcmp(FSMethod,'ReliefF')
            [ResultMat, FeatureWeightsOrdered, ...
             FeaturesIndexOrdered, OptimumFeatureSet] = ReliefF(...
                              DatasetToUse, CCREstMethodToUse,[]);
        elseif strcmp(FSMethod,'SBS') || strcmp(FSMethod,'SFBS')
              [ResultMat, ConfMatOpt, Tlapse, OptimumFeatureSet,...
                   OptimumCCR]= BackSel_main(...
                               DatasetToUse, CCREstMethodToUse, ...
                               MahalInfoLossMethod, FSMethod, []);
        end
        %-------------------  Save the result ------------------
        ChangStr=[DatasetToUse '_' CCREstMethodToUse '_' FSMethod];
        Filename     =['Res_' ChangStr '.mat'];
        ResultMatStr = ['ResultMat_' ChangStr ];                      
        eval([ResultMatStr '=ResultMat'])
%         eval(['Tlapse_'  DatasetToUse '_' CCREstMethodToUse ...
 %                                       '_' FSMethod '=Tlapse'])
         cd('Results');
         eval(['save('''  Filename ''',''' ResultMatStr ''')']);
         cd('..');
        %
        %----------------- Plotting -------------------------------
        % eval(['load(''Res_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod} '.mat'')']);
        % subplot(3, 3, (IndexDS-1)*3 + IndexMethod  );
        % eval(['plot(ResultMat_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod} '(:,2),''b.-'')'])
        %         hold on
        %         eval(['plot(ResultMat_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod} '(:,4),''g.-'')'])
        %         eval(['plot(ResultMat_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod} '(:,5),''r.-'')'])
        %         eval(['MaxVal= max( ResultMat_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod} '(:,5))']);
        %         eval(['MinVal = min( ResultMat_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod} '(:,5))']);
        %         eval(['T = Tlapse_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod}]);
        %         title([MethodToUse{IndexMethod} '  ' DatasetToUse{IndexDS} '   Tlapse:'  num2str(T)]);
        %         axis([0 100 0.4 0.65]);
        %         drawnow

        %------- Validation (NOT NECESSARY) -------------

        %         Filename = ['Res_'  DatasetToUse{IndexDS} '_' MethodToUse{IndexMethod} '.mat'];
        %         cd('Results');
        %         eval(['load('''  Filename ''')']);
        %         cd('..');
        %
        %         [ResultMat, UpLimitCOD,  LowLimitCOD] = CCRForOptSet(ResultMat,...
        %                           DatasetToUse{IndexDS}, MethodToUse{IndexMethod});
        
        end
    end
end
