clear all;
close all;
clc;
%% Method One
range = 256;
thresh = 10;
img = imread('1.bmp');
X = 1:size(img, 1);
Y = 1:size(img, 2);
Z = double(img);

[XI, YI] = meshgrid(1:49/(range - 1):50);
ZI = interp2(X, Y, Z, XI, YI);
% figure, mesh(XI, YI, ZI);
imgX = ZI/(max(max(ZI)))*255;
imgX = uint8(imgX);

% figure, imshow(imgX);
% figure, imhist(imgX);

imgB = imgX > thresh;
% figure, imshow(imgB);
[L, num] = bwlabel(imgB);

imgG_All = zeros(size(L));
imgG = zeros(size(L));
for i1 = 1:num
%     length(imgX(L == i1))
    L_cut = L == i1;
    imgX_cut = double(imgX).*double(L_cut);
    A = max(max(imgX_cut))
    [x, y] = find(imgX_cut == A);
    
    if length(x) ~= 1 || length(y) ~= 1
        x = round(mean(x));
        y = round(mean(y));
    end
    
    for i2 = 1:size(L, 1)
        for i3 = 1:size(L, 2)
            imgG(i2, i3) = (i2 - x)^2 + (i3 - y)^2;
        end
    end
    
    d = std(double(imgX(L == i1)));
    imgG = -imgG/(2*d);
    imgG = A * exp(imgG);
%     imgG = exp(imgG) / (sqrt(2*pi) * sqrt(d));    
    imgG_All = imgG_All + imgG;
end

figure, surf(imgG_All)