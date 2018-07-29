SqSz=8*50/(nlp+1)+0.1*8*50/(nlp+1);
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 
PlotQGrains=0;
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 
PrintSqBox=0;
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 
if PrintToJPEG==1
    CloseAftPrint=1;
else
    CloseAftPrint=0;
end
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 
if mcs==1
    [xyQ,stateindex] = ExtractQ_XY_2D_POTTS(state,x,y,Q);
    display('Plotting the evolving microstructure');
    figure
    for q = 1:Q
        if prod(size(xyQ{1,q}))~=0
            if PrintSqBox==0
                plot(xyQ{1,q}(:,1),xyQ{1,q}(:,2),'s','MarkerFaceColor',[ColorMatrix(q,:)],...
                    'MarkerEdgeColor',[ColorMatrix(q,:)],'MarkerSize',SqSz)
                box on,axis square,hold on
            elseif PrintSqBox==1
                plot(xyQ{1,q}(:,1),xyQ{1,q}(:,2),'s','MarkerFaceColor',[ColorMatrix(q,:)],...
                    'MarkerEdgeColor','k','MarkerSize',SqSz)
                hold on,box on,axis square
            end
            xlabel('X - axis'),ylabel('Y - axis'),title('Grain Structure. Q Potts.')
            pause(0.05)
        end
    end
    if PrintToJPEG==1
%         print( '-djpeg100', num2str(mcs));
          print( '-djpeg60', num2str(mcs));
    end
    if CloseAftPrint==1
        close
    end
    pause(0.001)
end
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - -     
if mod(mcs,floor(MonteCarloSteps/4))==0
    [xyQ,stateindex] = ExtractQ_XY_2D_POTTS(state,x,y,Q);
    display('Plotting the evolving microstructure');
    figure
    for q = 1:Q
        if prod(size(xyQ{1,q}))~=0
            if PrintSqBox==0
                plot(xyQ{1,q}(:,1),xyQ{1,q}(:,2),'s','MarkerFaceColor',[ColorMatrix(q,:)],...
                    'MarkerEdgeColor',[ColorMatrix(q,:)],'MarkerSize',SqSz)
                box on,axis square,hold on
            elseif PrintSqBox==1
                plot(xyQ{1,q}(:,1),xyQ{1,q}(:,2),'s','MarkerFaceColor',[ColorMatrix(q,:)],...
                    'MarkerEdgeColor','k','MarkerSize',SqSz)
                hold on,box on,axis square
            end
            xlabel('X - axis'),ylabel('Y - axis'),title('Grain Structure. Q Potts.'),pause(0.05)
        end
    end
    pause(0.001)
%     display('Plotting the Grain Boundary')
%     plot(GrainBoundaryX(1,1:size(GrainBoundaryX,2)),GrainBoundaryY(1,1:size(GrainBoundaryX,2)),...
%         's','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',SqSz),hold on,axis([0 1 0 1])
    if PrintToJPEG==1
        print( '-djpeg100', num2str(mcs));
    end
    if CloseAftPrint==1
        close
    end
end

% run PlotGrainBoundary_2DQPOTTS

% if mcs==1
%     display('Plotting the initial microstructure')
%     figure
%     for r=1:size(x,1)
%         for c=1:size(x,1)
%             plot(x(r,c),y(r,c),'s','MarkerFaceColor',[ColorMatrix(state(r,c),:)],'MarkerEdgeColor',[ColorMatrix(state(r,c),:)],'MarkerSize',8)
%             hold on,axis square
%         end
%     end
%     %print('-depsc',num2str(mcs))
% elseif mod(mcs,MonteCarloSteps)==0
%     display('Plotting the evolving microstructure')
%     pause(0.5)
%     figure
%     for r=1:size(x,1)
%         for c=1:size(x,1)
%             plot(x(r,c),y(r,c),'s','MarkerFaceColor',[ColorMatrix(state(r,c),:)],'MarkerEdgeColor',[ColorMatrix(state(r,c),:)],'MarkerSize',8)
%             hold on,axis square
%         end
%     end
%     drawnow;
%     fprintf('Printing to eps file. File name = " %d.eps " \n',mcs)
%     pause(0.01)
%     %print('-depsc',num2str(mcs))
%     figure
%     display('Plotting the Grain Boundary')
%     pause(0.5)
%     for count=1:size(GrainBoundaryX,2)
%         plot(GrainBoundaryX(1,count),GrainBoundaryY(1,count),'s','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',3.5),hold on,axis([0 1 0 1])
%         box on;axis square
%         if mod(count,5000)==0
%             pause(0.001);
%         end
%     end
%     drawnow
%     xlabel('X-axis');ylabel('Y-axis');%title('Microstucture Grain Boundary at M.C.Step = %d',mcs);
%     %print('-depsc',num2str(mcs))
% end