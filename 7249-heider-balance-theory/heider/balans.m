function derajat_balans = balans(matriks)

% Function to calculate the balance degree based on Heiderian balance
% input: NxN adjacency matrix
% output: degree of balance matrix
% Hokky Situngkir
% May 9th 2004


N = length(matriks);
matrik = 1:1:N;
triad = combntns(matrik,3);
panjang = length(triad);
pengukur=zeros(1,3);
balans = zeros(1,panjang);
total_balans = 0;

for i=1:1:panjang
    pengukur(1) = matriks(triad(i,1),triad(i,2));
    pengukur(2) = matriks(triad(i,1),triad(i,3));
    pengukur(3) = matriks(triad(i,2),triad(i,3));
    balans(i) = pengukur(1) * pengukur(2) * pengukur(3);
    if balans(i)==1
        total_balans=total_balans+1;
    end
end

derajat_balans=total_balans/panjang;
