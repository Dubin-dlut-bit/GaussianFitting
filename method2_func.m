function imgG = method2_func(imgX_cut, d1, d2)
    
    A = max(max(imgX_cut));
    [x, y] = find(imgX_cut == A);
    if length(x) ~= 1 || length(y) ~= 1
        x = round(mean(x));
        y = round(mean(y));
    end
%     [A, (x - 1)*49/255 + 1, (y - 1)*49/255 + 1]
%     if d1 == d2 && d1 == 0
%     imgG = spectial_time(imgX_cut, A, x, y);
%         return
%     end

    d1 = d1/49/49*255*255;
    d2 = d2/49/49*255*255;

    imgG = zeros(size(imgX_cut));
    for i2 = 1:size(imgG, 1)
        for i3 = 1:size(imgG, 2)
            imgG(i2, i3) = (i2 - x)^2/d2 + (i3 - y)^2/d1;
        end
    end

    imgG = -imgG;
    imgG = A * exp(imgG);
end

%% %% Special Situation: Area 6
% function imgG = spectial_time(imgX_cut, A, x, y)
%     d1 = 1.947/49/49*255*255;
%     d2 = 1.194/49/49*255*255;
%     imgG = zeros(size(imgX_cut));
%     for i2 = 1:size(imgX_cut, 1)
%         for i3 = 1:size(imgX_cut, 2)
%             imgG(i2, i3) = (i2 - x)^2/d2 + (i3 - y)^2/d1;
%         end
%     end
% 
%     imgG = -imgG;
%     imgG = A * exp(imgG);
% 
%     d1 = 1.746/49/49*255*255;
%     d2 = 0.641/49/49*255*255;
% 
%     imgGx = zeros(size(imgX_cut));
%     for i2 = 1:size(imgX_cut, 1)
%         for i3 = 1:size(imgX_cut, 2)
%             imgGx(i2, i3) = (i2 - (25 - 1)/49*255 + 1)^2/d2 + (i3 - (29.5 - 1)/49*255 + 1)^2/d1;
%         end
%     end
% 
%     imgGx = -imgGx;
%     imgGx = 230 * exp(imgGx);
% 
%     imgG = imgGx + imgG;
% end