function ms=flood_fill(I,r,tol)
% flood fill, scan line algoritm
% ms=flood_fill(I,r,tol)
%  ms - pixels numbers that flooded
% numbering: number=y+szy*(x-1), x y - pixels coordinaties
% szx szy - image size
% I - RGB image
% r- first point of selection
% tol - tolerance


R=int32(I(:,:,1));
G=int32(I(:,:,2));
B=int32(I(:,:,3));

[szy szx]=size(R); % image size

% stek, where seed will be stored:
stm=10000;
st=zeros(stm,2,'int32');
st(1,1)=r(1);
st(1,2)=r(2); % r - is start seed
stL=1; % stack length

% hp=plot(1,1,'.k');
% 
% set(hp,'XData',st(1:stL,1),'YData',st(1:stL,2));
% drawnow;


% found pixel store:
ms0m=1e6; % margin
ms0=zeros(ms0m,1,'int32'); % predifined array to increase speed
ms0L=0; % 0 points initially

% initial point color:
R0=R(r(2),r(1));
G0=G(r(2),r(1));
B0=B(r(2),r(1));

% to pixel number
tn=@(xx,yy) yy+szy*(xx-1);


while true;
    % get seed from stack:
    xt=st(stL,1);
    yt=st(stL,2);
    stL=stL-1;
    
    % line:
    % to right
    sku=false; % seed key, true if seed added, up
    skd=false; % same for down
    sku1=false; % this key is need to prewnt extra seed when move to left, up
    skd1=false; % same for left
    for xtt=xt:szx
        
        if max(abs([(R(yt,xtt)-R0), (G(yt,xtt)-G0), (B(yt,xtt)-B0)]))<=tol
            % add pixel
            ms0L=ms0L+1;
            ms0(ms0L)=tn(xtt,yt);
        else
            break;
        end
        
        % try to add seed up:
        if yt~=szy
            if max(abs([(R(yt+1,xtt)-R0), (G(yt+1,xtt)-G0), (B(yt+1,xtt)-B0)]))<=tol
                if ~sku
                    if all(tn(xtt,yt+1)~=ms0(1:ms0L)) % if free space
                        % add to stack
                        stL=stL+1;
                        st(stL,1)=xtt;
                        st(stL,2)=yt+1;
                        sku=true;
                    end
                end
            else
                sku=false;
            end
            if xtt==xt
                sku1=sku; % memorize, will be used when to left
            end
        end
        
        % try to add down
        if yt~=1
            if max(abs([(R(yt-1,xtt)-R0), (G(yt-1,xtt)-G0), (B(yt-1,xtt)-B0)]))<=tol
                if ~skd
                    if all(tn(xtt,yt-1)~=ms0(1:ms0L)) % if free space
                        % add to stack
                        stL=stL+1;
                        st(stL,1)=xtt;
                        st(stL,2)=yt-1;
                        skd=true;
                    end
                end
            else
                skd=false;
            end
            if xtt==xt
                skd1=skd; % memorize, will be used when to left
            end
        end
    end
    
    % to left
    %sku=false; % seed key, true if seed added
    %skd=false;
    sku=sku1;
    skd=skd1;
    if xt~=1
        for xtt=(xt-1):-1:1 

            if max(abs([(R(yt,xtt)-R0), (G(yt,xtt)-G0), (B(yt,xtt)-B0)]))<=tol
                % add pixel
                ms0L=ms0L+1;
                ms0(ms0L)=tn(xtt,yt);
            else
                break;
            end

            % try to add seed up:
            if yt~=szy
                if max(abs([(R(yt+1,xtt)-R0), (G(yt+1,xtt)-G0), (B(yt+1,xtt)-B0)]))<=tol
                    if ~sku
                        if all(tn(xtt,yt+1)~=ms0(1:ms0L)) % if free space
                            % add to stack
                            stL=stL+1;
                            st(stL,1)=xtt;
                            st(stL,2)=yt+1;
                            sku=true;
                        end
                    end
                else
                    sku=false;
                end
            end

            % try to add down
            if yt~=1
                if max(abs([(R(yt-1,xtt)-R0), (G(yt-1,xtt)-G0), (B(yt-1,xtt)-B0)]))<=tol
                    if ~skd
                        if all(tn(xtt,yt-1)~=ms0(1:ms0L)) % if free space
                            % add to stack
                            stL=stL+1;
                            st(stL,1)=xtt;
                            st(stL,2)=yt-1;
                            skd=true;
                        end
                    end
                else
                    skd=false;
                end
            end
        end
    end
    
%     set(hp,'XData',st(1:stL,1),'YData',st(1:stL,2));
%     drawnow;
%     pause(1);
    
    if stL==0 % no more seed
        break; % stop
    end
    
    
end

ms=ms0(1:ms0L);
