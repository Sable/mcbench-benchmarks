function set_digit(his,digs,n)
if n>=10
    % space
else
    switch n
        case 0
            segs=[1 2 3 5 6 7];
        case 1
            segs=[2 5];
        case 2
            segs=[1 3 4 5 7];
        case 3
            segs=[1 2 4 5 7];
        case 4
            segs=[2 4 5 6];
        case 5
            segs=[1 2 4 6 7];
        case 6
            segs=[1 2 3 4 6 7];
        case 7
            segs=[2 5 7];
        case 8
            segs=[1 2 3 4 5 6 7];
        case 9
            segs=[1 2 4 5 6 7];
    end
    set_visible(his,digs(segs));
end