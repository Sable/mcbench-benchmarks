function out=errorpattern(syndrome)
%function to get the error pattern given the syndrome..A matrix with three
%columns and any number of rows
%Works only for parity check matrix H=[eye(3),transpose([0,1,1;1,0,1;1,1,0;1,1,1])];
%
%Author: Brhanemedhn Tegegne
%
    r=size(syndrome,1);
    out=zeros(r,7); 
    for i=1:r
        if sum(xor(syndrome(i,:),[0,0,0]))==0
            out(i,:)=[0,0,0,0,0,0,0];
        end
        if sum(xor(syndrome(i,:),[0,0,1]))==0
            out(i,:)=[0,0,1,0,0,0,0];
        end        
        if sum(xor(syndrome(i,:),[0,1,0]))==0
            out(i,:)=[0,1,0,0,0,0,0];
        end        
        if sum(xor(syndrome(i,:),[0,1,1]))==0
            out(i,:)=[0,0,0,1,0,0,0];
        end        
        if sum(xor(syndrome(i,:),[1,0,0]))==0
            out(i,:)=[1,0,0,0,0,0,0];
        end        
        if sum(xor(syndrome(i,:),[1,0,1]))==0
            out(i,:)=[0,0,0,0,1,0,0];
        end        
        if sum(xor(syndrome(i,:),[1,1,0]))==0
            out(i,:)=[0,0,0,0,0,1,0];
        end        
        if sum(xor(syndrome(i,:),[1,1,1]))==0
            out(i,:)=[0,0,0,0,0,0,1];
        end        
    end

end