clear
    % Generarea unei celule goale de dimensiunea 2x2
Q=cell(2,2)
    % Incarcarea celulei
Q={ones(3), [1 3 6 7 6]; ['TN ';'SL ';'DMI';'NDD'], logical(eye(3))};
    % Afisarea informatiilor aferente celulei
whos Q
    % Afisarea continutului inregei celule i a unui element a acesteia
disp('Afisarea intregei celule:')
disp(Q)
disp('Afisarea unui elelement din celula:')
disp(Q{2,1})