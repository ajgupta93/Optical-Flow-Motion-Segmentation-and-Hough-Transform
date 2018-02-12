function [H] = computeH(p1, p2)
% http://www.cse.iitd.ernet.in/~suban/vision/geometry/node24.html
A = [];
p1(:,3) = 1;
zero = zeros([1,3]);
for i=1:4
    A = [A;
         zero, -p1(i,3).*p2(i,:), p1(i,2).*p2(i,:);...
         p1(i,3).*p2(i,:), zero, -p1(i,1).*p2(i,:);...
         -p1(i,2).*p2(i,:), p1(i,1).*p2(i,:), zero;];
end
[~,~,v] = svd(A);
H = v(:,end);
H = reshape(H,[3,3])';
end