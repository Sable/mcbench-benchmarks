function [istouchall,istouch]=approachwall(segset,rpos,r)
n=size(segset,1);
istouch=true(1,n);
istouchall=false;
% %debug%
% hold on
% axis([0 12.5 0 10])
for k=1:n
    if segset(k,2)~=segset(k,4)
%         %debug
%         plot(segset(k,[1,3]),segset(k,[2,4]))
%         plot(rpos(1),rpos(2),'ro');
        %Method 1:
        A=1;
        B=-(segset(k,1)-segset(k,3))/(segset(k,2)-segset(k,4));
        C=(segset(k,1)-segset(k,3))/(segset(k,2)-segset(k,4))*segset(k,2)-segset(k,1);
        d=abs((A*rpos(1)+B*rpos(2)+C)/sqrt(A^2+B^2));
%         %Method 2:
%         intx=(rpos(1)*(segset(k,1)-segset(k,3))^2+(segset(k,3)*...
%             (-rpos(2)+segset(k,2))+segset(k,1)*(rpos(2)-segset(k,4)))*...
%             (segset(k,2)-segset(k,4)))/(segset(k,1)^2-2*segset(k,1)*...
%             segset(k,3)+segset(k,3)^2+(segset(k,2)-segset(k,4))^2);
%         inty=(segset(k,3)^2*segset(k,2)+rpos(2)*segset(k,2)^2+rpos(1)*...
%             (segset(k,1)-segset(k,3))*(segset(k,2)-segset(k,4))+...
%             segset(k,1)^2*segset(k,4)-2*rpos(2)*segset(k,2)*segset(k,4)+...
%             rpos(2)*segset(k,4)^2-segset(k,1)*segset(k,3)*(segset(k,2)+...
%             segset(k,4)))/(segset(k,1)^2-2*segset(k,1)*segset(k,3)+...
%             segset(k,3)^2+(segset(k,2)-segset(k,4))^2);
%         d=sqrt((rpos(1)-intx)^2+(rpos(2)-inty)^2);
        inarea=(rpos(2)-segset(k,2)+(segset(k,1)-segset(k,3))/...
            (segset(k,2)-segset(k,4))*(rpos(1)-segset(k,1)))*...
            (rpos(2)-segset(k,4)+(segset(k,1)-segset(k,3))/...
            (segset(k,2)-segset(k,4))*(rpos(1)-segset(k,3)))<0;
    else
        d=abs(rpos(2)-segset(k,2));
        inarea=(rpos(1)-segset(k,1))*(rpos(1)-segset(k,3))<0;
    end
    if (inarea&&d>=r)||(~inarea&&(sqrt((rpos(1)-segset(k,1))^2+...
            (rpos(2)-segset(k,2))^2)>=r&&sqrt((rpos(1)-...
            segset(k,3))^2+(rpos(2)-segset(k,4))^2)>=r))
        istouch(k)=false;
    else
        istouchall=true;
    end
end

