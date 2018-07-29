%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inhomo_iso.m demonstrates Edge-preserving non-linear
% inhomogeneous linear isotropic filtering for denoising
%
% Copyright (c) Ritwik Kumar, Harvard University 2010
%               www.seas.harvard.edu/~rkkumar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
%read the image
im = image_read('synimgn2');
w = double(im);

% set up finite difference parameters
alpha =0.5;
k = 1;
h = 1;

lambda = (alpha^2)*(k/(h^2));

[m n] = size(w);
% stick image into a vector
w_vec = reshape(w,n*n,1);
w_old = w_vec;
w_new = w_vec;

%smooth the image using Gaussian filtering
im_smth = filter_function(w,3);

%required of g() calculation
[dx_im_smth dy_im_smth] = gradient(im_smth);
gr_im_smth = dx_im_smth.^2 + dy_im_smth.^2;

% element by element g() calculation
[mmm nnn] = size(gr_im_smth);
for i=1:mmm
    for j=1:nnn
        g(i,j) = 1/(1+(gr_im_smth(i,j)/36));
    end
end
g = g';
jj=1;

figure;
for k=1:200   % for each iteration 
    for i=1:n*n % solve using JAcobi iteration scheme
        row = ceil(i/n); %compute what row this pixel belongs to in original image
        col = i - (row-1) * n; % compute the column similarly

        %different if conditions handles pixels at different location in
        %the image as depending on their location they may or may not have
        %all their neighbor pixels which will be required for finite
        %differences
        
        if((col > 1) && (col < n) && (row > 1) && (row < n))
            xx = [(lambda * (-g(row,col) + g(row,col+1) + g(row+1,col) -g(row+1,col+1))) * ...
                    (- w_old(i) + w_old(i+1) - w_old(i+n) + w_old(i+n+1))];
            
            s = [-(lambda * g(row,col)) * (w_old(i+1) + w_old(i-1) + w_old(i+n) + w_old(i-n))] ...
                + xx;
            w_new(i) = (-s + w_old(i))/(1+4*lambda*g(row,col));
        elseif((row == 1) && (col > 1) && (col < n))
            xx = [(lambda * (-g(row,col) + g(row,col+1) + g(row+1,col) -g(row+1,col+1))) * ...
                    (- w_old(i) + w_old(i+1) - w_old(i+n) + w_old(i+n+1))];
            
            s = [-(lambda * g(row,col)) * (w_old(i+1) + w_old(i-1) + w_old(i+n))] ...
                + xx;
            
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((row == n) && (col > 1) && (col < n))
            xx = [(lambda * (-g(row,col) + g(row,col+1))) * ...
                    (- w_old(i) + w_old(i+1))];
            
            s = [-(lambda * g(row,col)) * (w_old(i+1) + w_old(i-1) + w_old(i-n))] ...
                + xx;
            
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col == 1) && (row > 1) && (row < n))
            xx = [(lambda * (-g(row,col) + g(row,col+1) + g(row+1,col) -g(row+1,col+1))) * ...
                    (- w_old(i) + w_old(i+1) - w_old(i+n) + w_old(i+n+1))];
            
            s = [-(lambda * g(row,col)) * (w_old(i+1) + w_old(i+n) + w_old(i-n))] ...
                + xx;
            
            %s = -(lambda) * (w_old(i+1) + w_old(i+n) + w_old(i-n));
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col == n) && (row > 1) && (row < n))
            xx = [(lambda * (-g(row,col) + g(row+1,col) )) * ...
                    (- w_old(i)  - w_old(i+n))];
            
            s = [-(lambda * g(row,col)) * ( w_old(i-1) + w_old(i+n) + w_old(i-n))] ...
                + xx;
            
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==1) && (row==1))
            xx = [(lambda * (-g(row,col) + g(row,col+1) + g(row+1,col) -g(row+1,col+1))) * ...
                    (- w_old(i) + w_old(i+1) - w_old(i+n) + w_old(i+n+1))];
            
            s = [-(lambda * g(row,col)) * (w_old(i+1) + w_old(i+n))] ...
                + xx;
            
            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==n) && (row==1))
                        xx = [(lambda * (-g(row,col) + g(row+1,col))) * ...
                (- w_old(i)  - w_old(i+n) )];

            s = [-(lambda * g(row,col)) * (w_old(i-1) + w_old(i+n))] ...
                + xx;

            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==1) && (row==n))
                       xx = [(lambda * (-g(row,col) + g(row,col+1) )) * ...
                (- w_old(i) + w_old(i+1) )];

            s = [-(lambda * g(row,col)) * (w_old(i+1) + w_old(i-n))] ...
                + xx;

            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        elseif((col==n) && (row==n))
                        xx = [(lambda * (-g(row,col) )) * ...
                (- w_old(i) )];

            s = [-(lambda * g(row,col)) * ( w_old(i-1) + w_old(i-n))] ...
                + xx;

            w_new(i) = (-s + w_old(i))/(1+4*lambda);
        end
    end
    w_old = w_new;
    if((k==10)||(k==50)||(k==100)||(k==200)) % outputting the values at different iterations
        subplot(2,2,jj)
        imshow(uint8(reshape(w_new,n,n)));
        imwrite(uint8(reshape(w_new,n,n)),strcat('iso-synimgn2',int2str(jj),'.bmp'));        
                title('Linear Inhomogeneous Isotropic Filtering (Implicit Euler Method)');
        xlabel(strcat('Lenna at t=',int2str(k),', Alpha=0.5'));        
        

        jj=jj+1;
    end
    
end