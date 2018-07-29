function [speedup dsize ksize] = testcudaconv()
%TESTCUDACONV Benchmarks GPU vs CPU convolution.
%   [SPEEDUP DSIZE KSIZE] = TESTCUDACONV() runs 2-D 
%   convolutions on random data using both CONV2 and CUDACONV.
%
%   SPEEDUP contains the relative speed of CONV2 and CUDACONV.
%   Thus if SPEEDUP(i,j) = 10, CUDACONV completed the convolution
%   of random DSIZE(i) x DSIZE(i) and KSIZE(j) x KSIZE(j)
%   matrices in 1/10 the time of CONV2.
%
%   DSIZE and KSIZE contain the number of elements in the data
%   and kernel matrices, respectively, for each convolution.

data_sizes		= 100:100:800;
kernel_sizes 	= 10:20:90;
nrepeats		= 3;

gpu_results		= zeros(numel(data_sizes),numel(kernel_sizes));
cpu_results		= zeros(numel(data_sizes),numel(kernel_sizes));


for ds = 1:numel(data_sizes)
	disp(sprintf('Data size: %d elements\n',data_sizes(ds)^2));
	data = rand(data_sizes(ds));
	for ks = 1:numel(kernel_sizes)
		disp(sprintf(' Kernel size: %d elements\n',kernel_sizes(ks)^2));
		kernel = rand(kernel_sizes(ks));
		
		gpu_temp = zeros(1,nrepeats);
		cpu_temp = zeros(1,nrepeats);
		
		for t = [1 1:nrepeats]
			tic;
			temp = cudaconv(data,kernel);
			gpu_temp(t) = toc;
			
			tic;
			temp = conv2(data,kernel,'same');
			cpu_temp(t) = toc;
		end
		
		gpu_results(ds,ks) = mean(gpu_temp);
		cpu_results(ds,ks) = mean(cpu_temp);
	end
end

speedup = cpu_results./gpu_results;

dsize = data_sizes.^2;
ksize = kernel_sizes.^2;

[x y] = meshgrid(ksize,dsize);

figure;
[c h] = contourf(x,y,speedup,[1 5:5:100]); colorbar;
clabel(c,h,'color',[0 0 0],'FontSize',13,'LabelSpacing',400);
xlabel('Kernel size (# of elements)')
ylabel('Data size (# of elements)')
title('Relative speedup (GPU vs. CPU)')


%dlmwrite('performance2.dat',speedup,',');