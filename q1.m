I1 = imread('stadium.jpg');

% get points from the image
figure(10)
imshow(I1)

% select points on the image, preferably the corners of an ad.
points = ginput(4);
figure(1)
subplot(1,2,1);
imshow(I1);

% choose your own set of points to warp your ad too
new_points = [1,1,1;...
              400,1,1;...
              400,200,1;...
              1,200,1];
H = computeH(points, new_points);

% warp will return just the ad rectified
warped_img = warp(I1, new_points, H);
subplot(1,2,2);
imshow(warped_img);