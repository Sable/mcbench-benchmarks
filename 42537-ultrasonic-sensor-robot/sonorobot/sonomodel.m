function [modelpt,mptadd,finished,mdl]=sonomodel(rs,r)
%Modeling
%A     : Faultages on two sides
%A1(01): j--->i, i--->k/k==nil
%A2(02): j--->i, i<---k
%A3(03): j<---i, i--->k/k==nil
%B     : Faultage on one side
%B1(04): j--->i, i<--k/i<-k, k<--m
%B2(05): j--->i, i<--k/i<-k, k~<--m
%B3(06): j--->i, i->k
%B4(07): l-->j, j-->i/j->i, i--->k/k==nil
%B5(08): l~-->j, j-->i/j->i, i--->k/k==nil
%B6(09): j<-i, i--->k/k==nil
%C     : Wall
%C (10): l~<-j/l~<--j, j-->i/j->i, i-->k/i->k
%D     : Outer corner
%D1(11): l<-j/l<--j, j<--i/j<-i, i-->k/i->k, k-->m/k->m
%D2(12): l~<-j/l~<--j, j<--i/j<-i, i-->k/i->k, k~-->m/k~->m
%D3(13): n<-l/n<--l, l<-j/l<--j, j->i/j-->i, i-->k/i->k
%D4(14): n~<-l/n~<--l, l<-j/l<--j, j->i/j-->i, i-->k/i->k
%E     : Inner corner
%E (15): j-->i/j->i, i<-k
%16    : for nil
%17    : for unknown
if nargin<2
    r=.56;
end
rx=0;ry=0;
ns=length(rs);
a=2*pi/ns;%angle between two adjacent sensors
finished=false(1,ns);%when finished, 'false' stands for unknown
modelpt=zeros(ns,4);%2 points for each sensor (sometimes 3, error avoided)
mptadd=[];
mdl=16*ones(1,ns);%!!
for k=1:ns
    if finished(k)%!!
        continue
    end
    unknown=false;
    if rs(k)>r/2
    dsi=rs(k);
    dsj=rs(mod(k,ns)+1);
    dsk=rs(mod(k-2,ns)+1);
    dsl=rs(mod(k+1,ns)+1);
    dsm=rs(mod(k-3,ns)+1);
    dsn=rs(mod(k+2,ns)+1);
    dso=rs(mod(k-4,ns)+1);
    idxi=k;
    idxj=mod(k,ns)+1;
    idxk=mod(k-2,ns)+1;
    idxl=mod(k+1,ns)+1;
    idxm=mod(k-3,ns)+1;
    idxn=mod(k+2,ns)+1;
    idxo=mod(k-4,ns)+1;
    xchng=false;
    if dsj<dsk%adjust index, dsj>dsk
        idxj=idxk;
        idxk=mod(k,ns)+1;
        idxl=idxm;
        idxm=mod(k+1,ns)+1;
        idxn=idxo;
        idxo=mod(k+2,ns)+1;
        dsj=dsk;
        dsk=rs(mod(k,ns)+1);
        dsl=dsm;
        dsm=rs(mod(k+1,ns)+1);
        dsn=dso;
        %dso=rs(mod(k+2,ns)+1);
        xchng=true;
    end
    if dsi>=dsk%i>k/j, %A1,3, B3,4,5,6, C, D1,2,3,4
        if dsi>=dsj%i>j/k, %A3, B6, D1,2
            if (dsi-dsk)>2*r%||dsk==inf; %i--->k/j||k/j==nil, %A3, B6
                if (dsi-dsj)>2*r%i--->j/k||j/k==nil
                    %A3
                    %mdlrecg='A3';
                    mdl(k)=3;
                    %finished(k)=true;
                    modelpt(k,1:2)=[rx+rs(k)*cos((k-3/4)*a),ry+rs(k)*sin((k-3/4)*a)];
                    modelpt(k,3:4)=[rx+rs(k)*cos((k-1/4)*a),ry+rs(k)*sin((k-1/4)*a)];
                elseif (dsi-dsj)>=0&&dsj<=dsi/cos(a)%i->j
                    %B6
                    %mdlrecg='B6';
                    mdl(k)=9;
                    %finished(k)=true;
                    if ~xchng
                        modelpt(k,1:2)=[rx+rs(k)*cos(k*a),ry+rs(k)*sin(k*a)];
                        modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(idxk*a),ry+rs(idxi)/cos(a)*sin(idxk*a)];
                    else
                        modelpt(k,1:2)=[rx+rs(k)*cos(idxj*a),ry+rs(k)*sin(idxj*a)];
                        modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(k*a),ry+rs(idxi)/cos(a)*sin(k*a)];
                    end
