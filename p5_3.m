img = imread('data/mscommons1.jpeg');
img = rgb2gray(img);
%img = imresize(img, [150, 200]);
imshow(img);
newimg = edge(img, 'sobel', 0.1);
[length width] = size(newimg);
hold on;

interval = 0.5;
D = [];

newimg(1:15,:) = 0;
newimg(:, 1:15) = 0;
newimg(end-15:end, :) = 0;
newimg(:, end-15:end) = 0;

maxd = ceil(sqrt(length * length + width * width));

for i = -maxd:0.5:maxd
    D = [D i];
end


H = zeros(4 * maxd + 1, 91);
for i = 1:length
    for j = 1:width
        if newimg(i,j) == 1
            for theta = 2:2:182
                d = i * cosd(theta - 2) + j * sind(theta - 2);
                [d index] = min(abs(D - d));
                H(index, theta / 2) = H(index, theta / 2) + 1;
            end
        end
    end
end

R = max(H);
maximum = max(R);
threshold = 15 * double(maximum) / 100;

for i = 1:4 * maxd + 1
    for j = 2:2:182
        if H(i, j / 2) > threshold
            if i > 2 * maxd
                d = double(i - 2 * maxd - 1) / 2;
            else
                d = -1 * double(i) / 2;
            end
            th = j;
            x = 1:length;
            y = d * cscd(th - 2) - x * cotd(th - 2);
            plot(y, x, 'r');
        end
    end
end



hold off;
