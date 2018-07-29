        % Deschiderea unei ferestre de figuri
figure(1)
t = -10*pi:pi/250:10*pi;
        % Desenarea cometei tridimensionale
comet3((cos(2*t).^2).*sin(t),(sin(2*t).^2).*cos(t),t);