%                     if ~xchng
%                         modelpt(k,1:2)=[rx+rs(k)*cos(k*a),ry+rs(k)*sin(k*a)];
%                         modelpt(k,3:4)=[rx+rs(idxj)/cos(2*a)*cos(idxk*a),ry+rs(idxj)/cos(2*a)*sin(idxk*a)];
%                     else
%                         modelpt(k,1:2)=[rx+rs(k)*cos(idxj*a),ry+rs(k)*sin(idxj*a)];
%                         modelpt(k,3:4)=[rx+rs(idxj)/cos(2*a)*cos(k*a),ry+rs(idxj)/cos(2*a)*sin(k*a)];
%                     end
                else%?
                    unknown=true;
                    mdl(k)=17;
                end
            elseif (dsi-dsj)<2*r&&(dsi-dsk)<2*r%<--/-i--/->, %D1,2
                finished([idxj,idxk])=true;
                modelpt(k,:)=nan;
                if (dsj-dsl)<2*r&&(dsk-dsm)<2*r%l<-/--j && k--/->m
                    %finished(k)=true;
                    %D1 %!!! ->link!
                    %mdlrecg='D1';
                    mdl(k)=11;
                    if ~xchng
                        pt1=[rx+rs(idxl)*cos(idxl*a),ry+rs(idxl)*sin(idxl*a)];
                        pt2=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                        pt3=[rx+rs(idxm)*cos(idxo*a),ry+rs(idxm)*sin(idxo*a)];
                        pt4=[rx+rs(idxk)*cos(idxm*a),ry+rs(idxk)*sin(idxm*a)];
                    else
                        pt1=[rx+rs(idxl)*cos(idxn*a),ry+rs(idxl)*sin(idxn*a)];
                        pt2=[rx+rs(idxj)*cos(idxl*a),ry+rs(idxj)*sin(idxl*a)];
                        pt3=[rx+rs(idxm)*cos(idxm*a),ry+rs(idxm)*sin(idxm*a)];
                        pt4=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                    end
