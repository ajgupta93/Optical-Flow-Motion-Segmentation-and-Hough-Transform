img = imread('data/lanes.png');
img = rgb2gray(img);
imshow(img);
newimg = edge(img, 'sobel', 0.1);

newimg(1:15,:) = 0;
newimg(:, 1:15) = 0;
newimg(end-15:end, :) = 0;
newimg(:, end-15:end) = 0;
[length width] = size(newimg);
hold on;

interval = 0.5;
D = [];

maxd = ceil(sqrt(length * length + width * width));

for i = -maxd:0.5:maxd
    D = [D i];
end


H = zeros(4 * maxd + 1, 362);
for i = 1:length
    for j = 1:width
        if newimg(i,j) == 1
            for theta = 1:0.5:181
                d = i * cosd(theta - 1) + j * sind(theta - 1);
                [d index] = min(abs(D - d));
                H(index, theta * 2) = H(index, theta * 2) + 1;
            end
        end
    end
end

R = max(H);
maximum = max(R);
threshold = 3 * double(maximum) / 4;

for i = 1:4 * maxd + 1
    for j = 1:0.5:181
        if H(i, 2 * j) > threshold
            if i > 2 * maxd
                d = double(i - 2 * maxd - 1) / 2;
            else
                d = -1 * double(i) / 2;
            end
            th = j;
            x = 1:length;
            y = d * cscd(th - 1) - x * cotd(th - 1);
            plot(y, x, 'r');
        end
    end
end



hold off;

