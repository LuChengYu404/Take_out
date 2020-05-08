function [dist,mypath]=Floyed(dg,sb,db)
inf=66666666;
a = dg;
a(a==0)=inf;
% //���룺a���ڽӾ���(aij)��ָi ��j ֮��ľ��룬�����������
% //sb�����ı�ţ�
% //db���յ�ı��
% //�����dist�����·�ľ��룻
% // mypath�����·��·��
n=size(a,1);%// ��a������
path=zeros(n);%//����һ��n*n�ľ���

% //����path�����е�ÿ��Ԫ�أ������е�Ԫ��path(i,j)��ʾi��j���·���ϵ��¸��ڵ�ı��
% //��ʼ�� path���� ����������Ϊ ���ڵ��ֱ��·������һ�ڵ�
for i=1:n
  for j=1:n
    if a(i,j)~=inf  %//~=  ��  != ,���i��j֮�����·��
      path(i,j)=j; %//j ��i �ĺ�����
    end
  end
end

% //���������path����ĳ�ʼ�� �� ���Ϊ��
% // ��i,j��ͨ����path(i,j) = j
% //����path(i,j) = 0 ,��i,j֮�䲻��ͨ

for k=1:n
  for i=1:n
    for j=1:n
      if a(i,j)>a(i,k)+a(k,j)
         a(i,j)=a(i,k)+a(k,j);
          path(i,j)=path(i,k);%// ���� i,j֮�����·������һ���ڵ�
      end
    end
  end
end
 dist=a(sb,db);
 mypath=sb;
 t=sb;
while t~=db 
% //ѭ�������������� t ���� db�����ѭ��ͨ����������sb,db�����·��mypath
  temp=path(t,db);
  mypath=[mypath,temp]; % // ����һ�����·���Ľڵ�ϲ���ȥ 
  t=temp;
end