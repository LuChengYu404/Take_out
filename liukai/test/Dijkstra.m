function [dist,mypath]=Dijkstra(dg,sb,db);
n=length(dg);   %���þ����С
temp=sb;  %������ʼ��
m=dg;%����n�������

inf=66666666;
m(m==0)=inf;

for i=1:n
    m(i,i)=0;
end
pb(1:length(m))=0;pb(temp)=1;%������·���ĵ�Ϊ1��δ�����Ϊ0
d(1:length(m))=0;%��Ÿ������̾���
path(1:length(m))=0;%��Ÿ������·������һ����
while sum(pb)<n %�ж�ÿһ���Ƿ����ҵ����·��
 tb=find(pb==0);%�ҵ���δ�ҵ����·���ĵ�
 fb=find(pb);%�ҳ����ҵ����·���ĵ�
 min=inf;
 for i=1:length(fb)
     for j=1:length(tb)
         plus=d(fb(i))+m(fb(i),tb(j));  %�Ƚ���ȷ���ĵ���������δȷ����ľ���
         if((d(fb(i))+m(fb(i),tb(j)))<min)
             min=d(fb(i))+m(fb(i),tb(j));
             lastpoint=fb(i);
             newpoint=tb(j);
         end
     end
 end
 d(newpoint)=min;
 pb(newpoint)=1;
 path(newpoint)=lastpoint; %��Сֵʱ����֮���ӵ�
end
d
path



 dist=d(db);
 i=1
 while db~=sb
    mypath(i)=db;
    db=path(db);
    i=i+1;
 end
mypath(i)=sb;

mypath=fliplr(mypath);
