%% ��ͼ��ȡ�ͱ��
API = 'http://api.map.baidu.com/staticimage/v2';
ak = 'DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
width = 1024;
height = 1024;
center = '�㽭��ѧ�Ͻ��У��';
zoom = 17;
copyright = 1;
dpiType = 'ph';
markers = '����ѧ԰';
[a b c]= webread(API,'ak',ak,'width',width,'height',height,'center',...
    center,'zoom',zoom,'copyType',copyright,'dpiType',dpiType,...
    'markers',markers);
imshow(a,b)
%% ��γ��װ��
API = 'http://api.map.baidu.com/geocoding/v3';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
address = '�㽭��ѧ�Ͻ��У��';
city= '������';
output='xml';
result = webread(API,...
    'address',address,'city',city,'ak',ak,'output',output)
%% Բ�μ���
API = 'http://api.map.baidu.com/place/v2/search';
ak ='DhysQ5QKPqG87W7wxBv23UI8lriYq0PU';
query = '����';
radius = '10000';
location = '30.3164123616,120.089010715';
page_size = '20';
result = webread(API,'ak',ak,'query',query,'radius',radius,'location',location,'page_size',page_size )
%% xml���ݻ�ȡ
page_size_num=str2double(page_size); %�����õ�����������
syms i;
name=string(page_size_num);%���������ַ�����
lat=zeros(1,page_size_num);    %������������
lng=zeros(1,page_size_num);    %����γ�ȶ�����
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

for i=1:page_size_num
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
%% xml����ת��
clear;
load result
%% xml2
expr='<telephone>.*?</telephone>';
 xmlmatch=regexp(result,expr,'match')