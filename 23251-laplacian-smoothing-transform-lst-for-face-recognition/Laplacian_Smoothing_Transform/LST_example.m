% Run this sample will cost you less than 5 minutes

% By Suicheng Gu at Peking University, Jan. 5, 2009
% Email: gusuch@gmail.com

fprintf('**** An example of LST ****\n');
fprintf('--> Loading data...\n');

load('yale_200x160.mat'); k = 79; M=200; N=160;
F = zeros(165,M*N);
for i = 1:165;
    f = double(im1(:,:,i));
    F(i,:) = f(:); 
    F(i,:) = F(i,:)/sqrt(F(i,:)*F(i,:)');
end;

fprintf('--> Computing LST Basis...\n');
gammak = lst_basis(M,N,k);
G = F * gammak;

fprintf('--> Error rates on Yale database:\n');
fprintf('(Leave-one-out strategy, NN classifier)\n');

err1 = oneoutnn(G(:,5:50),yalel); %err1 = 13
fprintf('Dimension reduction by LST: ');
fprintf('%4.2f',err1/1.65);fprintf('%%\n');

err2 = oneoutfldnn(G,yalel,14);   %err2 = 0
fprintf('Dimension reduction by LST + LDA(FLD): ');
fprintf('%4.2f',err2/1.65);fprintf('%%\n');