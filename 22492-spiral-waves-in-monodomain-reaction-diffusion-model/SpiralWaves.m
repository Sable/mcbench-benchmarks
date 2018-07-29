function SpiralWaves(StimProtocol)

% Matlab implementation a monodomain reaction-diffusion model in 2-D. 
% The model equations are a variant of the Fitzhugh-Nagumo equations
% modified to simulate the cardiac action potential. The progression
% of the two normalized state variables, membrane voltage (v) and recovery 
% (r), is computed across a 128 x 128 spatial domain and across time. This 
% function simulates spiral waves, which are hypothesized to underlie 
% reentrant tachycardia. The spiral waves can be initiated by two different 
% cardiac pacing methods: 
%
% (1) two-point stimulation where a point stimulus is delivered in the 
% center of the domain followed by another point stimulus on the partially
% refractory wake of the first wave of excitation.
%
% (2) cross-field stimulation where a stimulus is applied to the left 
% domain boundary causing a plane wave. As this wave travels across the
% domain, a second stimulus is applied to the bottom boundary of the domain.
%
% This function accepts only one input argument, StimProtocol, which can 
% be either the numerical values '1' (for two-point stimulation) or '2' 
% (for cross-field stimulation). As the simulation runs, the activation 
% state of the individual units comprising the domain is mapped to color 
% and plotted in a figure window. A count of time steps is displayed at 
% the top of the plot along with the values of v and r for the upper left 
% element of the domain. 
% 
% Model equations are solved using a finite difference method for spatial 
% derivatives and explicit Euler integration for time derivatives. Newman
% boundary conditions are assumed. Model parameters are taken from two 
% journal articles: [1] Rogers JM et al. "A collocation-Galerkin finite 
% element model of cardiac action potential propagation". IEEE TBME;41:
% 743-757,1994. [2] Pertsov AM et al. "Spiral waves of excitation underlie 
% reentrant activity in isolated cardiac muscle". Circulation Research;72:
% 631-650, 1993. 
%
% Following the simulated spiral waves, a movie (AVI) is generated, and 
% the user is given the option to save the movie to disk. One simulation 
% takes about 160 seconds on a 2.33 GHz Intel Dual Core 64-bit laptop 
% (3.3 GB RAM).
%
% This function was written by Peter E. Hammer (hammer@usa.com) in 
% October 2006 as part of an academic project associated with PhD studies 
% in biomedical engineering. Have fun!

ncols=128;                               % Number of columns in domain
nrows=128;                               % Number of rows in domain
dur=25000;                               % Number of time steps
h=2.0;                                   % Grid size
h2=h^2;
dt=0.15;                                 % Time step
Iex=30;                                  % Amplitude of external current
mu=1.0;                                  % Anisotropy
Gx=1; Gy=Gx/mu;                          % Conductances
a=0.13; b=0.013; c1=0.26; c2=0.1; d=1.0; % FHN model parameters
v=zeros(nrows,ncols);                    % Initialize voltage array
r=v;                                     % Initialize refractoriness array

% Set initial stim current and pattern
iex=zeros(nrows,ncols);
if StimProtocol==1
    iex(62:67,62:67)=Iex;
else
    iex(:,1)=Iex;
end

% Setup image
ih=imagesc(v); set(ih,'cdatamapping','direct')
colormap(hot); axis image off; th=title('');
set(gcf,'position',[500 600 256 256],'color',[1 1 1],'menubar','none')

% Create 'Quit' pushbutton in figure window
uicontrol('units','normal','position',[.45 .02 .13 .07], ...
    'callback','set(gcf,''userdata'',1)',...
    'fontsize',10,'string','Quit');

n=0;                 % Counter for time loop
k=0;                 % Counter for movie frames
done=0;              % Flag for while loop

n1e=20;              % Step at which to end 1st stimulus
switch StimProtocol
    case 1           % Two-point stimulation
        n2b=3800;    % Step at which to begin 2nd stimulus
        n2e=3900;    % Step at which to end 2nd stimulus
    case 2           % Cross-field stimulation
        n2b=5400;    % Step at which to begin 2nd stimulus
        n2e=5420;    % Step at which to end 2nd stimulus
end

while ~done          % Time loop
    
    if n == n1e      % End 1st stimulus
        iex=zeros(nrows,ncols);
    end
    
    if n == n2b      % Begin 2nd stimulus
        switch StimProtocol
            case 1
                iex(62:67,49:54)=Iex;
            case 2
                iex(end,:)=Iex;
        end
    end
    
    if n == n2e      % End 2nd stimulus
        iex=zeros(nrows,ncols);
    end
    
    % Create padded v matrix to incorporate Newman boundary conditions 
    vv=[[0 v(2,:) 0];[v(:,2) v v(:,end-1)];[0 v(end-1,:) 0]];
    
    % Update v
    vxx=(vv(2:end-1,1:end-2) + vv(2:end-1,3:end) -2*v)/h2; 
    vyy=(vv(1:end-2,2:end-1) + vv(3:end,2:end-1) -2*v)/h2;
    dvdt=c1*v.*(v-a).*(1-v)-c2*v.*r+iex+Gx*vxx+Gy*vyy; 
    v_new=v + dvdt*dt;
    
    % Update r
    drdt=b*(v-d*r);
    r=r + drdt*dt;
    v=v_new; clear v_new
    
    % Map voltage to image grayscale value
    m=1+round(63*v); m=max(m,1); m=min(m,64);
    
    % Update image and text 
    set(ih,'cdata',m);
    set(th,'string',sprintf('%d  %0.2f   %0.2f',n,v(1,1),r(1,1)))
    drawnow
    
    % Write every 500th frame to movie 
    if rem(n,500)==0
        k=k+1;
        mov(k)=getframe;
    end
    
    n=n+1;
    done=(n > dur);
    if max(v(:)) < 1.0e-4, done=1; end      % If activation extinguishes, quit early.
    if ~isempty(get(gcf,'userdata')), done=1; end % Quit if user clicks on 'Quit' button.
end

% Write movie as AVI
if isunix, sep='/'; else sep='\'; end
[fn,pn]=uiputfile([pwd sep 'SpiralWaves.avi'],'Save movie as:');
if ischar(fn)
    movie2avi(mov,[pn fn],'quality',75)
else
    disp('User pressed cancel')
end

close(gcf)