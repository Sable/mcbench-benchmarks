function rgb2bayer(filename, sensoralign)

a = aviinfo(filename);
aviobj = avifile([filename(1:end-4) '_' sensoralign '.avi'],'compression','none');
y = zeros(a.Height,a.Width,3);
    
for i = 1:a.NumFrames
    disp(sprintf(['Working on frame ' num2str(i) ' ...']));
    I = aviread(filename,i);
    I = I.cdata;
    
    switch sensoralign
        case 'gbrg'
            y1 = blkproc(I(:,:,1),[2 2],@bayer_gbrg_1);
            y2 = blkproc(I(:,:,2),[2 2],@bayer_gbrg_2);
            y3 = blkproc(I(:,:,3),[2 2],@bayer_gbrg_3);

            y(:,:,:) = repmat(y1+y2+y3,[1 1 3]);
        case 'brgb'
            y1 = blkproc(I(:,:,1),[2 2],@bayer_brgb_1);
            y2 = blkproc(I(:,:,2),[2 2],@bayer_brgb_2);
            y3 = blkproc(I(:,:,3),[2 2],@bayer_brgb_3);

            y(:,:,:) = repmat(y1+y2+y3,[1 1 3]);
        case 'bggr'
            y1 = blkproc(I(:,:,1),[2 2],@bayer_bggr_1);
            y2 = blkproc(I(:,:,2),[2 2],@bayer_bggr_2);
            y3 = blkproc(I(:,:,3),[2 2],@bayer_bggr_3);

            y(:,:,:) = repmat(y1+y2+y3,[1 1 3]);
        case 'rggb'
            y1 = blkproc(I(:,:,1),[2 2],@bayer_rggb_1);
            y2 = blkproc(I(:,:,2),[2 2],@bayer_rggb_2);
            y3 = blkproc(I(:,:,3),[2 2],@bayer_rggb_3);

            y(:,:,:) = repmat(y1+y2+y3,[1 1 3]);
    end
    
    aviobj = addframe(aviobj,uint8(y));
end

aviobj = close(aviobj);


function b = bayer_gbrg_1(x)
b = x.*uint8([0 0; 1 0]);
function b = bayer_gbrg_2(x)
b = x.*uint8([1 0; 0 1]);
function b = bayer_gbrg_3(x)
b = x.*uint8([0 1; 0 0]);

function b = bayer_brgb_1(x)
b = x.*uint8([0 1; 0 0]); % Red
function b = bayer_brgb_2(x)
b = x.*uint8([0 0; 1 0]); % Green
function b = bayer_brgb_3(x)
b = x.*uint8([1 0; 0 1]); % Blue

function b = bayer_bggr_1(x)
b = x.*uint8([0 0; 0 1]); % Red
function b = bayer_bggr_2(x)
b = x.*uint8([0 1; 1 0]); % Green
function b = bayer_bggr_3(x)
b = x.*uint8([1 0; 0 0]); % Blue

function b = bayer_rggb_1(x)
b = x.*uint8([1 0; 0 0]); % Red
function b = bayer_rggb_2(x)
b = x.*uint8([0 1; 1 0]); % Green
function b = bayer_rggb_3(x)
b = x.*uint8([0 0; 0 1]); % Blue
