function [minval, witness]=fdecwit(rho, dimensions)
%returns the minimal expectation value of rho with respect to all fully
%decomposable witnesses and also the corresponding fully decomposable 
%witness for which this minimum is obtained. returns a zero matrix for 
%the witness if rho is biseparable or cannot be detected. Can be used 
%with one output, i.e. only the minimum, or two outputs. 'dimensions' 
%is optional and is a vector that denotes the dimensions of the systems.
%if not given, systems are treated as qubits. 
%note that rho must be given in the basis, in which the partial
%transposition is performed, i.e. in a product basis

%****** error handling *****

%throw an error if rho is not square matrix
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

%when testing whether the minimum is negative, what does 'negative'
%mean, i.e. what is the numerical precision ?
precision = 1e-12;

%obtain number of systems
dims=size(dimensions);
n=dims(2);

%set the witness, i.e. the sdp variable, over which will be minimized
W=sdpvar(opdims(1),opdims(2),'hermitian','complex');

%now, set constraints

%first constraint: trace normalization of W
constr=set(trace(W)==1,'unit trace');

%other constraints: decomposability w.r.t. all inequivalent
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

    %... whose positive semidefiniteness is another constraint 
    constr=constr+set(P{m}>=0,strcat('Positive semidefiniteness of P_M where M={', num2str(find(Mvec)),'}'));

    %also, the operator Q, which equals (W-P)^(T_M), should be positive
    %semidefinite. for the partial transposition T_M, use the function pt()
    constr=constr+set(pt(W-P{m},Mvec,dimensions)>=0,strcat('Positive semidefiniteness of Q=(W-P_M)^(T_M) w.r.t. M={', num2str(find(Mvec)),'}'));

end

%perform minimization of the expectation value of W w.r.t. rho using
%the specified solver and the given constraints constr
result=solvesdp(constr,trace(rho*W),sdpsettings('verbose',0));

%check for errors
if (result.problem ~= 0)
	disp(result.info);
end

%prepare output
if (double(trace(rho*W)) < -precision) %if the minimum is negative, ...
    return_value = double(W); %...return the corresponding witness
else %if the minimum is not negative, ...
    return_value=zeros(opdims(1),opdims(2)); %return a zero matrix
end

%return outputs
if (nargout == 2)
    witness=return_value;
end

minval = double(trace(rho*W));