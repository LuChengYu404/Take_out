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

%% 生成路线图
% Load an OSM file as a MATLAB structure MAP
map = loadosm('map.osm') ;

% Plot highways, buildings, and other lines
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ; 
% bl = find([map.ways.isBuilding]) ;
% ot = setdiff(1:numel(map.ways), [hw, bl]) ;

lines=geo2xy(osmgetlines(map, hw)) ; plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 1.5) ;
% lines=geo2xy(osmgetlines(map, bl)) ; plot(lines(1,:), lines(2,:), 'g-', 'linewidth', 0.75) ;
% lines=geo2xy(osmgetlines(map, ot)) ; plot(lines(1,:), lines(2,:), 'k-', 'linewidth', 0.5) ;

set(gca,'ydir','reverse') ;
xlabel('Web Mercator X') ;
ylabel('Web Mercator Y') ;
legend('highways', 'building', 'other') ; title('OSM in MATLAB') ;
axis equal ; box on ;
%%
[connectivity_matrix, intersection_node_indices] = extract_connectivity(map)
intersection_nodes = get_unique_node_xy(map, intersection_node_indices)
%%
[m,siz] = size(map.nodes);
node_map = zeros(siz,siz);
for i= 1:siz
    for j=1:siz
        for k=1:32
            a=find(map.ways(k).nds==map.nodes.id);
            b=find(map.ways(k).nds==map.nodes.id);
            if a & b
                node_map(i,j)=1;
                node_map(j,i)=1;
            end
        end
    end
end
%% 批量算路
API = 'http://api.map.baidu.com/routematrix/v2/riding?';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
origins = 	'29.7985847901,119.697598776'%起点坐标串。坐标格式为：
% 纬度,经度|纬度,经度。示例：40.056878,116.30815|40.063597,116.364973	string	是
% destinations	终点坐标串	string	是
% tactics	
% 驾车、摩托车可设置，其他无需设置。该服务为满足性能需求，不含道路阻断信息干预。
% 
% 驾车偏好选择，可选值如下：
% 10： 不走高速；
% 11：常规路线，即多数用户常走的一条经验路线，满足大多数场景需求，是较推荐的一个策略
% 12： 距离较短（考虑路况）：即距离相对较短的一条路线，但并不一定是一条优质路线。计算耗时时，考虑路况对耗时的影响；
% 13： 距离较短（不考虑路况）：路线同以上，但计算耗时时，不考虑路况对耗时的影响，可理解为在路况完全通畅时预计耗时。 
% 注：除13外，其他偏好的耗时计算都考虑实时路况
% 
% 摩托车偏好选择，可选值如下：
% 10： 不走高速；
% 11： 最短时间；
% 12： 距离较短。
% 
% string	否，默认为13：最短距离（不考虑路况）
% riding_type	电动车、自行车骑行可设置，其他无需设置。骑行类型，筛选普通自行车、电动自行车骑行
% 可选值：0 普通自行车 1 电动自行车	string	否，默认为0
% output	表示输出类型，可设置为xml或json。	string	否，默认为json
% coord_type
% result = webread(API,'ak',ak,'query',query,'radius',radius,'location',location,'page_size',page_size )