%                     if dsj<dsi/cos(a)&&dsk<dsi/cos(a)%&&(dsj>dsl/cos(a)&&dsk<dsm/cos(a))%D1_2
%                         %mdlrecg='D1_2';
%                         if ~xchng
%                             pt1=[rx+rs(idxl)*cos(idxl*a),ry+rs(idxl)*sin(idxl*a)];
%                             pt2=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
%                             pt3=[rx+rs(idxm)/cos(a)*cos(idxm*a),ry+rs(idxm)/cos(a)*sin(idxm*a)];
%                             pt4=[rx+rs(idxk)/cos(2*a)*cos(idxk*a),ry+rs(idxk)/cos(2*a)*sin(idxk*a)];
%                         else
%                             pt1=[rx+rs(idxl)*cos(idxn*a),ry+rs(idxl)*sin(idxn*a)];
%                             pt2=[rx+rs(idxj)*cos(idxl*a),ry+rs(idxj)*sin(idxl*a)];
%                             pt3=[rx+rs(idxm)/cos(a)*cos(idxk*a),ry+rs(idxm)/cos(a)*sin(idxk*a)];
%                             pt4=[rx+rs(idxk)/cos(2*a)*cos(idxi*a),ry+rs(idxk)/cos(2*a)*sin(idxi*a)];
%                         end
%                     else%D1_1
%                         %mdlrecg='D1_1';
%                         if ~xchng
%                             pt1=[rx+rs(idxm)*cos(idxo*a),ry+rs(idxm)*sin(idxo*a)];
%                             pt2=[rx+rs(idxk)*cos(idxm*a),ry+rs(idxk)*sin(idxm*a)];
%                             pt3=[rx+rs(idxl)/cos(a)*cos(idxj*a),ry+rs(idxl)/cos(a)*sin(idxj*a)];
%                             pt4=[rx+rs(idxl)/cos(2*a)*cos(idxi*a),ry+rs(idxl)/cos(2*a)*sin(idxi*a)];
%                         else
%                             pt1=[rx+rs(idxm)*cos(idxm*a),ry+rs(idxm)*sin(idxm*a)];
%                             pt2=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
%                             pt3=[rx+rs(idxl)/cos(a)*cos(idxl*a),ry+rs(idxl)/cos(a)*sin(idxl*a)];
%                             pt4=[rx+rs(idxl)/cos(2*a)*cos(idxj*a),ry+rs(idxl)/cos(2*a)*sin(idxj*a)];
%                         end
%                     end
                    intpt=[-((-(pt3(1)-pt4(1))*(pt2(1)*pt1(2)-pt1(1)*pt2(2))+(pt1(1)-pt2(1))*(pt4(1)*pt3(2)-pt3(1)*pt4(2)))/((pt3(1)-pt4(1))*(pt1(2)-pt2(2))+(pt1(1)-pt2(1))*(-pt3(2)+pt4(2)))),...
                        (pt4(1)*(pt1(2)-pt2(2))*pt3(2)+pt1(1)*pt2(2)*pt3(2)-pt3(1)*pt1(2)*pt4(2)-pt1(1)*pt2(2)*pt4(2)+pt3(1)*pt2(2)*pt4(2)+pt2(1)*pt1(2)*(-pt3(2)+pt4(2)))/(pt4(1)*(pt1(2)-pt2(2))+pt3(1)*(-pt1(2)+pt2(2))+(pt1(1)-pt2(1))*(pt3(2)-pt4(2)))];
                    modelpt([idxj,idxk],:)=[pt2,intpt;pt4,intpt];%!!!
                else
                    %D2
                    mdl(k)=12;
                    %finished(k)=true;
                    if dsj>dsi/cos(a)&&dsk>dsi/cos(a)%D2_1, link
                        %mdlrecg='D2_1';
                        if ~xchng
                            pt1=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                            pt2=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                            pt3=[rx+rs(idxk)*cos(idxm*a),ry+rs(idxk)*sin(idxm*a)];
                            pt4=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                        else
                            pt1=[rx+rs(idxj)*cos(idxl*a),ry+rs(idxj)*sin(idxl*a)];
                            pt2=[rx+rs(idxi)*cos(idxj*a),ry+rs(idxi)*sin(idxj*a)];
                            pt3=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                            pt4=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                        end
                    else%D2_2
                        %mdlrecg='D2_2';
                        if ~xchng
                            pt1=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                            pt2=[rx+rs(idxj)/cos(a)*cos(idxi*a),ry+rs(idxj)/cos(a)*sin(idxi*a)];
                            pt3=[rx+rs(idxk)*cos(idxm*a),ry+rs(idxk)*sin(idxm*a)];
                            pt4=[rx+rs(idxk)/cos(a)*cos(idxk*a),ry+rs(idxk)/cos(a)*sin(idxk*a)];
                        else
                            pt1=[rx+rs(idxj)*cos(idxl*a),ry+rs(idxj)*sin(idxl*a)];
                            pt2=[rx+rs(idxj)/cos(a)*cos(idxj*a),ry+rs(idxj)/cos(a)*sin(idxj*a)];
                            pt3=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                            pt4=[rx+rs(idxk)/cos(a)*cos(idxi*a),ry+rs(idxk)/cos(a)*sin(idxi*a)];
                        end
                    end
                    intpt=[-((-(pt3(1)-pt4(1))*(pt2(1)*pt1(2)-pt1(1)*pt2(2))+(pt1(1)-pt2(1))*(pt4(1)*pt3(2)-pt3(1)*pt4(2)))/((pt3(1)-pt4(1))*(pt1(2)-pt2(2))+(pt1(1)-pt2(1))*(-pt3(2)+pt4(2)))),...
                        (pt4(1)*(pt1(2)-pt2(2))*pt3(2)+pt1(1)*pt2(2)*pt3(2)-pt3(1)*pt1(2)*pt4(2)-pt1(1)*pt2(2)*pt4(2)+pt3(1)*pt2(2)*pt4(2)+pt2(1)*pt1(2)*(-pt3(2)+pt4(2)))/(pt4(1)*(pt1(2)-pt2(2))+pt3(1)*(-pt1(2)+pt2(2))+(pt1(1)-pt2(1))*(pt3(2)-pt4(2)))];
                    modelpt([idxj,idxk],:)=[pt1,intpt;pt3,intpt];
                end
            else%?
                unknown=true;
                mdl(k)=17;
            end
        else%A1, B3,4,5, C, D3,4
            if dsi-dsk>2*r%||dsk==inf %i--->k/j||k/j==nil, %A1,B4,5
                if dsj-dsi>2*r%j/k--->i
                    %A1
                    %mdlrecg='A1';
                    mdl(k)=1;
                    %finished(k)=true;
                    modelpt(k,1:2)=[rx+rs(k)*cos((k-3/4)*a),ry+rs(k)*sin((k-3/4)*a)];
                    modelpt(k,3:4)=[rx+rs(k)*cos((k-1/4)*a),ry+rs(k)*sin((k-1/4)*a)];
                elseif dsj-dsi<2*r%j/k--/->i %B4,5? THE SAME!
                    if (dsl>dsj)&&(dsl-dsj<2*r)%l-->j
                        %B4
                        mdl(k)=7;
                        %finished(k)=true;
                        if dsj<dsi/cos(a)%B4_2
                            %mdlrecg='B4_2';
                            if ~xchng
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                                modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(idxi*a),ry+rs(idxi)/cos(a)*sin(idxi*a)];
                            else
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                                modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(idxj*a),ry+rs(idxi)/cos(a)*sin(idxj*a)];
                            end
                        else%B4_1
                            %mdlrecg='B4_1';
                            if ~xchng
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                                modelpt(k,3:4)=[rx+rs(idxj)*cos(idxi*a),ry+rs(idxj)*sin(idxi*a)];
                            else
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                                modelpt(k,3:4)=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                            end
                        end
                    else
                        %B5
                        mdl(k)=8;
                        %finished(k)=true;
                        if dsj<dsi/cos(a)%B5_2
                            %mdlrecg='B5_2';
                            if ~xchng
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                                modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(idxi*a),ry+rs(idxi)/cos(a)*sin(idxi*a)];
                            else
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                                modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(idxj*a),ry+rs(idxi)/cos(a)*sin(idxj*a)];
                            end
                        else%B5_1
                            %mdlrecg='B5_1';
                            if ~xchng
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                                modelpt(k,3:4)=[rx+rs(idxj)*cos(idxi*a),ry+rs(idxj)*sin(idxi*a)];
                            else
                                modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                                modelpt(k,3:4)=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                            end
                        end
                    end
                else%?
                    unknown=true;
                    mdl(k)=17;
                end
            elseif dsi-dsk<2*r%i--/->k, %B3, C, D3,4 %?
                if dsj-dsi>2*r%j--->i
                    %B3 %!!! ->link!
                    %mdlrecg='B3';
                    mdl(k)=6;
                    %finished(k)=true;
