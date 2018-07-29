%GRABFG Framegrabber grabbing image function.
%
%SYNTAX imgmatrix = grabfg(devinfo) or
%       moviematrix = grabfg(devinfo,imgmatrix) or
%       [imgmatrix, moviematrix] = grabfg(devinfo) or
%       grabfg(devinfo, imgmatrix) or
%       grabfg(devinfo,imgmatrix,moviematrix) or
%       grabfg(devinfo,imgmatrix,moviematrix, scaling factor)
%
%DESCRIPTION This function will let the user grab an
%image from a opened framegrabber device. The user has
%to give the framegrabbers device information structure
%as input argument. Executing the openfg function has
%retrieved this device information structure
%
%INPUT The device information structure (devinfo) of
%an opened framegrabber device and the eventually the
%preallocated image matrix  (imgmatrix);
%
%REMARKS It will be verified if the input is a valid
%device information structure. If it's valid, it will
%try to get the deviceid from the device information
%structure. If the second input is given, the function
%will check the size of the second input and checks if
%there's enough room to store the grabbed image. If
%there's enough room the variable (of type imgmatrix)
%will be overwritten without creating a new matrix,
%else a new matrix will be created and stored in that
%variable.
%
%OUTPUT If the input isn't valid or the framegrabber
%isn't able to grab an image, some error message will
%be shown to the user. If everything's ok it will return
%the grabbed image stored in a Matlab matrix (imgmatrix).
%
%The image is stored in transposed way. To show the image
%correctly in Matlab you can use the accent ' on the
%imgmatrix to correct it (=> image(imgmatrix') )
%
%Grabfg also generates true matlab movie matrices. The
%resolution reduction factor defaults to 2.

%EXAMPLE There are two ways to use this function. Both
%will be shown here. Variable m is the device info
%structure which was returned from the function openfg.
%
%1. Just grab an image and store it in the variable im,
%   type:
%               im = grabfg(m);
%
%   To show this image in Matlab
%   (in the right way, not transposed) type:
%               image(im');
%
%2. Just grab an image and movie matrix and store it in the
%   variable im and movie, type:
%               [im,movie] = grabfg(m);
%
%   To show the movie matrix in Matlab
%   (the movie matrix does not need to be transposed) type:
%               movie(movie);
%
%3. First create a matrix of the appropriate size and
%   type where the image will be stored:
%               im = uint8(zeros(768,576));
%
%   Then grab the image:
%               grabfg(m,im);
%
%   To show the image in Matlab type:
%               image(im');

disp('Error: grabfg not found.')