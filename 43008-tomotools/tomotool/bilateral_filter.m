function u_n = bilateral_filter(u, n_iter, gn, lambda_s, lambda_r, option)
u = double(u);
[M,N] = size(u);
if nargin < 6
    lambda_s = gn/2;
    lambda_r = 255;
    option = 1;
end
if option == 1
    f_s = @(x) exp(-(x)/(2*lambda_s^2));
    f_r = @(x) exp(-(x)/(2*lambda_r^2));
else
    f_s = @(x) 1./(1+(x)/lambda_s^2);
    f_r = @(x) 1./(1+(x)/lambda_r^2);
end
[x,y] = meshgrid(-gn:gn);
Gs = f_s(x.^2+y.^2);
u_n = u;
u = zeros(M+2*gn,N+2*gn);
u(gn+1:gn+M,gn+1:gn+N) = u_n;
%u0_0 = min(min(u_n));
for kt = 1:n_iter
    for ii = 1:M
        for jj = 1:N
            mr = u(ii:ii+2*gn,jj:jj+2*gn);
            %Gr = f_r((255-mr).^2);
            Gr = f_r((mr-u(ii,jj)).^2);
            G = Gs.*Gr;
            W = sum(sum(G));
            u_n(ii,jj) = sum(sum(mr.*G))/W;
%             %DEBUG
%             subplot 221
%             surf(x,y,mr)
%             subplot 222
%             surf(x,y,Gs)
%             subplot 223
%             surf(x,y,Gr)
%             subplot 224
%             surf(x,y,G)
%             fprintf('press any key to continue...\r')
%             waitforbuttonpress
        end
    end
    u(gn+1:gn+M,gn+1:gn+N) = u_n;
    % Iteration warning.
    fprintf('\rIteration %d\n',kt);
%     imshow(uint8(u_n))
%     fprintf('press any key to continue...\r')
%     waitforbuttonpress
end

u_n = uint8(u_n);
end
