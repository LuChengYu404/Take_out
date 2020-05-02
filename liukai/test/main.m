%% 生成路线图
% Load an OSM file as a MATLAB structure MAP
map = loadosm('map.osm') ;

% Plot highways, buildings, and other lines
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;
%bl = find([map.ways.isBuilding]) ;

figure(1)
lines=geo2xy(osmgetlines(map, hw)) ; plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 1.5) ;
%lines=geo2xy(osmgetlines(map, bl)) ; plot(lines(1,:), lines(2,:), 'g-', 'linewidth', 0.75) ;

% plot(lines(1,380:382), lines(2,380:382), 'r-', 'linewidth', 1.5) ;
% plot(lines(1,361:371), lines(2,361:371), 'r-', 'linewidth', 1.5) ;
% plot(lines(1,381),lines(2,381),'ro')
% %plot(lines(1,369),lines(2,369),'r.')
% %plot(lines(1,b),lines(2,b),'go')

set(gca,'ydir','reverse') ;
xlabel('Web Mercator X') ;
ylabel('Web Mercator Y') ;
legend('highways') ; title('OSM in MATLAB') ;
axis equal ; box on ;

%% 数据处理

% xs = lines(1,:);
% x = unique(xs);
% for i=1:length(x)
%     disp('相同的元素')
%     disp(x(i))
%     t = xs == x(i);
% end

%%
% map = loadosm('map.osm') ;

nodes = {map.nodes.id};
nodes = horzcat(nodes{:});
nodes = double(nodes);

lats = {map.nodes.lat};
lats = horzcat(lats{:});

lons = {map.nodes.lon};
lons = horzcat(lons{:});

hw = find([map.ways.isHighway]);
ids = {map.ways(hw).nds}; 
ids = horzcat(ids{:});
ids = double(ids);
[h,c] = hist(ids,unique(ids));%unique是筛掉重复的点，h是每个点出现的次数，c是每个点的id
uids = c(h>1);%节点的id

%%
k = zeros(3,length(uids));
for i=1:length(uids)
    k(1,i) = find(nodes(:)==uids(i));
    k(2,i) = lats(k(1,i));
    k(3,i) = lons(k(1,i));
end
points = geo2xy(k(2:3,:));
plot(points(1,:), points(2,:), 'ro') ;
%%
size = length(uids);
node_map = zeros(size,size);
for i = 1:size
    for j = i:size
        for k = 1:55
        a = find(map.ways(k).nds == uids(i));
        b = find(map.ways(k).nds == uids(j));
        if a && b
            node_map(i,j) = 1;
            node_map(j,i) = 1;
        end
        end
    end
end
%% connection
map = loadosm('map.osm') ;
connectivity_matrix = sparse([]);
ways_num = size(map.ways,2);

node_ids = {map.nodes.id};
node_ids = horzcat(node_ids{:});

way_id = {map.ways.id};
way_id = horzcat(way_id{:});

for curway = 1:ways_num
    if ~map.ways(curway).isHighway
        continue;
    end
    
    % current way node set
    nodeset = map.ways(curway).nds;
    nodes_num = size(nodeset, 2);
    
    % first node id
    first_node_id = nodeset(1);
    node1_index = find(first_node_id == node_ids);
    
    % which other nodes connected to node1 ?
    curway_id = way_id(curway);
    for othernode_local_index=1:nodes_num
        othernode_id = nodeset(othernode_local_index);
        othernode_index = find(othernode_id == node_ids);

        % assume nodes are not connected
        connectivity_matrix(node1_index, othernode_index) = 0; 
        connectivity_matrix(othernode_index, node1_index) = 0;
        
        % directed graph, hence asymmetric connectivity matrix (in general)
        for otherway = 1:ways_num
            % skip same way
            otherway_id = way_id(otherway);
            if otherway_id == curway_id
                continue;
            end

            otherway_nodeset = map.ways(otherway).nds;
            idx = find(otherway_nodeset == othernode_id, 1);
            if isempty(idx) == 0
                %Nsamends = Nsamends +1;
                connectivity_matrix(node1_index, othernode_index) = 1;
                
                S = find(map.ways(curway).nds == node_ids(node1_index(1)));
                T = find(map.ways(curway).nds == node_ids(othernode_index));
                
                if S & T
                x = map.ways(curway).points(1,S:T);
                y = map.ways(curway).points(2,S:T);
                p = [x;y];
                p = geo2xy(p);
                plot(p(1,:), p(2,:), '-','linewidth', 1.5) ;
                end
                
                node1_index = [node1_index, othernode_index]

                % node1 connected to othernode
                % othernode belongs to at least one other way
                % hence othernode is an intersection
                % node1->othernode connectivity saved in connectivity_matrix
                % this suffices, ignore rest of ways through othernode
                break;
            end
        end
    end
end

for i=1:size(connectivity_matrix)
    connectivity_matrix(i, i) = 0;
end

for i=1:length(connectivity_matrix)
    for j=1:length(connectivity_matrix)
      if connectivity_matrix(i,j)==1
          connectivity_matrix(j,i)=1;
      end
    end
end
%% Dijkstra算法
n=1453;   %设置矩阵大小
temp=449;  %设置起始点
m=connectivity_matrix;%定义n阶零矩阵

m(m==0)=inf;

for i=1:n
    m(i,i)=0;
