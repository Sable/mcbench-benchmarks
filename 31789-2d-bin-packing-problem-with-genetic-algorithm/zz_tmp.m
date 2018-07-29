fitness=0;
                ispen=false; % true if penality
                
                % check cross with main box:
                % add boxes arreas and strong subtract out areas:
                for n=1:L % for each box
                    ind1=ind(n);
                    aaa=aa(ind1);
                    bbb=bb(ind1);
                    if rot(n)
                        tmp=aaa;
                        aaa=bbb;
                        bbb=tmp;
                    end
                    A0=AA(ind1); % box area
                    x1=max([x-aaa/2  0]);
                    y1=max([y-bbb/2  0]);
                    x2=min([x+aaa/2  a]);
                    y2=min([y+bbb/2  b]);
                    % x1 - x2,  y1 - y2 is box (part of current box) that inside main box
                    if (x1>=x2)||(y1>=y2)
                        A=0; % box that inside main box area
                    else
                        A=(x2-x1)*(y2-y1); % box that inside main box area
                    end
                    if A<A0 % if not fully inside main box
                        fitness=fitness + A-nac*(A0-A);
                        ispen=true; % penality
                    else
                        fitness=fitness + A;
                    end
                end
                
                % for each pair of boxes:
                for n1=1:L-1
                    ind1=ind(n1);
                    aaa1=aa(ind1);
                    bbb1=bb(ind1);
                    if rot(n1)
                        tmp=aaa1;
                        aaa1=bbb1;
                        bbb1=tmp;
                    end
                    A1=AA(ind1);
                    x1=x(n1);
                    y1=y(n1); % position of 1st box of pair
                    for n2=n1+1:L
                        ind2=ind(n2);
                        aaa2=aa(ind2);
                        bbb2=bb(ind2);
                        if rot(n2)
                            tmp=aaa2;
                            aaa2=bbb2;
                            bbb2=tmp;
                        end
                        A2=AA(ind2);
                        x2=x(n2);
                        y2=y(n2); % position of 2nd box of pair
                        dx=abs(x1-x2);
                        dy=abs(y1-y2); % distancies
                        a12=(aaa1/2+aaa2/2);
                        b12=(bbb1/2+bbb2/2);
                        if (dx<a12)&&(dy<b12) % if cross
                            ispen=true;
                            Ac=(a12-dx)*(b12-dy); % area of cross
                            fitness=fitness-Ac-Ac; % becuse area of n1 and n2 was added fully
                            fitness=fitness-2*nac*Ac;
                        end

                    end
                end
                
                if ispen
                    fitness=fitness-penalty;
                end