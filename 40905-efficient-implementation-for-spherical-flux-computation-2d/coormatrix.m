%  varargout=coorMatrix(dimension)
% The dimension is a vector to specify the size of the returned coordinate
% matrices. The number of output argument is equals to the dimensionality
% of the vector "dimension". All the dimension is starting from "1"
function varargout=coormatrix(dimension);
dim=length(dimension);
if dim==2
    varargout{1}=[1:dimension(1)]' * ones(1 , dimension(2), 'single');
    varargout{2}=ones(dimension(1) , 1, 'single') * [1:dimension(2)];
else
    for i=1:dim
        a=single(1:dimension(i));
        reshapepara=ones(1,dim, 'single');
        reshapepara(i)=dimension(i);
        A=reshape(a, reshapepara);
        repmatpara=dimension;
        repmatpara(i)=1;
        varargout{i}=repmat(A, repmatpara);
    end
end
