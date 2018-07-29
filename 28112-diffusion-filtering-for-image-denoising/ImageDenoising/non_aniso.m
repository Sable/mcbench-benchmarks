%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% non-aniso.m demonstrates Edge-preserving non-linear
% anisotropic filtering for denoising
%
% Copyright (c) Ritwik Kumar, Harvard University 2010
%               www.seas.harvard.edu/~rkkumar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
im = image_read('lenna'); % read image
w = double(im);

% set up finite difference parameters
alpha =.5;
k = 1;
h = 1;

lambda = (alpha^2)*(k/(h^2));

[m n] = size(w);
%stick image into a vector
w_vec = reshape(w,n*n,1);
w_old = w;
w_new = w;

%smooth the image
im_smth = filter_function(w,1);
im_smth = im_smth';
% required for g() calculation
[dx_im_smth dy_im_smth] = gradient(im_smth);
gr_im_smth = dx_im_smth.^2 + dy_im_smth.^2;

[mmm nnn] = size(gr_im_smth);
% g() calculation
for i=1:mmm
    for j=1:nnn
        g(i,j) = 1/(1+(gr_im_smth(i,j)/32));
    end
end
%g = g';
jj=1;

[im_sx im_sy]  = gradient(im_smth);
% diffusion tensor D is preconputed here
D = zeros(n*n,2,2);
for i=1:n*n
    row = ceil(i/n);
    col = i - (row-1) * n;
  %  if((col > 1) && (col < n) && (row > 1) && (row < n))
        
        % choose eigenvector parallel and perpendicular to gradient
        eigen_vec = [im_sx(row,col) im_sy(row,col); im_sy(row,col) -im_sx(row,col) ];
        %choose eigenvalues
        eigen_vec(:,1) = eigen_vec(:,1) ./ norm(eigen_vec(:,1));
        eigen_vec(:,2) = eigen_vec(:,2) ./ norm(eigen_vec(:,2));
        eigen_val = [g(row,col) 0;0 1];
        
        % form diffusion tensor
        D(i,:,:) = eigen_vec * eigen_val * (eigen_vec');        
        % end
end

figure;
for k=1:400 % for each iteration
    for i=1:n*n % solve using Jacobi iterations scheme
        row = ceil(i/n); %compute what row this pixel belongs to in original image
        col = i - (row-1) * n; % compute cols similarly

        %different if conditions handles pixels at different location in
        %the image as depending on their location they may or may not have
        %all their neighbor pixels which will be required for finite
        %differences
        
        if((col > 1) && (col < n) && (row > 1) && (row < n))
            
            s = -lambda * ((D(i,1,1) * w_old(i-1)) + ((D(i,1,1) - D(i,1,2) - D(i,2,1)) * (w_old(i+1))) +  ...
                (D(i,2,2) * w_old(i-n)) + ((D(i,2,2) - D(i,1,2) - D(i,2,1)) * (w_old(i+n))) + ((D(i,1,2) + D(i,2,1)) * w_old(i+n+1)));
            w_new(i) = (-s + w_old(i))/(1 + lambda * (2 * D(i,1,1) + 2 * D(i,2,2) - D(i,1,2) - D(i,2,1)));
            
        elseif((row == 1) && (col > 1) && (col < n))
            s = -lambda * ((D(i,1,1) * w_old(i-1)) + ((D(i,1,1) - D(i,1,2) - D(i,2,1)) * (w_old(i+1))) +  ...
                ((D(i,2,2) - D(i,1,2) - D(i,2,1)) * (w_old(i+n))) + ((D(i,1,2) + D(i,2,1)) * w_old(i+n+1)));
            
            %s = -(lambda) * (w_old(i+1) + w_old(i-1) + w_old(i+n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((row == n) && (col > 1) && (col < n))
            s = -lambda * ((D(i,1,1) * w_old(i-1)) + ((D(i,1,1) - D(i,1,2) - D(i,2,1)) * (w_old(i+1))) +  ...
                (D(i,2,2) * w_old(i-n)));
            
            %s = -(lambda) * (w_old(i+1) + w_old(i-1) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col == 1) && (row > 1) && (row < n))
            s = -lambda * (((D(i,1,1) - D(i,1,2) - D(i,2,1)) * (w_old(i+1))) +  ...
                (D(i,2,2) * w_old(i-n)) + ((D(i,2,2) - D(i,1,2) - D(i,2,1)) * (w_old(i+n))) + ((D(i,1,2) + D(i,2,1)) * w_old(i+n+1)));
            
            %s = -(lambda) * (w_old(i+1) + w_old(i+n) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col == n) && (row > 1) && (row < n))
            s = -lambda * ((D(i,1,1) * w_old(i-1)) +  ...
                (D(i,2,2) * w_old(i-n)) + ((D(i,2,2) - D(i,1,2) - D(i,2,1)) * (w_old(i+n))));            
            %s = -(lambda) * (w_old(i-1) + w_old(i+n) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==1) && (row==1))
            s = -lambda * (((D(i,1,1) - D(i,1,2) - D(i,2,1)) * (w_old(i+1))) +  ...
                ((D(i,2,2) - D(i,1,2) - D(i,2,1)) * (w_old(i+n))) + ((D(i,1,2) + D(i,2,1)) * w_old(i+n+1)));            
            %s = -(lambda) * (w_old(i+1) + w_old(i+n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==n) && (row==1))
            s = -lambda * ((D(i,1,1) * w_old(i-1))  +  ...
                ((D(i,2,2) - D(i,1,2) - D(i,2,1)) * (w_old(i+n))));            
            %s = -(lambda) * (w_old(i-1) + w_old(i+n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==1) && (row==n))
            s = -lambda * (((D(i,1,1) - D(i,1,2) - D(i,2,1)) * (w_old(i+1))) +  ...
                (D(i,2,2) * w_old(i-n)) );            
            %s = -(lambda) * (w_old(i+1) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==n) && (row==n))
            s = -lambda * ((D(i,1,1) * w_old(i-1)) +  ...
                (D(i,2,2) * w_old(i-n)));            
            %s = -(lambda) * (w_old(i-1) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        end
    end    
    w_old = w_new;
    if((k==10)||(k==50)||(k==100)||(k==200)) % output at different iterations
        subplot(2,2,jj)
        imshow(uint8(reshape(w_new,n,n)));
        imwrite(uint8(reshape(w_new,n,n)),strcat('aniso-synimgn2',int2str(jj),'.bmp'));
        
                title('Non-linear Anisotropic Filtering using Implicit Euler Method');
        xlabel(strcat('Lenna at t=',int2str(k),', Alpha=0.5'));        
        

        jj=jj+1;
    end
    
end
% subplot 131
% imshow(im);
% subplot 132
% imshow(uint8(reshape(w_new,n,n)));
% subplot 133
% imshow(uint8(filter_function(w,30)));
