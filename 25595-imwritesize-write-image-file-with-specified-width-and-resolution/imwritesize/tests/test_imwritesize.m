function suite = test_imwritesize
%test_imwritesize Unit tests for imwritesize
%   This test file is written for use with MATLAB xUnit on the MATLAB Central
%   File Exchange:
%
%   http://www.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework

%   Steven L. Eddins
%   Copyright 2009 The MathWorks, Inc.

initTestSuite;

function s = setup
s.originalDirectory = pwd;
s.testDirectory = tempname;
s.A = imread('rice.png');
mkdir(s.testDirectory);
cd(s.testDirectory);

function teardown(s)
cd(s.originalDirectory);
rmdir(s.testDirectory, 's');

function test_tif(s)
% Test .tif extension
imwritesize(s.A, 'rice_2in.tif', 2);
info = imfinfo('rice_2in.tif');
assertEqual(info.Format, 'tif');
assertEqual(info.XResolution, 128);
assertEqual(info.YResolution, 128);

function test__tiff(s)
% Test .tiff extension
imwritesize(s.A, 'rice_2in.tiff', 2);
info = imfinfo('rice_2in.tiff');
assertEqual(info.Format, 'tif');
assertEqual(info.XResolution, 128);
assertEqual(info.YResolution, 128);

function test_png(s)
% Test .png extension
imwritesize(s.A, 'rice_2in.png', 2);
info = imfinfo('rice_2in.png');
assertEqual(info.Format, 'png');
assertEqual(info.XResolution, round(128 * 100 / 2.54));
assertEqual(info.YResolution, round(128 * 100 / 2.54));

function test_noext(s)
% When extension isn't .tif, .tiff, or .png, output should be TIFF.
imwritesize(s.A, 'rice_2in.noext', 2);
info = imfinfo('rice_2in.noext');
assertEqual(info.Format, 'tif');

function test_noresize(s)
% Image resize not necessary when resolution not specified.
% Output image pixels should be same as input image pixels.
imwritesize(s.A, 'rice_2in.png', 2);
assertEqual(s.A, imread('rice_2in.png'));

function test_resolution_tif(s)
% Resolution specified for TIFF file.
imwritesize(s.A, 'rice_2in_300dpi.tif', 2, 300);
info = imfinfo('rice_2in_300dpi.tif');
assertEqual(info.Height, 600);
assertEqual(info.Width, 600);
assertEqual(info.XResolution, 300);
assertEqual(info.YResolution, 300);

function test_resolution_png(s)
% Resolution specified for PNG file.
imwritesize(s.A, 'rice_2in_300dpi.png', 2, 300);
info = imfinfo('rice_2in_300dpi.png');
assertEqual(info.Height, 600);
assertEqual(info.Width, 600);
assertEqual(info.XResolution, round(300 * 100 / 2.54));
assertEqual(info.YResolution, round(300 * 100 / 2.54));

function test_case_insensitive_extension(s)
% .tif and .TIF should work equally well
imwritesize(s.A, 'rice_2in.TIF', 2);
info = imfinfo('rice_2in.TIF');
assertEqual(info.Format, 'tif');
