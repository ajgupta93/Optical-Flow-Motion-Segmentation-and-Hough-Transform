function [ corners ] = CornerDetect(Image, nCorners, smoothSTD, windowSize)
% Function to detect corners in an image

%% Read image size
[h, w] = size(Image);

%% Smoothing with gaussian kernel
gaussian = fspecial('gaussian', windowSize, smoothSTD);
smooth_im = conv2(double(Image), gaussian, 'same');
plain = ones(windowSize);

%% Calculating gradient images
[gx, gy] = gradient(smooth_im);

%% Calculating product of derivatives
Ixx = gx.*gx;
Iyy = gy.*gy;
Ixy = gx.*gy;

%% Calculating weighted sum of product of derivatives
Sxx = conv2(Ixx, plain, 'same');
Syy = conv2(Iyy, plain, 'same');
Sxy = conv2(Ixy, plain, 'same');

%% Calculating cornerness at each point
r = zeros([h,w]);
k = 0.04;
for i=25:h-25
    for j=25:w-25
        c = [Sxx(i,j), Sxy(i,j); Sxy(i,j), Syy(i,j)];
        [~,d,~] = svd(c);
        %e = eig(c);
        r(i,j) = det(d)-trace(d);
        if(r(i,j)<k)
            r(i,j) = 0;
        end
    end
end

%% Non maximal supression
ws = floor(windowSize/2);
for i=ws+1:h-ws
    for j=ws+1:w-ws
        if(r(i,j)<max(max(r(i-ws:i+ws,j-ws:j+ws))))
            r(i,j) = 0;
        end
    end
end

%% Getting nCorners best corners
[~, indices] = sort(r(:), 'descend');
[i, j] = ind2sub(size(r), indices);
corners = [i(1:nCorners),j(1:nCorners)];
end