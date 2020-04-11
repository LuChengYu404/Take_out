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
% save
%%
% Load an OSM file as a MATLAB structure MAP
map = loadosm('map (2).osm') ;

% Plot highways, buildings, and other lines
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;
bl = find([map.ways.isBuilding]) ;
ot = setdiff(1:numel(map.ways), [hw, bl]) ;

lines=geo2xy(osmgetlines(map, hw)) ; plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 1.5) ;
lines=geo2xy(osmgetlines(map, bl)) ; plot(lines(1,:), lines(2,:), 'g-', 'linewidth', 0.75) ;
lines=geo2xy(osmgetlines(map, ot)) ; plot(lines(1,:), lines(2,:), 'k-', 'linewidth', 0.5) ;

set(gca,'ydir','reverse') ;
xlabel('Web Mercator X') ;
ylabel('Web Mercator Y') ;
legend('highways', 'building', 'other') ; title('OSM in MATLAB') ;
axis equal ; box on ;
%% 经纬度装换
API = 'http://api.map.baidu.com/geocoding/v3';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
address = '桐庐县';
city= '杭州市';
output='xml';
result = webread(API,...
    'address',address,'city',city,'ak',ak,'output',output)
%% 圆形检索
API = 'http://api.map.baidu.com/place/v2/search';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
query = '餐饮';
radius = '10000';
location = '29.7985847901,119.697598776';
page_size = '12';
result = webread(API,'ak',ak,'query',query,'radius',radius,'location',location,'page_size',page_size )
%% xml数据获取
page_size_num=str2double(page_size); %检索得到的数据条数
name=string(page_size_num);    %创建店名字符数组
lat=zeros(1,page_size_num);    %创建经度数组
lng=zeros(1,page_size_num);    %创建纬度度数组
address=string(page_size_num);
province=string(page_size_num);
city=string(page_size_num);
area=string(page_size_num);
telephone=string(page_size_num);
detail=string(page_size_num);
uid=string(page_size_num);

getname='<name>.*?</name>';
getlat='<lat>.*?</lat>';
getlng='<lng>.*?</lng>';
getaddress='<address>.*?</address>';
getprovince='<province>.*?</province>';
getcity='<city>.*?</city>';
getarea='<area>.*?</area>';
gettelephone='<telephone>.*?</telephone>';
getdetail='<detail>.*?</detail>';
getuid='<uid>.*?</uid>';

syms i;
for i=1:page_size_num-1
name(i)=xml2str(result,getname,i)
lat(i)=xml2num(result,getlat,i)
lng(i)=xml2num(result,getlng,i)
address(i)=xml2str(result,getaddress,i)
province(i)=xml2str(result,getprovince,i)
city(i)=xml2str(result,getcity,i)
area(i)=xml2str(result,getarea,i)
telephone(i)=xml2str(result,gettelephone,i)
detail(i)=xml2str(result,getdetail,i)
uid(i)=xml2str(result,getuid,i)
string filename
% filename= {'result',int2str(i),'.mat'}
% filename= strjoin(filename)
filename='result';
save(filename,'name','lat','lng','address','province','city','area','telephone','detail','uid')
end
%% xml数据转换
clear;
load result
%% xml2
expr='<telephone>.*?</telephone>';
 xmlmatch=regexp(result,expr,'match')
