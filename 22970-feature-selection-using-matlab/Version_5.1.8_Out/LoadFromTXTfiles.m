%------------------------------------------------------------------
%------- Load data from txt file ----------------------------------
%------------------------------------------------------------------

function [finalvec,ClassInfo] = LoadFromTXTfiles(Filename)

% ClassInfo: Cell Table Example: 1 'R'     
%                                2 'M'    
% where R=Rock, M=Mine
% To be used for interpretation of numeric labels after change from
% Letters

 fid = fopen(Filename,'r');
 Patterns = [];
 Targets = [];
 while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    IndexOfCommas       = find(tline == ',');
    IndexOfCommas       = [0 IndexOfCommas length(tline)];
    LengthIndexOfCommas = length(IndexOfCommas);
    PatternsLine        = [];
    for IndexColumns = 1:(LengthIndexOfCommas-2)
      Item = tline(...
(IndexOfCommas(IndexColumns)+1):(IndexOfCommas(IndexColumns+1)-1));
      PatternsLine = [PatternsLine str2num(Item)];
    end
    Patterns = [Patterns; PatternsLine];
    TargetLoca = (IndexOfCommas(LengthIndexOfCommas-1)+1):...
                                IndexOfCommas(LengthIndexOfCommas);
    Targets = [Targets tline(TargetLoca)];
 end
 fclose(fid);

 
 % Transformation from single Letter labels to integer
  if ischar(Targets)
    TargetsNumeric = zeros(length(Targets),1);
    ClassInfo = cell(0);  
    Labels = unique(Targets);
    CClasses = length(Labels);
    for IndexClass = 1:CClasses
        ClassInfo = [ClassInfo; {IndexClass} {Labels(IndexClass)}];
        TargetsNumeric(Targets == Labels(IndexClass)) = IndexClass;
    end 
     Targets =TargetsNumeric;
  else
    ClassInfo = [];
  end

  finalvec = [Patterns Targets];
 
%  fseek(fid,9,-1);
%  KFeatures=fscanf(fid,'%d',1);
%  fseek(fid,10,0);
%  NPatterns =fscanf(fid,'%d',1);
%  patterns=zeros(NPatterns,KFeatures);
%  targets = zeros(NPatterns,1);
%   for k=1:KFeatures
%      for n=1:NPatterns
%          patterns(n,k)= fscanf(fid,'%f',1);
%      end
%  end
%         
%  for n=1:NPatterns
%      targets(n) = fscanf(fid,'%d',1);
%  end
%   fclose(fid);
% return
% 
% 
% 
% %--------------------------------------------------------
% %-----------------Create datasets------------------------
% %--------------------------------------------------------
% 
%   %--------- Preprocessed patterns ---------
% patterns = patterns(1:NPatterns,1:KFeatures);
% targets = emotions;
% 
% disp('Utterances x features:'), size(patterns)
% disp('Size of targets:'),  size(targets)
% 
% fid = fopen('PatTargDES.txt','w');
% fprintf(fid,'Features:%4d\n', KFeatures);  
% fprintf(fid,'Patterns:%5d\n', NPatterns);
% 
% for k=1:KFeatures
%        for n=1:NPatterns
%            fprintf(fid,'%6.5f\n',patterns(n,k));
%        end
% end
% 
% for n=1:NPatterns
%     fprintf(fid,'%1d\n',targets(n));
% end  
% 
% fclose(fid);       
%  
