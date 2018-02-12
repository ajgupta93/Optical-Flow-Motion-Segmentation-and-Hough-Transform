%% Preprocess

I1 = imread('flower/00029.png');
I2 = imread('flower/00030.png');

if size(I1,3)==3
    I1 = rgb2gray(I1);
end

if size(I2,3)==3
    I2 = rgb2gray(I2);
end

%%  Spatial pyramid
ia = cell(3,1);
ia{3} = I1;
ia{2} = impyramid(I1, 'reduce');
ia{1} = impyramid(ia{2}, 'reduce');

ib = cell(3,1);
ib{3} = I2;
ib{2} = impyramid(I2, 'reduce');
ib{1} = impyramid(ib{2}, 'reduce');

%% Parameters
iters = 10;
tau = 0.01;
windowSize = 15;

%% motion estimate at the lowest level of pyramid
ui=zeros(size(ia{1}));
vi=zeros(size(ia{1}));
[u, v] = iterOpticalFlowLK(ia{1}, ib{1}, ui , vi, windowSize, tau, iters);

%% correction of estimate while scaling up
for i=2:3
    upu = imresize(u, size(ia{i}));
    upv = imresize(v, size(ia{i}));
    upu = 2.*upu;
    upv = 2.*upv;
    [u, v] = iterOpticalFlowLK(ia{i}, ib{i}, upu, upv, windowSize, tau, iters) ;
end

%% plotting the quiver plot
[x, y] = meshgrid(1:5:size(I1,2), size(I1,1):-5:1);
qu = u(1:5:size(I1,1), 1:5:size(I1,2));
qv = v(1:5:size(I1,1), 1:5:size(I1,2));
quiver(x,y, qu, -qv,'linewidth', 1);

%% 4.2 segmentation
% calculation total motion at each point
map = zeros(size(u));
for i=1:size(u ,1)
    for j=1:size(u ,2)
        map(i ,j) =sqrt((u(i ,j)).^2 + (v(i ,j)).^2);
    end
end
% thresholding to get the tree
map = imbinarize(map,1.8);
figure, imagesc(map),colormap(gray);