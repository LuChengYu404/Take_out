[a,b,c] = imread('./image/test_img.png');
img = ind2rgb(a,b);
imgGray = rgb2gray(img);
Pic2=imbinarize(imgGray,0.90);
imshow(Pic2)