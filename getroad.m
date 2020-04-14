function image = getroad(path)
% path：需要处理的文件路径
% image：输出的图像
% nodes：矩阵记录道路节点信息
%% 加载图片信息
% 默认路径 
path = './image/b.png';
[a,b,c] = imread(path);
Image = ind2rgb(a,b);
figure(1);
imshow(Image);
title('原始图像');

%% RGB转灰度
GrayImage = rgb2gray(Image);
figure(2);
imshow(GrayImage);
title('灰度图像');

%% 高斯滤波
W = fspecial('gaussian',[5,5],1); 
ImageGauss = imfilter(GrayImage, W, 'replicate');
figure(3);
imshow(ImageGauss);
title('高斯处理');

%% 灰度阈值二值化
ImagePic2 = imbinarize(ImageGauss,0.99); % 仅仅保留白色道路部分
figure(4);
imshow(ImagePic2);
title('二值化处理')

%% 数学形态学运算
BW1 = bwmorph(ImagePic2,'thicken',10);
BW2 = bwmorph(BW1,'majority',Inf);
BW3 = bwmorph(BW2,'open',Inf);
BW4 = bwmorph(BW3,'bridge',Inf);
BW5 = bwmorph(BW4,'majority',Inf);
BW6 = bwmorph(BW5,'thin',Inf);
BW7 = bwmorph(BW6,'dilate',1);

BW99=edge(ImageGauss,'Sobel',0.01);

imshow(BW99);

end