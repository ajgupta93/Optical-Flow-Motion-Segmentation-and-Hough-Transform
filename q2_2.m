%I = imread('corridor/bt.001.png');
%I = imread('flower/00029.png');

if(length(size(I))==3)
    I = rgb2gray(I);
end

smoothSTD = 1;
windowSize = 7;
nCorners = 50;

[corners] = CornerDetect(I, nCorners, smoothSTD, windowSize);

figure, imshow(I);
hold on;
for i=1:nCorners
plot(corners(i,2),corners(i,1),'b+','MarkerSize',20);
end