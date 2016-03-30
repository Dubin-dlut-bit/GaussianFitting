clear all;
close all;
clc;
%% Method Two
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

imgB = imgX > thresh;
[L, num] = bwlabel(imgB);

imgG_All = zeros(size(imgX));
for i1 = 1:num
    L_cut = L == i1;
    imgX_cut = double(imgX).*double(L_cut);

    A = max(max(imgX_cut));
    [x, y] = find(imgX_cut == A);
    if length(x) ~= 1 || length(y) ~= 1
        x = round(mean(x));
        y = round(mean(y));
    end
    
    A = int2str(A);
    x0 = (y - 1)*49/255 + 1;
    x0 = num2str(x0, '%.2f');
    y0 = (x - 1)*49/255 + 1;
    y0 = num2str(y0, '%.2f');
    
    [xData, yData, zData] = prepareSurfaceData( XI, YI, imgX_cut );

    % Set up fittype and options.
    libname = [A, '*exp(-((x - ', x0, ')^2/var1 + (y - ', y0, ')^2/var2))'];
    ft = fittype( libname, 'independent', {'x', 'y'}, 'dependent', 'z' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [-Inf -Inf];
    opts.StartPoint = [0.1 0.1];
    % opts.StartPoint = [0.408719846112552 0.594896074008614];
    opts.Upper = [Inf Inf];

    % Fit model to data.
    [fitresult{1}, ~] = fit( [xData, yData], zData, ft, opts );
    
    fprintf('Loop %d:\n', i1);
    var1 = fitresult{1}.var1;
    var2 = fitresult{1}.var2;
    fprintf('var1 = %f\n', var1);
    fprintf('var2 = %f\n', var2);
    
    % Plot the Guassian Result
    imgG = method2_func(imgX_cut, var1, var2);
    imgG_All = imgG_All + imgG;
end
clear i1 L L_cut X Y Z ZI d imgG num range thresh imgX_cut;
clear A x y x0 y0 libname xData yData zData;
clear ft fitresult gof opts;
% save YouCanSaveHere.mat

figure,
subplot(1, 2, 1)
imshow(imgX), title('Original');
subplot(1, 2, 2)
imshow(imgG_All/255), title('Analog Result')

figure, mesh(XI, YI, imgG_All), title '3D Result'