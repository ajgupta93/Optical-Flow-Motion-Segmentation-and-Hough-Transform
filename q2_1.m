close all;

%I1 = imread('corridor/bt.000.png');
%I2 = imread('corridor/bt.001.png');

%I1 = imread('sphere/sphere.0.png');
%I2 = imread('sphere/sphere.1.png');

I1 = imread('synth/synth_000.png');
I2 = imread('synth/synth_001.png');

%I1 = imread('flower/00029.png');
%I2 = imread('flower/00030.png');

figure,imshow(I1);
figure,imshow(I2);

if(size(I1,3)==3)
    I1 = rgb2gray(I1);
    I2 = rgb2gray(I2);
end

I1 = mat2gray(I1);
I2 = mat2gray(I2);

tau = 0.01;
windowSize = 15;

skip = 8;

[u, v, hitMap] = opticalFlowLK1(I1, I2, windowSize, tau);
[x, y] = meshgrid(1:skip:size(I1,2), size(I1,1):-skip:1);
qu = u(1:skip:size(I1,1), 1:skip:size(I1,2));
qv = v(1:skip:size(I1,1), 1:skip:size(I1,2));
quiver(x,y, qu, -qv,'linewidth', 1);
figure,imagesc(hitMap),colormap(gray);

