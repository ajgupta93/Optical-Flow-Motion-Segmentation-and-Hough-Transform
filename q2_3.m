%% Preprocessing

I1 = imread('corridor/bt.000.png');
I2 = imread('corridor/bt.002.png');

%I1 = imread('sphere/sphere.0.png');
%I2 = imread('sphere/sphere.5.png');

%I1 = imread('synth/synth_000.png');
%I2 = imread('synth/synth_001.png');

figure,imshow(I1);
figure,imshow(I2);
if(size(I1,3)==3)
    I1 = rgb2gray(I1);
    I2 = rgb2gray(I2);
end


%% Corner Detection

smoothSTD = 1;
windowSize = 7;
nCorners = 50;

[corners] = CornerDetect(I1, nCorners, smoothSTD, windowSize);

figure, imshow(I1);
hold on;
for i=1:nCorners
plot(corners(i,2),corners(i,1),'b+','MarkerSize',20);
end

%% Optical flow estimation

I1 = im2double(I1);
I2 = im2double(I2);

tau = 0.01;
windowSize = 100;

[u, v, hitMap] = opticalFlowLK1(I1, I2, windowSize, tau, corners);
x = 1:1:size(I1,2);
y = 1:1:size(I1,1);
[X,Y] = meshgrid(x,y);

figure,imshow(hitMap);
figure,imshow(I1),hold on,quiver(X,Y,u(y,x),v(y,x),10);