clc
clear all
close all

disp('7 20 20 2');
% Variables used: 
% a(ar,ac),b(br,bc),B,c,d,D,del,delb,delw,der,e,E,i,j,k,l,N,no,O,r,resp,V,W,Y,Yin;
E=10;
d=0;

%Make Training Data
%getdata();
a=dlmread('data1in');
b=dlmread('data1out');
[ar,ac]=size(a);
[br,bc]=size(b);
if ac~=bc
    error('no of input test vectors not equal to no of output test vectors ');
end

%Take inputs- Layers,Emax,
%Initial Weights & Biases  
%================================


l=input('Enter no. of hidden layers ');
l=l+2;

no(1)=ar;
for i=2:l-1
    no(i)=input(sprintf('Enter no of nodes in hidden layer %d: ',i-1 ));
end
no(l)=br;
Emax=input('Enter max expected error Emax ');

[W,B,delw]=initialise(l,no);
%load weightmatrix W B delw;


%Normalize Data
%================================
for i=1:no(1)
    m1(i)=mean(a(i,:));
    v1(i)=std(a(i,:));
    a(i,:)=(a(i,:)-m1(i))/v1(i);
end;

for i=1:no(l)
    m2(i)=mean(b(i,:));
    v2(i)=std(b(i,:));
    b(i,:)=(b(i,:)-m2(i))/v2(i);
end;

%Generate Random Test Vector of length ac2
%================================
ac2=ceil(ac);
r=randint(1,ac2,[1,ac]);
%load matrices r;

for i=1:ac2
    ra(:,i)=a(:,r(i));
    rb(:,i)=b(:,r(i));
end
pause();


figure('BackingStore','off');
hlr = uicontrol('Style','slider','value',.04,'Min',0,'Max',0.2,'SliderStep',[0.01 0.1],'Position', [75 7 150 20]);
N = get(hlr,'value');
edr=uicontrol('Style','text','FontSize', 12,'string', num2str(N),'Position',[230 7 50 20]);
tic;
%Training Loop
%================================
while E>Emax
    N = get(hlr,'value');
    set(edr,'string',num2str(N));
    E=0;
    d=d+1;
    r=randint(1,ac2,[1,ac2]);
    for c=1:ac2

        %Enter training vectors randomly...
        for i=1:no(1)
            Y(i,1)=ra(i,r(c));
            V(i,1)=ra(i,r(c));
            der(i,1)=1;
        end

        for i=1:no(l)
            D(i)=rb(i,r(c));
        end

        for k=1:l-2
            for j=1:no(k+1)
                w=W(1:no(k),j,k);
                y=Y(1:no(k),k);
                V(j,k+1)=y'*w;
                Y(j,k+1)=logsig(V(j,k+1)-B(j,k+1));
                der(j,k+1)=dlogsig(V(j,k+1)-B(j,k+1),Y(j,k+1));
            end
        end

        k=l-1;
        for j=1:no(l)
            w=W(1:no(k),j,k);
            y=Y(1:no(k),k);
            V(j,l)=y'*w;
            Y(j,l)=purelin(V(j,l)-B(j,l));
            der(j,l)=dpurelin(V(j,l)-B(j,l));
        end

        %Computation of Error
        for i=1:no(l)
            e(i)=D(i)-Y(i,l);
            E=E+0.5*(e(i)*e(i));
            del(i,l)=der(i,l)*e(i);
        end

        for k=l-1:-1:1
            for i=1:no(k)
                w=W(i,1:no(k+1),k);
                dd=del(1:no(k+1),k+1);
                de=w*dd;
                del(i,k)=de*der(i,k);
            end
        end

        %Adjust Weights & Bias
        for k=l-1:-1:1
            for i=1:no(k)
                for j=1:no(k+1)
                    delw(i,j,k)=N*del(j,k+1)*Y(i,k)+0.4*delw(i,j,k);;
                    W(i,j,k)=W(i,j,k)+delw(i,j,k);
                end
            end
        end

        for k=2:l
            for i=1:no(k)
                delb(i,k)=N*(-1)*del(i,k);
                B(i,k)=B(i,k)+delb(i,k);
            end
        end
    end
    
    err(d)=E;
     if rem(d,100)==0              %plot after every 100 epochs
        plot([1:d],err,'blu-',[1:d],Emax,'gre-');
        save weightmatrix W B delw;
        pause(0.05);    
        
    end;
end
%End of Training Loop
%================================
toc;
save norms m1 v1 m2 v2 no l;
plot(err),title('Learning Curve'),xlabel('No. of Epochs -----> ');
ylabel('Mean Square Error -----> ');
hold on;
plot([0:d],Emax,'gre');
grid on;

%End of Training Loop

