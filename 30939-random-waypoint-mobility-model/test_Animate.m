function test_Animate(s_mobility,s_input,time_step)
    
    v_t = 0:time_step:s_input.SIMULATION_TIME;
    
    for nodeIndex = 1:s_mobility.NB_NODES
        %Simple interpolation (linear) to get the position, anytime.
        %Remember that "interp1" is the matlab function to use in order to
        %get nodes' position at any continuous time.
        vs_node(nodeIndex).v_x = interp1(s_mobility.VS_NODE(nodeIndex).V_TIME,s_mobility.VS_NODE(nodeIndex).V_POSITION_X,v_t);
        vs_node(nodeIndex).v_y = interp1(s_mobility.VS_NODE(nodeIndex).V_TIME,s_mobility.VS_NODE(nodeIndex).V_POSITION_Y,v_t);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure;
    hold on;
    for nodeIndex = 1:s_mobility.NB_NODES
        vh_node_pos(nodeIndex) = plot(vs_node(nodeIndex).v_x(1),vs_node(nodeIndex).v_y(1),'*','color',[0.3 0.3 1]);
    end
    title(cat(2,'Simulation time (sec): ',num2str(s_mobility.SIMULATION_TIME)));
    xlabel('X (meters)');
    ylabel('Y (meters)');
    title('Radom Waypoint mobility');
    ht = text(min(vs_node(1).v_x),max(vs_node(1).v_y),cat(2,'Time (sec) = 0'));
    axis([min(vs_node(1).v_x) max(vs_node(1).v_x) min(vs_node(1).v_y) max(vs_node(1).v_y)]);
    hold off;
    for timeIndex = 1:length(v_t);
        t = v_t(timeIndex);
        set(ht,'String',cat(2,'Time (sec) = ',num2str(t,4)));
        for nodeIndex = 1:s_mobility.NB_NODES
            set(vh_node_pos(nodeIndex),'XData',vs_node(nodeIndex).v_x(timeIndex),'YData',vs_node(nodeIndex).v_y(timeIndex));
        end
        drawnow;
    end
end