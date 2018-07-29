SqSz = 1.00*10/(NoLatticePoints/25);
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

CloseAftPrint=1;
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 
if mcs==1
    [xyzQ,stateindex] = ExtractQ_XYZQ_3D_POTTS(state,x,y,z,Q);
    display('Plotting the evolving microstructure');
    figure
    for q = 1:Q
        if prod(size(xyzQ{1,q}))~=0
            if PrintSqBox==0
                plot3(xyzQ{1,q}(:,1),xyzQ{1,q}(:,2),xyzQ{1,q}(:,3),'s','MarkerFaceColor',...
                    [ColorMatrix(q,:)],'MarkerEdgeColor',[ColorMatrix(q,:)],'MarkerSize',SqSz)
                box on,axis square,hold on;%PlotBoxEdges
            elseif PrintSqBox==1
                plot3(xyzQ{1,q}(:,1),xyzQ{1,q}(:,2),xyzQ{1,q}(:,3),'s','MarkerFaceColor',...
                    [ColorMatrix(q,:)],'MarkerEdgeColor','k','MarkerSize',SqSz),hold on
                PlotBoxEdges
                box on,axis square
            end
            xlabel('X - axis'),ylabel('Y - axis'),zlabel('Z - axis')
            axesLabelsAlign3D,title('Grain Structure. Q = 64. 125 x 125 x 125.')%,pause(0.05)
        end
    end
    if PrintToJPEG==1
        print( '-djpeg100', num2str(mcs));
    end
    if CloseAftPrint==1
        close
    end
    pause(0.001)
end
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - -     
if mod(mcs,20)==0
    [xyzQ,stateindex] = ExtractQ_XYZQ_3D_POTTS(state,x,y,z,Q);
    display('Plotting the evolving microstructure');
    figure
    for q = 1:Q
        if prod(size(xyzQ{1,q}))~=0
            fprintf('Plotting lattice sites belonging to q = %d \n',q);
            if PrintSqBox==0
                plot3(xyzQ{1,q}(:,1),xyzQ{1,q}(:,2),xyzQ{1,q}(:,3),'s','MarkerFaceColor',...
                    [ColorMatrix(q,:)],'MarkerEdgeColor',[ColorMatrix(q,:)],'MarkerSize',SqSz)
                box on,axis square,hold on;%PlotBoxEdges
            elseif PrintSqBox==1
                plot3(xyzQ{1,q}(:,1),xyzQ{1,q}(:,2),xyzQ{1,q}(:,3),'s','MarkerFaceColor',...
                    [ColorMatrix(q,:)],'MarkerEdgeColor','k','MarkerSize',SqSz),hold on
                PlotBoxEdges
                box on,axis square
            end
            xlabel('X - axis'),ylabel('Y - axis'),zlabel('Z - axis')
            axesLabelsAlign3D,title('Grain Structure. Q = 64. 125 x 125 x 125.')%,pause(0.001)
        end
    end
%     if PrintToJPEG==1
        print( '-djpeg100', num2str(mcs));
%     end
    if CloseAftPrint==1
        close
    end
    pause(0.001)
end
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 
if PlotQGrains==1
    if mcs==MonteCarloSteps
        [xyzQ,stateindex] = ExtractQ_XYZQ_3D_POTTS(state,x,y,z,Q);
        display('Plotting Q specific grains');
        for q = 1:Q
            figure
            if prod(size(xyzQ{1,q}))~=0
                if PrintSqBox==0
                    plot3(xyzQ{1,q}(:,1),xyzQ{1,q}(:,2),xyzQ{1,q}(:,3),'s','MarkerFaceColor',...
                        [ColorMatrix(q,:)],'MarkerEdgeColor',[ColorMatrix(q,:)],'MarkerSize',SqSz)
                    PlotBoxEdges
                    box on,axis square,hold on;
                elseif PrintSqBox==1
                    plot3(xyzQ{1,q}(:,1),xyzQ{1,q}(:,2),xyzQ{1,q}(:,3),'s','MarkerFaceColor',...
                        [ColorMatrix(q,:)],'MarkerEdgeColor','k','MarkerSize',SqSz),hold on,%PlotBoxEdges
                    box on,axis square
                end
                xlabel('X - axis'),ylabel('Y - axis'),zlabel('Z - axis')
                axesLabelsAlign3D,title('Grain Structure. Q = 64. 125 x 125 x 125.'),%pause(0.05)
%                 if PrintToJPEG==1
                    print( '-djpeg100', num2str(mcs+q));
%                 end
            end
        end
        if CloseAftPrint==1
            close
        end
        pause(0.001)
    end
end
clear SqSz CloseAftPrint PrintSqBox PlotQGrains q
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 
%- - - - - - -  - - - - - - - -  - - - - - - -  - - - - - - - 