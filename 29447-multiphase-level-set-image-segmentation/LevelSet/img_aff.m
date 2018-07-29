
function img_aff(M)

global x_iteration;
global x_frequency;

global iter;
global memory;
if isempty(iter) 
    iter = 1;
else
    iter=iter+1;
end

M=transposer(M);
Nb=size(M,3); 
if Nb==1
    M(:,:,2)=M(:,:,1);
    M(:,:,3)=M(:,:,1);
end

N=size(M);

for i=1:N(1)
    for j=1:N(2)
        if M(i,j,1) > 500
            M(i,j,:)=Zlevelset_color(M(i,j,1));            
        end
    end
end

memory(iter).matrice=M;
    

    axes('position',[.25 .4 .3 .4]);
    imshow(uint8(M));
    title('Curve Evolution');


