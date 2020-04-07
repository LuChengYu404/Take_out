%% 地图获取和标记
API = 'http://api.map.baidu.com/staticimage/v2';
ak = 'DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
width = 1024;
height = 1024;
center = '浙江大学紫金港校区';
zoom = 17;
copyright = 1;
dpiType = 'ph';
markers = '蓝田学园';
[a b c]= webread(API,'ak',ak,'width',width,'height',height,'center',...
    center,'zoom',zoom,'copyType',copyright,'dpiType',dpiType,...
    'markers',markers);
imshow(a,b)
%% 经纬度装换
API = 'http://api.map.baidu.com/geocoding/v3';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
address = '浙江大学紫金港校区';
city= '杭州市';
output='xml';
result = webread(API,...
    'address',address,'city',city,'ak',ak,'output',output)
%% 圆形检索
API = 'http://api.map.baidu.com/place/v2/search';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
query = '餐饮';
radius = '10000';
location = '30.3164123616,120.089010715';
page_size = '20';
result = webread(API,'ak',ak,'query',query,'radius',radius,'location',location,'page_size',page_size )
save result
%% xml数据转换
clear;
load result
%% xml数据获取
page_size2num=str2double(page_size);
syms i;
name='<name>*?</name>';
lat='<lat>.*?</lat>';
lng='<lng>*?</lng>';
address='<address>*?</address>';
province='<province>*?</province>';
city='<city>*?</city>';
area='<area>*?</area>';
telephone='<telephone>*?</telephone>';
datail='<detail>*?</detail>';
uid='<uid>*?</uid>';
for i=1:page_size
getname(i)=xml2str(result,name,i);
end
%% xml2
expr='<lat>.*?</lat>';
num=xml3num(result,expr)
