function u_n = anisodiff(u, n_iter, tao, lambda, option)
%ANISODIFF   u_n = anisodiff(u, n_iter, tao, lambda, option)
%   Anisotropic Filter(Nonlinear Scalar Filter)
%   Support 1-D, 2-D, and 3-D
%
%   With Reference Daniel Lopes' Anisotropic Diffusion (Perona & Malik)
%   http://www.mathworks.cn/matlabcentral/fileexchange/14995-anisotropic-diffusion-perona-malik
%
%   Phymhan
%   09-Aug-2013 00:02:41

u = double(u);
u_n = u;

%% Naive method
% [M,N] = size(u);
% dx = 1;
% dy = 1;
% gn = 5;
% [x,y] = meshgrid(-gn:gn);
% if strcmpi(option,'gaussian')
%     cx = @(x,y) exp(-((x-y)/dx)^2/(2*lambda^2));
%     cy = @(x,y) exp(-((x-y)/dy)^2/(2*lambda^2));
% else
%     cx = @(x,y) 1/(1+((x-y)/dx)^2/lambda^2);
%     cy = @(x,y) 1/(1+((x-y)/dy)^2/lambda^2);
% end
% for kt = 1:n_iter
% %     t = kt*tao;
% %     G = exp(-(x.^2+y.^2)/(4*t))/(4*pi*t);
% %     u_sigma = conv2(u,G,'same')/sum(sum(G));
%     for ki = 2:M-1
%         for kj = 2:N-1
%             c11 = cx(u(ki,kj),u(ki-1,kj));
%             c12 = cx(u(ki+1,kj),u(ki,kj));
%             c21 = cy(u(ki,kj-1),u(ki,kj));
%             c22 = cy(u(ki,kj),u(ki,kj+1));
% %             c11 = cx(u_sigma(ki,kj),u_sigma(ki-1,kj));
% %             c12 = cx(u_sigma(ki+1,kj),u_sigma(ki,kj));
% %             c21 = cy(u_sigma(ki,kj-1),u_sigma(ki,kj));
% %             c22 = cy(u_sigma(ki,kj),u_sigma(ki,kj+1));
%             u_n(ki,kj) = u(ki,kj)+tao*(...
%                 (c12*(u(ki+1,kj)-u(ki,kj))-c11*(u(ki,kj)-u(ki-1,kj)))/(2*dx^2)+...
%                 (c22*(u(ki,kj+1)-u(ki,kj))-c21*(u(ki,kj)-u(ki,kj-1)))/(2*dy^2));
%         end
%     end
%     u = u_n;
%     % Iteration warning.
%     fprintf('\rIteration %d\n',kt);
% end

%% Use CONV2/GRADIENT/DIVERGENCE to accelerate calculation
if size(u,3) > 1
    nDim = 3;
else
    if size(u,1)~=1 && size(u,2)~=1
        nDim = 2;
    else
        nDim = 1;
    end
end
switch nDim
    case 1
        % 1D convolution masks - finite differences.
        hW = [1 -1 0]';
        hE = [0 -1 1]';
        for kt = 1:n_iter
            % Finite differences. [imfilter(.,.,'conv') can be replaced by conv(.,.,'same')]
            nablaW = imfilter(u_n,hW,'conv');
            nablaE = imfilter(u_n,hE,'conv');
            % Diffusion function.
            if option == 1
                cW = exp(-(nablaW/lambda).^2);
                cE = exp(-(nablaE/lambda).^2);
            elseif option == 2
                cW = 1./(1 + (nablaW/lambda).^2);
                cE = 1./(1 + (nablaE/lambda).^2);
            end
            % Discrete PDE solution.
            u_n = u_n + tao*(cW.*nablaW + cE.*nablaE);
            % Iteration warning.
            %fprintf('\rIteration %d\n',kt);
        end
    case 2
%         for kt = 1:n_iter
%             [px,py] = gradient(u);
%             if option == 1
%                 c = exp(-(px.^2+py.^2)/(2*lambda^2));
%             else
%                 c = 1./(1+(px.^2+py.^2)/lambda^2);
%             end
%             u_n = tao*divergence(c.*px,c.*py)+u;
%             u = u_n;
%             % Iteration warning.
%             %fprintf('\rIteration %d\n',kt);
%         end
%         
        % 2D convolution masks - finite differences.
        hN  = [0 1 0; 0 -1 0; 0 0 0];
        hS  = [0 0 0; 0 -1 0; 0 1 0];
        hE  = [0 0 0; 0 -1 1; 0 0 0];
        hW  = [0 0 0; 1 -1 0; 0 0 0];
        hNE = [0 0 1; 0 -1 0; 0 0 0];
        hSE = [0 0 0; 0 -1 0; 0 0 1];
        hSW = [0 0 0; 0 -1 0; 1 0 0];
        hNW = [1 0 0; 0 -1 0; 0 0 0];
        
        for kt = 1:n_iter
            nablaN  = imfilter(u_n,hN ,'conv');
            nablaS  = imfilter(u_n,hS ,'conv');
            nablaW  = imfilter(u_n,hW ,'conv');
            nablaE  = imfilter(u_n,hE ,'conv');
            nablaNE = imfilter(u_n,hNE,'conv');
            nablaSE = imfilter(u_n,hSE,'conv');
            nablaSW = imfilter(u_n,hSW,'conv');
            nablaNW = imfilter(u_n,hNW,'conv');
            
            % Diffusion function.
            if option == 1
                cN  = exp(-(nablaN /lambda).^2);
                cS  = exp(-(nablaS /lambda).^2);
                cW  = exp(-(nablaW /lambda).^2);
                cE  = exp(-(nablaE /lambda).^2);
                cNE = exp(-(nablaNE/lambda).^2);
                cSE = exp(-(nablaSE/lambda).^2);
                cSW = exp(-(nablaSW/lambda).^2);
                cNW = exp(-(nablaNW/lambda).^2);
            elseif option == 2
                cN  = 1./(1 + (nablaN /lambda).^2);
                cS  = 1./(1 + (nablaS /lambda).^2);
                cW  = 1./(1 + (nablaW /lambda).^2);
                cE  = 1./(1 + (nablaE /lambda).^2);
                cNE = 1./(1 + (nablaNE/lambda).^2);
                cSE = 1./(1 + (nablaSE/lambda).^2);
                cSW = 1./(1 + (nablaSW/lambda).^2);
                cNW = 1./(1 + (nablaNW/lambda).^2);
            end
            
            % Discrete PDE solution.
            u_n = u_n + tao*(...
                cN .*nablaN    + cS .*nablaS    + ...
                cW .*nablaW    + cE .*nablaE    + ...
                cNE.*nablaNE/2 + cSE.*nablaSE/2 + ...
                cSW.*nablaSW/2 + cNW.*nablaNW/2 );
            % Iteration warning.
            %fprintf('\rIteration %d\n',kt);
        end
    case 3
        for kt = 1:n_iter
            [px,py,pz] = gradient(u);
            if option == 1
                c = exp(-(px.^2+py.^2+pz.^2)/(2*lambda^2));
            else
                c = 1./(1+(px.^2+py.^2+pz.^2)/lambda^2);
            end
            u_n = tao*divergence(c.*px,c.*py,c.*pz)+u;
            u = u_n;
            % Iteration warning.
            %fprintf('\rIteration %d\n',kt);
        end
end
% u_n = uint8(u_n);
end
