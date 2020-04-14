%% 图像初始化处理
[a,b,c] = imread('./image/b.png');
Image = ind2rgb(a,b);
imshow(Image);
GrayImage = rgb2gray(Image);
imshow(GrayImage)
%% 高斯滤波
W = fspecial('gaussian',[5,5],1); 
ImageGauss = imfilter(GrayImage, W, 'replicate');
imshow(ImageGauss);
%% 阈值测试
ImagePic2 = imbinarize(ImageGauss,0.98);
imshow(ImagePic2);
%% 图形学计算
SE = strel('disk',10);
SE2 = strel('disk',5);

ImageDilate = imdilate(ImagePic2,SE);
imshow(ImageDilate);

ImageErode = imerode(ImageDilate,SE2);
imshow(ImageErode);

ImageClosingg = imclose(ImagePic2 , SE);
imshow(ImageClosingg);
%% 数学形态学运算

%BW = bwmorph(,'dilate');
BW2 = bwmorph(ImagePic2,'thicken',5);
BW3 = bwmorph(BW2,'bridge',Inf);
BW4 = bwmorph(BW3,'close',Inf);
BW5 = bwmorph(BW4,'bridge',Inf);
BW6 = bwmorph(BW5,'thicken',5);               
BW7 = bwmorph(BW6,'bridge',Inf);
BW8 = bwmorph(BW7,'open',Inf);
BW9 = bwmorph(BW8,'bridge',Inf);
BW10 = bwmorph(BW9,'skel',Inf);
BW11 = bwmorph(BW10,'spur',Inf);
imshow(BW11);
