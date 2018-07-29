

function Beta=Beta_dictionary(M,nk)



for i=1:length(nk)
    
    temp_Beta(1,i)=1/nk(i);    
    for l=1:M-1
        temp_Beta(l+1,i)=alpha_generator(l,M,nk(i))/nk(i);
    end
    
end


Beta=temp_Beta;