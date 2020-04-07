%% 图像初始化处理
[a,b,c] = imread('./image/test_img.png');
img = ind2rgb(a,b);
imgGray = rgb2gray(img);
%% 阈值测试
Pic2=imbinarize(imgGray,0.99);
SE = strel('square',2);
open = imclose(Pic2,SE);
%imshow(Pic2)
imshow(open)
%% 去除文字测试
GS = graythresh(imgGray);
img_pic2 = imbinarize(imgGray, 0.7);
img_1 = ones(1024,1024) - img_pic2;
img_2 = img_1+imgGray;
imshow(img_2);