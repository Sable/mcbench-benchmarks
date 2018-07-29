%% Radar Plan Position Indicator(PPI) Simulation

% Created by
% R.Vivek
% MIT (Anna University)


%% Description
% This function displays the Radar PPI plot for detection and ...
% tracking of a single target approaching at a specified angle.

%% 

function PPI_plot(dist,Angle,Max_Range)

%% "dist" is an array containing the distance (in meters) of the target

%% "Angle" is the angle (in radians) with respect to the radar transceiver 
%  at which the target is approaching 

%% "Max_Range" is the maximum detectable range of the radar

%% -------------------------------------------------------------------------

angle=repmat(Angle,1,(length(dist)));

for j=1:length(dist)
    for i=(2*pi):-(pi/180):(pi/180)
        [x,y]=(pol2cart(i,55));
        x=ceil(x);
        z=complex(x,y); 
        h=compass(z);
        title('Radar PPI Plot');
        ph=findall(gca,'type','patch');
        set(ph,'facecolor',[0,0.5,0]);
        set( h, 'Color', [0.5,1,0] ); 
        set( h, 'LineWidth', 4 );  
        for k = 1:length(h)
            a = get(h(k), 'xdata'); 
            b = get(h(k), 'ydata'); 
            set(h(k), 'xdata', a(1:2), 'ydata', b(1:2)')
        end
        
        if(j>1)
            if(angle(j-1)<i)
                hold on
                plothandle=polar(angle(j-1),dist(j-1),'o');
                set(plothandle,'markerfacecolor',[0,1,0],'markeredgecolor',[0,1,0]);  
                get( plothandle ) ;
                set( plothandle, 'Color', [ 0.5, 1, 0 ] );  
                set ( plothandle, 'LineWidth', 2 );   
                hold off
            end
        end
        if(dist(j)<=Max_Range)
        if(angle(j)>=i)
            hold on
            plothandle=polar(angle(j),dist(j),'o');
            set(plothandle,'markerfacecolor',[0,1,0],'markeredgecolor',[0,1,0])
            get( plothandle ) ;
            set( plothandle, 'Color', [ 0.5, 1, 0 ] );  
            set ( plothandle, 'LineWidth', 2 ); 
            hold off
        end
        end
        pause(1*10^-6);
        end
    end

end

