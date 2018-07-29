function animateHessianGaussian(fname)
%animate HessianGaussian - creates a figure with a rotationg second order
%derivative. It is calculated each frame by combining the three kernels of
%the Hessian matrix: Lxx, Lyy and Lxy. Using these three kernels, the
%second order derivative can be calculated in any direction!
%
% animateHessianGaussian() displays the animation
%
% animateHessianGaussian(fname) makes an animated gif of the animation, and
% writes it to fname.

    
    if nargin==0;  fname=[];  end;
        
    H = []; % data container
    
    H.fname = fname;
    
    % create figure
    H.hf = figure(100202); clf;
    set(H.hf,'MenuBar','none','position',[500 500 400 300],'NumberTitle','off','color','k');
    if ~isempty(H.fname);   set(H.hf,'name','Waiting one round before creating AVI...');
    else;                   set(H.hf,'name','Rotating second order Gaussian derivative');
    end;
    colormap winter;
    shading faceted;
    
    % create timer
    H.ht = timer(   'TimerFcn',@animateHessianGaussian_nextAngle,...
                    'period',0.05,...
                    'ExecutionMode','fixedSpacing',...
                    'TasksToExecute',inf);
                
    
    % create kernels
    sig = 6;
    H.Kxx = gaussiankernel2(sig,2,0,4);
    H.Kyy = gaussiankernel2(sig,0,2,4);
    H.Kxy = gaussiankernel2(sig,1,1,4);

    % initialise angle, and set delta-angle
    H.phi = 0.01; % start slightly more. So animation starts writing to gif after one round
    H.dphi = 0.05;
        
    % init surface plot and axes
    H.hsurf = surf(H.Kxx);
    axis([0 40 0 40 -0.0001 0.0001]);
    axis off;
    shg;
    
    % set axes nice
    set(gca,'units','normalized','position',[0 0 1 1]);
    rotate3d on;
    
    % store data in the timer object.
    set(H.ht,'UserData',H);
    
    % start timer
    start(H.ht);    
    
end % of main

function animateHessianGaussian_nextAngle(hObject,events)
  
    try 
        % get data
        H = get(hObject,'UserData');
        
        % if figure or surfplot gone, stop alltogeher    
        if ~ishandle(H.hf) || ~ishandle(H.hsurf)
            stop(hObject);
            delete(hObject);
            return;
        end
        
        
        % increase angle
        H.phi = H.phi + H.dphi;
        if H.phi>2*pi; H.phi = 0; end; 
        
        % create kernel from the three base kernels
        a       = cos(H.phi);
        b       = sin(H.phi);
        patch   = a*a*H.Kxx + b*b*H.Kyy + 2*a*b*H.Kxy;
        
        % show kernel
        set(H.hsurf,'CData',patch,'Zdata',patch); drawnow;
        
        
        % make animation? AVI
        if ~isempty(H.fname)
            % make screenshot
            H.movie(1) = getframe(H.hf);
            if H.phi==0
                if ~strcmp( get(H.hf,'name') , 'Creating AVI...' )
                    set(H.hf,'name','Creating AVI...');
                    H.movie = getframe(H.hf);
                else                    
                    movie2avi(H.movie,H.fname); % write file
                    H.fname=[];                 % go to normal mode
                    set(H.hf,'name','Done...');                    
                end
            elseif strcmp( get(H.hf,'name') , 'Creating AVI...' )
                H.movie(end+1) = getframe(H.hf);
            end
        end
                
        % store data back
        set(H.ht,'UserData',H);
        
    catch
        disp(lasterr);
        stop(hObject);
        delete(hObject);
        return;
    end
    
end