end
pb(1:length(m))=0;pb(temp)=1;%求出最短路径的点为1，未求出的为0
d(1:length(m))=0;%存放各点的最短距离
path(1:length(m))=0;%存放各点最短路径的上一点标号
while sum(pb)<n %判断每一点是否都已找到最短路径
 tb=find(pb==0);%找到还未找到最短路径的点
 fb=find(pb);%找出已找到最短路径的点
 min=inf;
 for i=1:length(fb)
     for j=1:length(tb)
         plus=d(fb(i))+m(fb(i),tb(j));  %比较已确定的点与其相邻未确定点的距离
         if((d(fb(i))+m(fb(i),tb(j)))<min)
             min=d(fb(i))+m(fb(i),tb(j));
             lastpoint=fb(i);
             newpoint=tb(j);
         end
     end
 end
 d(newpoint)=min;
 pb(newpoint)=1;
 path(newpoint)=lastpoint; %最小值时的与之连接点
end
d
path
%% Dijkstra算法2
% Load an OSM file as a MATLAB structure MAP
map = loadosm('map.osm') ;

% Plot highways, buildings, and other lines
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;
%bl = find([map.ways.isBuilding]) ;

figure(1)
lines=geo2xy(osmgetlines(map, hw)) ; plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 1.5) ;
%lines=geo2xy(osmgetlines(map, bl)) ; plot(lines(1,:), lines(2,:), 'g-', 'linewidth', 0.75) ;

% plot(lines(1,380:382), lines(2,380:382), 'r-', 'linewidth', 1.5) ;
% plot(lines(1,361:371), lines(2,361:371), 'r-', 'linewidth', 1.5) ;
% plot(lines(1,381),lines(2,381),'ro')
% %plot(lines(1,369),lines(2,369),'r.')
% %plot(lines(1,b),lines(2,b),'go')

set(gca,'ydir','reverse') ;
xlabel('Web Mercator X') ;
ylabel('Web Mercator Y') ;
legend('highways') ; title('OSM in MATLAB') ;
axis equal ; box on ;
hold on;
 

S=449
T=559
dg = connectivity_matrix
[dist, route] = graphshortestpath(dg, S, T, 'Directed', true,...
                                      'Method', 'Dijkstra');
nodes = {map.nodes.id};
nodes = horzcat(nodes{:});
nodes = double(nodes);
                                  
k = zeros(3,length(route));
for i=1:length(route)
    k(1,i) = find(nodes(:)==nodes(route(i)));
    k(2,i) = lats(k(1,i));
    k(3,i) = lons(k(1,i));
end
points = geo2xy(k(2:3,:));
plot(points(1,:), points(2,:), 'r--','linewidth', 1.5) ;                              
% [P,d] = shortestpath(connectivity_matrix,449,798)
%% Floyed算法 1
 startv = 449;
 endv = 559;
G = connectivity_matrix;
n=size(G,1);path=zeros(n);
for k=1:n
    for i=1:n
        for j=1:n
            if G(i,j)>G(i,k)+G(k,j)%%核心算法
                G(i,j)=G(i,k)+G(k,j);
                path(i,j)=k;
                k
                i
                j
            end
        end
    end
end
DisG=G;%%输出距离矩阵
Dis=G(startv,endv);
prev=path(startv,:);
prev(prev==0)=startv;%%通过path回溯
Vpath=endv;t=endv;
while t~=startv
       p=prev(t);
       Vpath=[p,Vpath]
       t=p;
end
%% Floyed算法 2
sb = 449;
db = 559;
inf=66666666;
a = connectivity_matrix;
a(a==0)=inf;
% //输入：a—邻接矩阵(aij)是指i 到j 之间的距离，可以是有向的
% //sb—起点的标号；
% //db—终点的标号
% //输出：dist—最短路的距离；
% // mypath—最短路的路径
n=size(a,1);%// 求a的行数
path=zeros(n);%//生成一个n*n的矩阵

% //遍历path矩阵中的每个元素，而其中的元素path(i,j)表示i到j最短路径上的下个节点的标号
% //初始化 path矩阵 ，将其暂设为 两节点的直接路径的下一节点
for i=1:n
  for j=1:n
    if a(i,j)~=inf  %//~=  是  != ,如果i和j之间存在路径
      path(i,j)=j; %//j 是i 的后续点
    end
  end
end

% //经过上面对path矩阵的初始化 ， 其变为：
% // 若i,j连通，则path(i,j) = j
% //否则path(i,j) = 0 ,即i,j之间不连通

for k=1:n
  for i=1:n
    for j=1:n
      if a(i,j)>a(i,k)+a(k,j)
         a(i,j)=a(i,k)+a(k,j);
          path(i,j)=path(i,k);%// 更改 i,j之间最短路径的下一个节点
          i
          j
      end
    end
  end
end
 dist=a(sb,db);
 mypath=sb;
 t=sb;
while t~=db 
% //循环结束的条件是 t 等于 db，这个循环通过迭代来求sb,db的最短路径mypath
  temp=path(t,db);
  mypath=[mypath,temp]; % // 将下一个最短路径的节点合并进去 
  t=temp;
end
%% unique nodes
nnzrows = any(connectivity_matrix, 2);
nnzcmns = any(connectivity_matrix, 1);

nnznds = nnzrows.' | nnzcmns;
intersection_node_indices = find(nnznds == 1);

figure;
    spy(connectivity_matrix);
%%
lats = {map.nodes.lat};
lats = horzcat(lats{:});

lons = {map.nodes.lon};
lons = horzcat(lons{:});

points(1,:) = lats(intersection_node_indices);
points(2,:) = lons(intersection_node_indices);
points = geo2xy(points);
plot(points(1,:), points(2,:), 'ro') ;
