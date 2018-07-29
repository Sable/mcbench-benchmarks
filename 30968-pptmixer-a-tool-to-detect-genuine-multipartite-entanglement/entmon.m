function [N]=entmon(rho, dimensions)
%returns the entanglement monotone defined in B. Jungnitsch, 
%T. Moroder and O. Gühne, Phys. Rev. Lett. 106, 190502 (2011) 
%(or http://arxiv.org/abs/1010.6049) for the given state rho. 
%'dimensions' is optional and is a vector that denotes the 
%dimensions of the systems. if not given, 
%systems are treated as qubits. the optional argument 'solver' must 
%be a the name of the solver to be used (given as a string). 
%If left out, the solver 'sedumi' is used.
%note that rho must be given in the basis, in which the partial
%transposition is performed, i.e. in a product basis

%****** error handling *****

%throw an error if rho is not a square matrix
opdims=size(rho);
if (opdims(1) ~= opdims(2))
    error('first argument is no square matrix');
end

%throw an error if rho is not hermitian (within a certain precision)
if (max(max(abs(ctranspose(rho)-rho))) > 1e-12)
    error('first argument is not hermitian');
end

%if dimensions are not specified, assume qubits
if (nargin==1)
    dimensions=2*ones(1,log2(opdims(1)));
end

%throw an error if any value in 'dimensions' is smaller than two
if (min(dimensions)<2)
    error('dimensions must be larger than 1');
end

%throw an error if the given dimensions do not match rho
if (opdims(1) ~= prod(dimensions))
    error('dimensions do not agree with form of rho');
end

%***************************

%obtain number of systems
dims=size(dimensions);
n=dims(2);

%set the witness, i.e. the sdp variable, over which will be minimized
W=sdpvar(opdims(1),opdims(2),'hermitian','complex');

%now, set constraints: decomposability w.r.t. all inequivalent
%bipartitions

for m=1:2^(n-1)-1 %loop through all inequivalent bipartitions.
                  %note that partitions M|complement(M) and
                  %complement(M)|M are equivalent and that neither M
                  %nor its complement can be empty

    %m represents the bipartition. for later use, rewrite it as  binary
    %vector. E.g., in a four-particle system m=5, which is the bitstring
    %0101 in binary representation, denotes the bipartition given by
    %M={2,4} (and complement(M)={1,3}). we would like to write it as
    %binary vector, namely Mvec=[0 1 0 1].

    %convert m to bitstring
    binstr=dec2bin(m,n);

    %convert the bitstring to binary vector Mvec
    Mvec=[];

    for l=1:n
        Mvec=cat(2,Mvec, str2num(binstr(l)));
    end

    %another sdp variable over which will be minimized is the operator
    %P ...
    P{m}=sdpvar(opdims(1),opdims(2),'hermitian','complex'); 

    %... whose positive semidefiniteness is one constraint
    if (m==1)
        constr=set(P{m}>=0,strcat('Positive semidefiniteness of P_M where M={', num2str(find(Mvec)),'}'));
    else
        constr=constr+set(P{m}>=0,strcat('Positive semidefiniteness of P_M where M={', num2str(find(Mvec)),'}'));
    end

    %also, the operator Q, which equals (W-P)^(T_M), should be positive
    %semidefinite. for the partial transposition T_M, use the function pt()
    constr=constr+set(pt(W-P{m},Mvec,dimensions)>=0,strcat('Positive semidefiniteness of Q=(W-P_M)^(T_M) w.r.t. M={', num2str(find(Mvec)),'}'));

    %finally, set the constraints P_M <= 1 and Q_M <= 1
    constr=constr+set(eye(opdims(1), opdims(2)) - P{m}>=0,strcat('P_M <= 1 where M={', num2str(find(Mvec)),'}'));
    constr=constr+set(eye(opdims(1), opdims(2)) - pt(W-P{m},Mvec,dimensions)>=0,strcat('Q_M <= 1 where M={', num2str(find(Mvec)),'}'));

end

%perform minimization of the expectation value of W w.r.t. rho using
%the specified solver and the given constraints constr
result=solvesdp(constr,trace(rho*W),sdpsettings('verbose',0));

%check for errors
if (result.problem ~= 0)
	disp(result.info);
end

%return the negative minimum
N=-double(trace(rho*W));