%                     if ~xchng
%                         modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
%                         modelpt(k,3:4)=[rx+rs(idxk)/cos(2*a)*cos(idxi*a),ry+rs(idxk)/cos(2*a)*sin(idxi*a)];
%                     else
%                         modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
%                         modelpt(k,3:4)=[rx+rs(idxk)/cos(2*a)*cos(idxj*a),ry+rs(idxk)/cos(2*a)*sin(idxj*a)];
%                     end
                    if ~xchng
                        modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                        modelpt(k,3:4)=[rx+rs(idxj)*cos(idxi*a),ry+rs(idxj)*sin(idxi*a)];
                    else
                        modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                        modelpt(k,3:4)=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                    end
                elseif dsj-dsi<2*r%j--/->i, %C, D3,4
                    if (dsj>dsl)&&(dsj<dsl/cos(a))%j--/->l, %D3,4 %!!!
                        modelpt(k,:)=nan;
                        if (dsl>dsn)&&(dsl-dsn<2*r)%n<-/--l
                            %D3
                            mdl(k)=13;
                            %finished(k)=true;
                            finished([idxj,idxk])=true;
                            if dsl<dsn/cos(a)%dsj<dsi/cos(a) %!!!
                                %D3_1
                                %!!! ->t: n/k; l: k/n
                                %mdlrecg='D3_1';
                                if ~xchng
                                    pt1=[rx+rs(idxl)*cos(idxl*a),ry+rs(idxl)*sin(idxl*a)];
                                    pt2=[rx+rs(idxn)/cos(2*a)*cos(idxj*a),ry+rs(idxn)/cos(2*a)*sin(idxj*a)];
                                    pt3=[rx+rs(idxk)*cos(idxm*a),ry+rs(idxk)*sin(idxm*a)];
                                    pt4=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                                else
                                    pt1=[rx+rs(idxl)*cos(idxn*a),ry+rs(idxl)*sin(idxn*a)];
                                    pt2=[rx+rs(idxn)/cos(2*a)*cos(idxl*a),ry+rs(idxn)/cos(2*a)*sin(idxl*a)];
                                    pt3=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                                    pt4=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                                end
                                intpt=[-((-(pt3(1)-pt4(1))*(pt2(1)*pt1(2)-pt1(1)*pt2(2))+(pt1(1)-pt2(1))*(pt4(1)*pt3(2)-pt3(1)*pt4(2)))/((pt3(1)-pt4(1))*(pt1(2)-pt2(2))+(pt1(1)-pt2(1))*(-pt3(2)+pt4(2)))),...
                                    (pt4(1)*(pt1(2)-pt2(2))*pt3(2)+pt1(1)*pt2(2)*pt3(2)-pt3(1)*pt1(2)*pt4(2)-pt1(1)*pt2(2)*pt4(2)+pt3(1)*pt2(2)*pt4(2)+pt2(1)*pt1(2)*(-pt3(2)+pt4(2)))/(pt4(1)*(pt1(2)-pt2(2))+pt3(1)*(-pt1(2)+pt2(2))+(pt1(1)-pt2(1))*(pt3(2)-pt4(2)))];
                                modelpt([idxj,idxk],:)=[pt1,intpt;pt4,intpt];%!!!
                            else%D3_2 %!!!
                                %mdlrecg='D3_2';
                                if ~xchng
                                    pt1=[rx+rs(idxl)*cos(idxl*a),ry+rs(idxl)*sin(idxl*a)];
                                    pt2=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                                    pt3=[rx+rs(idxk)*cos(idxm*a),ry+rs(idxk)*sin(idxm*a)];
                                    pt4=[rx+rs(idxk)/cos(a)*cos(idxk*a),ry+rs(idxk)/cos(a)*sin(idxk*a)];
                                else
                                    pt1=[rx+rs(idxl)*cos(idxn*a),ry+rs(idxl)*sin(idxn*a)];
                                    pt2=[rx+rs(idxj)*cos(idxl*a),ry+rs(idxj)*sin(idxl*a)];
                                    pt3=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                                    pt4=[rx+rs(idxk)/cos(a)*cos(idxi*a),ry+rs(idxk)/cos(a)*sin(idxi*a)];
                                end
                                intpt=[-((-(pt3(1)-pt4(1))*(pt2(1)*pt1(2)-pt1(1)*pt2(2))+(pt1(1)-pt2(1))*(pt4(1)*pt3(2)-pt3(1)*pt4(2)))/((pt3(1)-pt4(1))*(pt1(2)-pt2(2))+(pt1(1)-pt2(1))*(-pt3(2)+pt4(2)))),...
                                    (pt4(1)*(pt1(2)-pt2(2))*pt3(2)+pt1(1)*pt2(2)*pt3(2)-pt3(1)*pt1(2)*pt4(2)-pt1(1)*pt2(2)*pt4(2)+pt3(1)*pt2(2)*pt4(2)+pt2(1)*pt1(2)*(-pt3(2)+pt4(2)))/(pt4(1)*(pt1(2)-pt2(2))+pt3(1)*(-pt1(2)+pt2(2))+(pt1(1)-pt2(1))*(pt3(2)-pt4(2)))];
                                modelpt([idxj,idxk],:)=[pt2,intpt;pt3,intpt];%!!!
                            end
                        else
                            %D4
                            %mdlrecg='D4';
                            mdl(k)=14;
                            %finished(k)=true;
                            finished(idxk)=true;
                            if ~xchng
                                pt1=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                                pt2=[rx+rs(idxi)/cos(a)*cos(idxk*a),ry+rs(idxi)/cos(a)*sin(idxk*a)];
                                pt3=[rx+rs(idxk)*cos(idxm*a),ry+rs(idxk)*sin(idxm*a)];
                                pt4=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                            else
                                pt1=[rx+rs(idxi)*cos(idxj*a),ry+rs(idxi)*sin(idxj*a)];
                                pt2=[rx+rs(idxi)/cos(a)*cos(idxi*a),ry+rs(idxi)/cos(a)*sin(idxi*a)];
                                pt3=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                                pt4=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                            end
                            intpt=[-((-(pt3(1)-pt4(1))*(pt2(1)*pt1(2)-pt1(1)*pt2(2))+(pt1(1)-pt2(1))*(pt4(1)*pt3(2)-pt3(1)*pt4(2)))/((pt3(1)-pt4(1))*(pt1(2)-pt2(2))+(pt1(1)-pt2(1))*(-pt3(2)+pt4(2)))),...
                                (pt4(1)*(pt1(2)-pt2(2))*pt3(2)+pt1(1)*pt2(2)*pt3(2)-pt3(1)*pt1(2)*pt4(2)-pt1(1)*pt2(2)*pt4(2)+pt3(1)*pt2(2)*pt4(2)+pt2(1)*pt1(2)*(-pt3(2)+pt4(2)))/(pt4(1)*(pt1(2)-pt2(2))+pt3(1)*(-pt1(2)+pt2(2))+(pt1(1)-pt2(1))*(pt3(2)-pt4(2)))];
                            modelpt([idxj,idxk],:)=[pt1,intpt;pt3,intpt];
                        end
                    else
                        %C
                        %mdlrecg='C';
                        mdl(k)=10;
                        %finished(k)=true;
                        if ~xchng
                            modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
                            modelpt(k,3:4)=[rx+rs(idxj)*cos(idxi*a),ry+rs(idxj)*sin(idxi*a)];
                        else
                            modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                            modelpt(k,3:4)=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
                        end
