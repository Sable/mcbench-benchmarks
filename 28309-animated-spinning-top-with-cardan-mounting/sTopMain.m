function [F] = sTopMain(fileToRead)
%STOPMAIN Plots an animated spinning top with Cardan mounting from raw
%animation data.
%
%   example call: sTopMain('animation_A.dat')
%
%   See PDF documentation for details.
%
%   Alexander Erlich (alexander.erlich@gmail.com)

rawData = importdata(fileToRead);
time = rawData(:,1);
phi = rawData(:,2);
theta = -1.*rawData(:,3);
psi = rawData(:,4);

sTopEuler;  % creating surf plots for the spinning Top in its initial position 
            % (phi, theta, psi) = (0, 0, 0)

for i=1:length(phi)-1
    if (ishandle(H1)~= 0)

        % computing the new position
        [Xtemp1,Ytemp1,Ztemp1]=...
            multiplyEuMat(EuMat(phi(i),theta(i),psi(i)),X1,Y1,Z1);
        [Xtemp2,Ytemp2,Ztemp2]=...
            multiplyEuMat(EuMat(phi(i),theta(i),0),X2,Y2,Z2);
        [Xtemp3,Ytemp3,Ztemp3]=...
            multiplyEuMat(EuMat(phi(i),0,0),X3,Y3,Z3);    
        [Xtempbar1,Ytempbar1,Ztempbar1]=...
            multiplyEuMat(EuMat(phi(i),theta(i),psi(i)),Xbar1,Ybar1,Zbar1);
        [Xtempbar2,Ytempbar2,Ztempbar2]=...
            multiplyEuMat(EuMat(phi(i),theta(i),psi(i)),Xbar2,Ybar2,Zbar2);

        % updating the new position
        set(H1,'XData',Xtemp1,'YData',Ytemp1,'ZData',Ztemp1);
        set(H2,'XData',Xtemp2,'YData',Ytemp2,'ZData',Ztemp2);
        set(H3,'XData',Xtemp3,'YData',Ytemp3,'ZData',Ztemp3); 
        set(bar1,'XData',Xtempbar1,'YData',Ytempbar1,'ZData',Ztempbar1);
        set(bar2,'XData',Xtempbar2,'YData',Ytempbar2,'ZData',Ztempbar2);

        drawnow % drawing the new position
        pause(time(i+1)-time(i)); % pausing until next frame is shown
    end
end