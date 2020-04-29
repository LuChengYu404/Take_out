x = 0:0.1:10;
y = x.^2;
dx = diff(x);
dy = diff(y);
d = sum(sqrt(dx.^2+dy.^2));
plot(x,y,'r-');