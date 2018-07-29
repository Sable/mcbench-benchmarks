%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: get_delay_vector
%
% Author: Stephen Faul
% Date: 4th Novemeber 2004
%
% Description: inputs: data - data vector
%                      embed_dimen - the embedding dimension
%                      delta - the time lag
%
%              outputs: Y - the delay vector (matrix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y=get_delay_vector(data,embed_dimen,delta)
data_size=size(data);
if data_size(1)<data_size(2)
    data=data';
end

M=length(data);
top_right=1+(embed_dimen-1)*delta;
length_delay_vec=M-top_right+1;

Y=zeros(length_delay_vec,embed_dimen);

for i=1:embed_dimen
    first=1+delta*(i-1);
	last=first+length_delay_vec-1;
	Y(:,i)=data(first:last);
end