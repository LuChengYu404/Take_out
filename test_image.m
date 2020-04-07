[a,b,c] = imread('./image/test_img.png');
img = ind2rgb(a,b);
imgGray = rgb2gray(img);
Pic2=imbinarize(imgGray,0.99);
SE = strel('square',2);
open = imclose(Pic2,SE);
%imshow(Pic2)
imshow(open)
[a,b,c] = imread('./image/test_img.png');
img = ind2rgb(a,b);
imgGray = rgb2gray(img);
Pic2=imbinarize(imgGray,0.90);
imshow(Pic2)