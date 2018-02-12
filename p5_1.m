img = zeros(11, 11);
img = uint8(img);
img(1,1) = 1;
img(1,11) = 1;
img(11,1) = 1;
img(11,11) = 1;
img(6,6) = 1;

hold on;

imagesc(img),colormap(jet)
colorbar

interval = 0.5;
D = [];

for i = -16:0.5:16
    D = [D i];
end


H = zeros(65, 362);
for i = 1:11
    for j = 1:11
        if img(i,j) == 1
            for theta = 1:0.5:181
                d = i * cosd(theta - 1) + j * sind(theta - 1);
                [d index] = min(abs(D - d));
                H(index, theta * 2) = H(index, theta * 2) + 1;
            end
        end
    end
end

for i = 1:65
    for j = 1:0.5:181
        if H(i, 2 * j) > 2
            if i > 32
                d = double(i - 33) / 2;
            else
                d = -1 * double(i) / 2;
            end
            th = j;
            x = 1:11;
            y = d * cscd(th - 1) - x * cotd(th - 1);
            axis([1,11,1,11]);
            plot(x, y, 'r');
        end
    end
end



hold off;