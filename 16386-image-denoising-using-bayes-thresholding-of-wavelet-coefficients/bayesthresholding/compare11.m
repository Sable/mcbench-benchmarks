function rmse=compare11(f1,f2,scale)
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%
error(nargchk(2,3,nargin));
if nargin<3
    scale=1;

end
%%%%%%%%%%%%%%%%
%compute the root mean square error
e=double(f1)-double(f2);
[m,n]=size(e);
rmse=sqrt(sum(e(:).^2)/(m*n));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rmse
    %%%%%%%%%%%%%%%%%
    emax=max(abs(e(:)));
    [h,x]=hist(e(:),emax);
    if length(h)>=1
        %figure,bar(x,h,'k');
        %%%%%%%%%%%%%%%%%%%
        emax=emax/scale;
        e=mat2gray(e,[-emax, emax]);
        %figure;imshow(e);
    end
end