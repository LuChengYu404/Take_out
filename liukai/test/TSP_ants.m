%%
map = loadosm('map.osm') ;
%%
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;

figure(1)
lines=geo2xy(osmgetlines(map, hw)) ;
plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 1.5) ;

set(gca,'ydir','reverse') ;
axis equal ; box on ;
%%
%map = loadosm('map.osm') ;

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
[h,c] = hist(ids,unique(ids));
uids = c(h>1);
%%
k = zeros(3,length(uids));
for i=1:length(uids)
    k(1,i) = find(nodes(:)==uids(i));
    k(2,i) = lats(k(1,i));
    k(3,i) = lons(k(1,i));
end
points = geo2xy(k(2:3,:));
plot(points(1,:), points(2,:), 'r.') ;

for i = 1:length(uids)
text(points(1,i),points(2,i),num2str(i),'color','r');
end
%%
dg = sparse([]);
for i = 1:length(uids)
    for j = 1:length(uids)
        for way_index = 1:55
            S = find(map.ways(way_index).nds == uids(i));
            T = find(map.ways(way_index).nds == uids(j));
            if S & T
                a = min(S,T);
                b = max(S,T);
                x = map.ways(way_index).points(1,a:b);
                y = map.ways(way_index).points(2,a:b);
                pd = geo2xy([x;y]).*1000;
                dx = diff(pd(1,:));
                dy = diff(pd(2,:));
                d = sum(sqrt(dx.^2+dy.^2));   
                dg(i,j) = d;
                dg(j,i) = d;
            end
        end
    end
end
%% 蚁群算法
% citys= [[1304,2312];[3639,1315];[4177,2244];[3712,1399];[3488,1535];[3326,1556];[3238,1229];[4196,1004];[4312,790];[4386,570];[3007,1970];[2562,1756];[2788,1491];[2381,1676];[1332,695];[3715,1678];[3918,2179];[4061,2370];[3780,2212];[3676,2578];[4029,2838];[4263,2931];[3429,1908];[3507,2367];[3394,2643];[3439,3201];[2935,3240];[3140,3550];[2545,2357];[2778,2826];[2370,2975]];
citys=points';%先用交叉点为例
V=[10 20 30 40 50 60 70 80 90 100];%选六个点
citys=citys(V,:);
%%
%距离
n = size(citys,1);
D = zeros(n,n);
for i = 1:n
    for j = 1:n
        if i ~= j
            S = V(i);
            T = V(j);
            [dist, route] = graphshortestpath(dg, S, T, 'Directed', true,'Method', 'Dijkstra');
            D(i,j) = dist;
        else
            D(i,j) = 0;
        end
    end
end
%%
m = 50;                              % 蚂蚁数量
alpha = 1;                           % 信息素重要程度因子
beta = 5;                            % 启发函数重要程度因子
rho = 0.1;                           % 信息素挥发因子
Q = 1;                               % 常系数（信息素释放量）
Eta = 1./D;                          % 启发函数
Tau = ones(n,n);                     % 信息素矩阵
Table = zeros(m,n);                  % 路径记录表
iter = 1;                            % 迭代次数初值
iter_max = 1200;                      % 最大迭代次数
Route_best = zeros(iter_max,n);      % 各代最佳路径
Length_best = zeros(iter_max,1);     % 各代最佳路径的长度
Length_ave = zeros(iter_max,1);      % 各代路径的平均长度
%%
while iter <= iter_max
    % 随机产生各个蚂蚁的起点城市
      start = zeros(m,1);
      for i = 1:m
              begin=[1];  %指定起点
    
              left=2:n;%除去起点后的数组
    
              randIndex_left = randperm(n-1);
              left = left(randIndex_left);%将poptemp随机排列

              temp = [begin left]; 
    
           start(i) = 1;
      end
      Table(:,1) = start;
      % 构建解空间
      citys_index = 1:n;
      % 逐个蚂蚁路径选择
      for i = 1:m
          % 逐个城市路径选择
         for j = 2:n
             tabu = Table(i,1:(j - 1));% 已访问的城市集合
             allow_index = ~ismember(citys_index,tabu);
             allow = citys_index(allow_index);% 待访问的城市集合
             P = allow;
             % 计算城市间转移概率
             for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
             end
             P = P/sum(P);
             % 轮盘赌法选择下一个访问城市
             Pc = cumsum(P);
            target_index = find(Pc >= rand);
            target = allow(target_index(1));
            Table(i,j) = target;
         end
      end
      % 计算各个蚂蚁的路径距离
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));
      end
      % 计算最短路径距离及平均距离
      if iter == 1
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min_Length;
          Length_ave(iter) = mean(Length);
          Route_best(iter,:) = Table(min_index,:);
      else
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min(Length_best(iter - 1),min_Length);
          Length_ave(iter) = mean(Length);
          if Length_best(iter) == min_Length
              Route_best(iter,:) = Table(min_index,:);
          else
              Route_best(iter,:) = Route_best((iter-1),:);
          end
      end
      % 更新信息素
      Delta_Tau = zeros(n,n);
      % 逐个蚂蚁计算
      for i = 1:m
          % 逐个城市计算
          for j = 1:(n - 1)
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i);
      end
      Tau = (1-rho) * Tau + Delta_Tau;
    % 迭代次数加1，清空路径记录表
    iter = iter + 1;
    Table = zeros(m,n);
end
%%
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['最短距离:' num2str(Shortest_Length)]);
disp(['最短路径:' num2str([Shortest_Route Shortest_Route(1)])]);
%%
figure(1)
plot([citys(Shortest_Route,1);citys(Shortest_Route(1),1)],...
     [citys(Shortest_Route,2);citys(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);
end
text(citys(Shortest_Route(1),1),citys(Shortest_Route(1),2),'       起点');
text(citys(Shortest_Route(end),1),citys(Shortest_Route(end),2),'       终点');
xlabel('城市位置横坐标')
ylabel('城市位置纵坐标')
title(['蚁群算法优化路径(最短距离:' num2str(Shortest_Length) ')'])
figure(2)
plot(1:iter_max,Length_best,'b',1:iter_max,Length_ave,'r:')
legend('最短距离','平均距离')
xlabel('迭代次数')
ylabel('距离')
title('各代最短距离与平均距离对比')
