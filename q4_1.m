foldername = 'truck';
files = dir(foldername);
files = files(3:end);
nframes = size(files,1);
framesequence = cell([1,nframes]);

for i=1:nframes
    im = imread(strcat(files(i).folder,'/',files(i).name));
    if length(size(im))==3
        im = rgb2gray(im);
    end
    framesequence{i} = im;
end

tau = 10;
background = backgroundSubtract(framesequence, tau);
figure,imagesc(background);colormap(gray);