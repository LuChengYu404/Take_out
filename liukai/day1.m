%%
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
%%
API = 'http://api.map.baidu.com/geocoding/v3';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
address = '浙江大学紫金港校区';
city= '杭州市';
output='xml';
result = webread(API,...
    'address',address,'city',city,'ak',ak,'output',output)
%%
API = 'http://api.map.baidu.com/place/v2/search';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
query = '房地产';
radius = '10000';
location = '30.3164123616,120.089010715';
page_size = '20';
result = webread(API,'ak',ak,'query',query,'radius',radius,'location',location,'page_size',page_size )
%%
    str=strings(1);