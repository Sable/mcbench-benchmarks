
disp('Test: Mutual information between two images')
load mri 
A=D(:,:,8); 
B=D(:,:,9);
mi(A,A),mi(A,B)

disp('Test: Mutual information between two signals')
load garchdata
nasdaq = price2ret(NASDAQ);
nyse = price2ret(NYSE);
mi(nasdaq,nasdaq), mi(nasdaq,nyse)
