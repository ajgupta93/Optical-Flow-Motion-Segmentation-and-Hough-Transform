function [u, v, hitMap] = opticalFlowLK1(I1, I2, windowSize, tau, points)
% https://www.mathworks.com/help/vision/ref/opticalflowlk-class.html

[h,w] = size(I1);
hitMap = zeros([h,w]);
u = zeros([h,w]);
v = zeros([h,w]);

%% Smoothing with gaussian kernel
gaussian = fspecial('gaussian', [11,11], 4);
I1 = imfilter(I1, gaussian);
I2 = imfilter(I2, gaussian);
window = ones(windowSize);

%% Calculating gradient images
d = 1/12.*[-1,8,0,-8,1];
gx = conv2(I1, d, 'same');
gy = conv2(I1, d', 'same');
gt = I2-I1;

%% Calculating product of derivatives
Ixx = gx.*gx;
Iyy = gy.*gy;
Ixy = gx.*gy;
Ixt = gx.*gt;
Iyt = gy.*gt;

%% Calculating weighted sum of product of derivatives
Sxx = conv2(Ixx, window, 'same');
Syy = conv2(Iyy, window, 'same');
Sxy = conv2(Ixy, window, 'same');
Sxt = conv2(Ixt, window, 'same');
Syt = conv2(Iyt, window, 'same');

area = (windowSize*windowSize);

if nargin==4
    for i=1:h
        for j=1:w
            A = [Sxx(i,j) Sxy(i,j);...
                 Sxy(i,j) Syy(i,j)];
            e = eig(A);
            if(all(e>tau))
                hitMap(i,j) = 255;
                B = -1.*[Sxt(i,j);...
                      Syt(i,j)];
                motion = A\B;
                u(i,j) = motion(1);
                v(i,j) = motion(2);
            end
        end
    end
else
    for k=1:50
        i = points(k,1);
        j = points(k,2);
        A = [Sxx(i,j) Sxy(i,j);...
             Sxy(i,j) Syy(i,j)];
        e = eig(A);
        if(all(e>tau))
            hitMap(i,j) = 255;
            B = -[Sxt(i,j);...
                  Syt(i,j)];
            motion = A\B;
            u(i,j) = motion(1);
            v(i,j) = motion(2);
        end
    end
end