function BtstrpMat = PolitisRomanoBootstrap( alternative , n , blockparam, display,flag,mat)

% It is exactly coded as in the paper:
% "The Stationary bootstrap" by Dimitris N. Politis and Joseph P. Romano
% The exact description can be found on page 4 in this paper
% link existed at the date of creation  ==> 
% http://www.stat.purdue.edu/research/technical_reports/pdfs/1991/tr91-03.pdf

% Note you could easily replace the if loop with geornd too speed things
% up, but it is done this way for educational sake and to folow the exact
% description of the paper !


[r c] =size(alternative);
BtstrpMat = zeros(n,c)/0;

for i=1:n
    if display ==1
        disp(['simulations done : ' num2str(i)])
    end
    
    New= zeros(r,c)/0;
    tel=0;
    while tel < r
        tel = tel + 1;
        p = rand;
        if p < blockparam || tel == 1
            row=randi(r);
            Xnext = alternative(row,:);
        else
            row = row + 1;
            if row > r
                row = row - r;
            end
            
            Xnext = alternative(row,:);
        end
        New(tel,:)=Xnext;
    end

    
    if flag ==1
        f = - New.^2 + mat.^2;
    elseif flag==2
        f = log(1+New)-log(1+mat);
    elseif flag ==3
        f = - abs (New) + abs(mat);
    end
    
    
    froof = mean(f,1);
    BtstrpMat(i,:)=froof;
    
end






