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
save result
%% xml����ת��
clear;
load result
%% xml���ݻ�ȡ
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