%                         if dsi<dsk/cos(a)%dsj>dsi/cos(a)%C_2 %!!!
%                             %mdlrecg='C_2';
% %                             if ~xchng
% %                                 modelpt(k,1:2)=[rx+rs(idxk)/cos(a/2)*cos(idxk*a),ry+rs(idxk)/cos(a/2)*sin(idxk*a)];
% %                                 modelpt(k,3:4)=[rx+rs(idxk)/cos(3/2*a)*cos(idxi*a),ry+rs(idxk)/cos(3/2*a)*sin(idxi*a)];
% %                             else
% %                                 modelpt(k,1:2)=[rx+rs(idxk)/cos(a/2)*cos(idxi*a),ry+rs(idxk)/cos(a/2)*sin(idxi*a)];
% %                                 modelpt(k,3:4)=[rx+rs(idxk)/cos(3/2*a)*cos(idxj*a),ry+rs(idxk)/cos(3/2*a)*sin(idxj*a)];
% %                             end
%                             if ~xchng
%                                 modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
%                                 modelpt(k,3:4)=[rx+rs(idxk)/cos(2*a)*cos(idxi*a),ry+rs(idxk)/cos(2*a)*sin(idxi*a)];
%                             else
%                                 modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
%                                 modelpt(k,3:4)=[rx+rs(idxk)/cos(2*a)*cos(idxj*a),ry+rs(idxk)/cos(2*a)*sin(idxj*a)];
%                             end
%                         else%C_1
%                             %mdlrecg='C_1';
%                             if ~xchng
%                                 modelpt(k,1:2)=[rx+rs(idxi)*cos(idxk*a),ry+rs(idxi)*sin(idxk*a)];
%                                 modelpt(k,3:4)=[rx+rs(idxj)*cos(idxi*a),ry+rs(idxj)*sin(idxi*a)];
%                             else
%                                 modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
%                                 modelpt(k,3:4)=[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)];
%                             end
%                         end
                    end
                else%?
                    unknown=true;
                    mdl(k)=17;
                end
            else%?
                unknown=true;
                mdl(k)=17;
            end
        end
    else%A2, B1,2, E
        if dsj-dsi>2*r%j/k--->i, %A2, B1,2
            if dsk-dsi>2*r%k/j--->i
                %A2
                %mdlrecg='A2';
                mdl(k)=2;
                %finished(k)=true;
                modelpt(k,1:2)=[rx+rs(k)*cos((k-3/4)*a),ry+rs(k)*sin((k-3/4)*a)];
                modelpt(k,3:4)=[rx+rs(k)*cos((k-1/4)*a),ry+rs(k)*sin((k-1/4)*a)];
            else
                if (dsm>dsk)&&(dsm-dsk<2*r)%k<--m
                    %B1
                    mdl(k)=4;
                    %finished(k)=true;
                    if dsk<dsi/cos(a)%B1_2
                        %mdlrecg='B1_2';
                        if ~xchng
                            modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                            modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(idxk*a),ry+rs(idxi)/cos(a)*sin(idxk*a)];
                        else
                            modelpt(k,1:2)=[rx+rs(idxi)*cos(idxj*a),ry+rs(idxi)*sin(idxj*a)];
                            modelpt(k,3:4)=[rx+rs(idxi)/cos(a)*cos(idxi*a),ry+rs(idxi)/cos(a)*sin(idxi*a)];
                        end
                    else%B1_1
                        %mdlrecg='B1_1';
                        if ~xchng
                            modelpt(k,1:2)=[rx+rs(idxi)*cos(idxi*a),ry+rs(idxi)*sin(idxi*a)];
                            modelpt(k,3:4)=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                        else
                            modelpt(k,1:2)=[rx+rs(idxi)*cos(idxj*a),ry+rs(idxj)*sin(idxi*a)];
                            modelpt(k,3:4)=[rx+rs(idxk)*cos(idxi*a),ry+rs(idxk)*sin(idxi*a)];
                        end
                    end
                else
                    %B2
                    %mdlrecg='B2';
                    mdl(k)=5;
                    %!!! ->model like A
                    modelpt(k,1:2)=[rx+rs(k)*cos((k-3/4)*a),ry+rs(k)*sin((k-3/4)*a)];
                    modelpt(k,3:4)=[rx+rs(k)*cos((k-1/4)*a),ry+rs(k)*sin((k-1/4)*a)];
                    %finished(k)=true;
