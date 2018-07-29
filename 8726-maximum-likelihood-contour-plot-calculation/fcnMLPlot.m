function fcnMLPlot(in)
% input: structure to be ploted with members: X,Y,Z as cells
% in.Xcell  - X vector for each pair
% in.Ycell  - Y vector for each pair
% in.Zcell  - z matrix for each pair
% in.CplotRangeCell - sensitivity calculation grid resolution
% in.XlabelCell 
% in.YlabelCell
% in.MaxSubPlot


% ver. 1.0
% by Levente L. Simon - ETH Zuerich
% email: l.simon@chem.ethz.ch
% =============================================================


close all
for n=1: size(in.Xcell,2)
    subplot(in.MaxSubPlot,3, n)
        
     v = in.setts.CplotRange;
     [C,h]=contour(in.Xcell{n},in.Ycell{n},in.Zcell{n},v);
  
     set(h,'ShowText','on','TextStep',get(h,'LevelStep')/4)

     xlabel (in.XlabelCell{n});  ylabel (in.YlabelCell{n});
     
     
     if  n==1
     legend('Maximum likelihood surface plot');
     end
end

%  ======== for 3D surface plot==========================
figure
for n=1: size(in.Xcell,2)
    subplot(in.MaxSubPlot,3, n)
        
     v = in.setts.CplotRange;
     surf(in.Xcell{n},in.Ycell{n},in.Zcell{n});
  
     %set(h,'ShowText','on','TextStep',get(h,'LevelStep')/4)

     xlabel (in.XlabelCell{n});  ylabel (in.YlabelCell{n});
     
     
     if  n==1
     legend('Response surface plot');
     end
end

% %  ======== 3D contour plot ==========================
% figure
% for n=1: size(in.Xcell,2)
%     subplot(in.MaxSubPlot,3, n)
%         
%      v = in.setts.CplotRange;
%      contour3(in.Xcell{n},in.Ycell{n},in.Zcell{n});
%   
%      %set(h,'ShowText','on','TextStep',get(h,'LevelStep')/4)
% 
%      xlabel (in.XlabelCell{n});  ylabel (in.YlabelCell{n});
%      
%      
%      if  n==1
%      legend('Contour 3D plot');
%      end
% end
% 
% 
% %  ======== filled contour plot ==========================
% figure
% for n=1: size(in.Xcell,2)
%     subplot(in.MaxSubPlot,3, n)
%         
%      v = in.setts.CplotRange;
%      contourf(in.Xcell{n},in.Ycell{n},in.Zcell{n});
%   
%      %set(h,'ShowText','on','TextStep',get(h,'LevelStep')/4)
% 
%      xlabel (in.XlabelCell{n});  ylabel (in.YlabelCell{n});
%      
%      
%      if  n==1
%      legend('Response surface plot');
%      end
% end
% 
% 
