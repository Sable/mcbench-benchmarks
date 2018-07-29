function showsteerable(coeff)
% Show the subbands of steerable pyramid

figure();
ht=length(coeff);

for i=2:length(coeff)-1
    for j=1:4
        subplot(ht-2,4,(i-2)*4+j);
        imshow(coeff{i}{j},[]);
    end
end

