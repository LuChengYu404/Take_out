%% ��ͼ��ȡ�ͱ��
API = 'http://api.map.baidu.com/staticimage/v2';
ak = 'xklhuM4icGZ4y2sBdBreUnMusfZm9zFT';
width = 1024;
height = 1024;
center = 'ͩ®��';
zoom = 18;
copyright = 1;
dpiType = 'ph';
[a b c] = webread(API,'ak',ak,'width',width,'height',height,'center',...
    center,'zoom',zoom,'copyType',copyright,'dpiType',dpiType);

imshow(a,b)

%% Բ�ļ���
clear;
clc;
API = 'http://api.map.baidu.com/place/v2/search';
ak = 'xklhuM4icGZ4y2sBdBreUnMusfZm9zFT';
query = '����';
radius = '1000';
page_size = '20';
location = '29.79858479014279,119.69759877582668';
result = webread(API,'ak',ak,'location',location,'query',query,'radius',radius,'page_size',page_size)
% result = webread('http://api.map.baidu.com/place/v2/search?query=����&location=39.915,116.404&radius=2000&output=xml&ak=xklhuM4icGZ4y2sBdBreUnMusfZm9zFT');
%% ��γ�Ȳ�ѯ
API = 'http://api.map.baidu.com/geocoding/v3';
address = 'ͩ®��';
ak ='xklhuM4icGZ4y2sBdBreUnMusfZm9zFT';
output='json';
callback = 'showLocation';
result = webread(API,...
    'address',address,'ak',ak,'output',output,'callback',callback)
