clear all
        % Pornirea cronometrului
t0=cputime;
        % Prealocarea vectorului a
a=zeros(100,1);
        % Executarea ciclului repetitiv
for n=1:100
    a(n)=det(magic(100));
end
		% Determinarea duratei de executare a programului
durata=cputime-t0

