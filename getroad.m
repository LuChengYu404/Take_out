function image = getroad(path)
% path����Ҫ������ļ�·��
% image�������ͼ��
% nodes�������¼��·�ڵ���Ϣ
%% ����ͼƬ��Ϣ
% Ĭ��·�� 
path = './image/b.png';
[a,b,c] = imread(path);
Image = ind2rgb(a,b);
figure(1);
imshow(Image);
title('ԭʼͼ��');

%% RGBת�Ҷ�
GrayImage = rgb2gray(Image);
figure(2);
imshow(GrayImage);
title('�Ҷ�ͼ��');

%% ��˹�˲�
W = fspecial('gaussian',[5,5],1); 
ImageGauss = imfilter(GrayImage, W, 'replicate');
figure(3);
imshow(ImageGauss);
title('��˹����');

%% �Ҷ���ֵ��ֵ��
ImagePic2 = imbinarize(ImageGauss,0.99); % ����������ɫ��·����
figure(4);
imshow(ImagePic2);
title('��ֵ������')

%% ��ѧ��̬ѧ����
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