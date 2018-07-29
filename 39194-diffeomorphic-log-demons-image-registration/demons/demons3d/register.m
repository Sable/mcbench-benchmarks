%% Register two images
%  Changed: Dec 31st, 2011
%
function [Mp,sx,sy,sz,vx,vy,vz] = register(F,M,opt)


    if nargin<3;  opt = struct();  end;
    if ~isfield(opt,'sigma_fluid');      opt.sigma_fluid     = 1.0;              end;
    if ~isfield(opt,'sigma_diffusion');  opt.sigma_diffusion = 1.0;              end;
    if ~isfield(opt,'sigma_i');          opt.sigma_i         = 1.0;              end;
    if ~isfield(opt,'sigma_x');          opt.sigma_x         = 1.0;              end;
    if ~isfield(opt,'niter');            opt.niter           = 250;              end;
    if ~isfield(opt,'vx');               opt.vx              = zeros(size(M));   end;
    if ~isfield(opt,'vy');               opt.vy              = zeros(size(M));   end;
    if ~isfield(opt,'vz');               opt.vz              = zeros(size(M));   end;
    if ~isfield(opt,'piggyback');        opt.piggyback       = 1.2;              end;
    if ~isfield(opt,'stop_criterium');   opt.stop_criterium  = 1e-4;             end;
    if ~isfield(opt,'do_display');       opt.do_display      = 1;                end;
    if ~isfield(opt,'do_plotenergy');    opt.do_plotenergy   = 1;                end;
    if ~isfield(opt,'do_avi');           opt.do_avi          = 0;                end;
    
    if opt.do_avi
        if ~isfield(opt, 'aviobj')
            opt.aviobj = avifile('spectral-demons.avi','compression','None', 'fps',10);
            opt.do_closeavi = 1; % create and close avi file here
        end
        if ~isfield(opt, 'do_closeavi'); opt.do_closeavi = 0; end;
        global aviobj;
        aviobj = opt.aviobj;
    end;

    %% Piggyback image
    [F,lim] = piggyback(F,opt.piggyback);
    [M,lim] = piggyback(M,opt.piggyback);
    
    %% T is the deformation from F to M
    if ~isempty(opt.vx) && ~isempty(opt.vy) && ~isempty(opt.vz)
        vx = piggyback(opt.vx,opt.piggyback);
        vy = piggyback(opt.vy,opt.piggyback);
        vz = piggyback(opt.vz,opt.piggyback);
    end
    e  = zeros(1,opt.niter);
    e_min = 1e+100;      % Minimal energy
    
    %% Iterate update fields
    for iter=1:opt.niter

        % Find update
        [ux,uy,uz] = findupdate(F,M,vx,vy,vz,opt.sigma_i,opt.sigma_x);

        % Regularize update
        ux    = imgaussian(ux,opt.sigma_fluid);
        uy    = imgaussian(uy,opt.sigma_fluid);
        uz    = imgaussian(uz,opt.sigma_fluid);

        % Compute step (max half a pixel)
        step  = opt.sigma_x;
        
        % Update correspondence (demons) - additive
        vx = vx + step*ux;
        vy = vy + step*uy;
        vz = vz + step*uz;

        % Update correspondence (demons) - composition
        %[vx,vy,vz] = compose(vx,vy,vz,step*ux,step*uy,step*uz);
        
        % Regularize deformation
        vx = imgaussian(vx,opt.sigma_diffusion);
        vy = imgaussian(vy,opt.sigma_diffusion);
        vz = imgaussian(vz,opt.sigma_diffusion);

        % Get Transformation
        [sx,sy,sz] = expfield(vx,vy,vz);  % deformation field
        
        % Compute energy
        e(iter) = energy(F,M,sx,sy,sz,opt.sigma_i,opt.sigma_x);
        disp(['Iteration: ' num2str(iter) ' - ' 'energy: ' num2str(e(iter))]);
        if e(iter)<e_min
            sx_min = sx; sy_min = sy; sz_min = sz;
            vx_min = vx; vy_min = vy; vz_min = vz;
            e_min  = e(iter);
        end
        
        % Stop criterium
        if iter>1 && abs(e(iter) - e(max(1,iter-5))) < e(1)*opt.stop_criterium
            break;
        end

        if opt.do_display
            % display deformation
            subplot(2,4,7); showvector(ux,uy,uz,4,0,lim); title('Update');
            subplot(2,4,8); showgrid  (sx,sy,sz,4,lim);   title('Transformation');
            drawnow;
            
            % Display registration
            Mp     = iminterpolate(M,sx,sy,sz);
            diff   = (F-Mp).^2;
            showimage(F,'Fixed', M,'Moving', Mp,'Warped', diff,'Diff', 'lim',lim,'nbrows',2,'caxis',[0 256]); drawnow;

            % Plot energy
            if opt.do_plotenergy
                subplot(2,2,3)
                hold on;
                plot(1:iter,e(1:iter),'r-'); xlim([0 opt.niter]);
                xlabel('Iteration'); ylabel('Energy');
                hold off;
                drawnow
            end
        end
        
        if opt.do_avi; aviobj = addframe(aviobj,getframe(gcf)); end;
        
    end
    
    %% Get Best Transformation
    vx = vx_min;  vy = vy_min;  vz = vz_min;
    sx = sx_min;  sy = sy_min;  sz = sz_min;

    %% Transform moving image
    Mp = iminterpolate(M,sx,sy,sz);
    
    %% Unpiggyback
    Mp = Mp(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    vx = vx(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    vy = vy(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    vz = vz(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    sx = sx(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    sy = sy(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));
    sz = sz(lim(1):lim(2),lim(3):lim(4),lim(5):lim(6));

    if opt.do_avi && opt.do_closeavi
        aviobj = close(aviobj);
    end
    
end

%% Get energy
function e = energy(F,M,sx,sy,sz,sigma_i,sigma_x)

    % Intensity difference
    Mp     = iminterpolate(M,sx,sy,sz);
    diff2  = (F-Mp).^2;
    area   = numel(M);

    % Transformation Gradient
    jac = jacobian(sx,sy,sz);
    
    % Three energy components
    e_sim  = sum(diff2(:)) / area;
    e_reg  = sum(jac(:).^2) / area;
    
    % Total energy
    e      = e_sim + (sigma_i^2/sigma_x^2) * e_reg;

end

