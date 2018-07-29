function lostsales = calclostsales(dem,lostdemcost,horizon,nosalespt)
lostsales = 0;
for i = 1:horizon
    for j = 1:nosalespt
       lostsales =  dem(i,j)*lostdemcost(j)+lostsales;
    end
end   
       