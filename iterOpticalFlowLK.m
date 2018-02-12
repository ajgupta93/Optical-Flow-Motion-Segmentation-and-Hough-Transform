function [uf,vf] = iterOpticalFlowLK(I1,I2,initu ,initv ,windowSize,tau,iters)

%% Preprocess the image
I1 = mat2gray(I1);
I2 = mat2gray(I2);

%% Find the derivates in x and y direction
d = 1/12.*[-1,8,0,-8,1];
sz = size(I1);
Ix = conv2(I1,d,'same');
Iy = conv2(I1,d', 'same');

%% Sum the derivates in windows
Ixx = conv2(Ix.^2, ones(windowSize),'same');
Iyy = conv2(Iy.^2, ones(windowSize),'same');
Ixy = conv2(Ix.*Iy, ones(windowSize),'same');

%% Iterative Lucas Kanade
uf = zeros(sz);
vf = zeros(sz);
half = floor(windowSize/2);
for i = 1:sz(1)
    for j =1:sz(2)
        left = j-half;
        right = j+half;
        top = i-half ;
        bottom = i+half ;
        if(left<=0)
            left = 1;
        end
        if(right>sz(2))
            right = sz(2);
        end
        if(top<=0)
            top = 1;
        end
        if(bottom>sz(1))
            bottom = sz(1);
        end
        win1 = I1(top:bottom,left:right);
        ix = Ix(top:bottom,left:right);
        iy = Iy(top:bottom,left:right);
        A = [Ixx(i,j) Ixy(i,j);...
            Ixy(i,j) Iyy(i,j)];
        r = rank(A);
        % inverse exists only if rank is 2
        if(r~=2)
            Ainv = zeros(2);
        else
            Ainv =inv(A);
        end
        u = initu(i,j);
        v = initv(i,j);
        % iterative refinement of estimate
        for iter = 1:iters
            [x,y] = meshgrid(1:size(I1,2), 1:size(I1,1));
            xp = x+u;
            yp = y+v;
            win2 = interp2(x,y,I2,xp(top:bottom,left:right),yp(top:bottom, left:right));
            it = win2-win1; ixt = it.*ix; iyt = it.*iy;
            B = -[sum(ixt(:)); sum(iyt(:))];
            U = Ainv*B;
            U(isnan(U)) = 0 ;
            u = u+U(1);
            v = v+U(2);
            % desired accuracy achieved
            if(abs(U(1))<tau && abs(U(2))<tau) 
                break;
            end
        end
        uf(i,j)=u; vf(i,j)=v;
    end
end

%% Plotting the quiver plot
[x, y] = meshgrid(1:5:size(I1,2), size(I1,1):-5:1);
qu = uf(1:5:size(I1,1), 1:5:size(I1,2));
qv = vf(1:5:size(I1,1), 1:5:size(I1,2));
quiver(x,y, qu, -qv,'linewidth', 1);
end