function show(I,M)
%show - show content aware image resizing
%
% show(I,M) opens a figure window to allow interactive resizing of I
% in one direction based on the seam removal map M.
%
% See also removalMap.

% figure out if seams are horizontal or vertical
[h,w] = size(M);
horiz = all(sum(M,1)==sum(1:h))
vert = all(sum(M,2)==sum(1:w))
if ~xor(horiz,vert), error('seams not horizontal or vertical?!'); end

fh = figure; clf;
set(fh,'DoubleBuffer','on');
set(fh,'WindowButtonDownFcn',@mouseDown);
set(fh,'WindowButtonMotionFcn',@mouseMove);
set(fh,'WindowButtonUpFcn',@mouseUp);
set(fh,'WindowScrollWheelFcn',@mouseWheel);
% set(fh,'Interruptible','off');
% set(fh,'BusyAction','queue');
if horiz,
    ih = imshow(cat(1,I,I));
    title('horizontal seams');
else
    ih = imshow(cat(2,I,I));
    title('vertical seams');
end
set(ih,'CData',I);

if ~horiz,
    I = permute(I,[2,1,3]);
    M = M';
end

[h,w] = size(M);

n = 0; % how many seams we are removing

    % remove an additional dn seams
    function move(dn)
        n = n + dn;
        if n >= 0, % shrink image
            if horiz,
                set(ih,'CData',shrink(I,M,n));
            else
                set(ih,'CData',permute(shrink(I,M,n),[2,1,3]));
            end
        else % grow image
            if horiz,
                set(ih,'CData',expand(I,M,-n));
            else
                set(ih,'CData',permute(expand(I,M,-n),[2,1,3]));
            end
        end
        drawnow;
    end

p0 = []; % location of mouse down event
drag = false; % is the mouse being dragged?
moving = false; % are we moving the image?

    function mouseDown(src,evt)
        p0 = get(fh,'CurrentPoint');
        drag = true;
    end

    function mouseMove(src,evt)
        if ~drag, return; end
        if moving, return; end % serialize execution of this function
        moving = true;
        p = get(fh,'CurrentPoint');
        if horiz,
            move( p(2) - p0(2) );
        else
            move( p0(1) - p(1) );
        end
        p0 = p;
        moving = false;
    end

    function mouseWheel(src,evt)
        move( -evt.VerticalScrollCount * evt.VerticalScrollAmount );
    end

    function mouseUp(src,evt)
        drag = false;
    end

end