%                     if ~xchng
%                         modelpt(k,1:2)=[rx+rs(idxi)*cos((idxi-1/2)*a),ry+rs(idxi)*sin((idxi-1/2)*a)];
%                         modelpt(k,3:4)=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
%                     else
%                         modelpt(k,1:2)=[rx+rs(idxi)*cos((idxi-1/2)*a),ry+rs(idxi)*sin((idxi-1/2)*a)];
%                         modelpt(k,3:4)=[rx+rs(idxk)*cos(idxi*a),ry+rs(idxk)*sin(idxi*a)];
%                     end
                end
            end
        else
            %E
            %mdlrecg='E';
            mdl(k)=15;
            %finished(k)=true;
            if ~xchng
                modelpt(k,1:2)=[rx+rs(idxk)*cos(idxk*a),ry+rs(idxk)*sin(idxk*a)];
                modelpt(k,3:4)=[rx+rs(idxi)*cos((idxi-1/2)*a),ry+rs(idxi)*sin((idxi-1/2)*a)];
                mptadd=[mptadd;modelpt(k,3:4),[rx+rs(idxj)*cos(idxi*a),ry+rs(idxj)*sin(idxi*a)]];
            else
                modelpt(k,1:2)=[rx+rs(idxk)*cos(idxi*a),ry+rs(idxk)*sin(idxi*a)];
                modelpt(k,3:4)=[rx+rs(idxi)*cos((idxi-1/2)*a),ry+rs(idxi)*sin((idxi-1/2)*a)];
                mptadd=[mptadd;modelpt(k,3:4),[rx+rs(idxj)*cos(idxj*a),ry+rs(idxj)*sin(idxj*a)]];
            end
            if abs(vectorangle((modelpt(k,3:4)-modelpt(k,1:2)),(mptadd(end,1:2)-mptadd(end,3:4)),1)>2.96)
                modelpt(k,3:4)=mptadd(end,3:4);
                mptadd(end,:)=[];
                %mdlrecg='E2C';
            end
        end
    end
    end
    if ~unknown
        finished(k)=true;
    end
%     %debug
%     plot(modelpt(k,[1,3]),modelpt(k,[2,4]),'k');%
%     text(rx+3.2*cos((k-.5)*a),ry+3.2*sin((k-.5)*a),mdlrecg);%
%     %
end
end


