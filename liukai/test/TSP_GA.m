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
%% GA算法
tStart = tic; % 算法计时器
 
%%%%%%%%%%%%自定义参数%%%%%%%%%%%%%

cities=points;%先用交叉点为例
V=[10 20 30 40 50 60 70 80 90 100];%选六个点
cities=cities(:,V);
cityNum=length(cities);

% [cityNum,cities] = Read('dsj1000.tsp');
% cities=cities'

%cityNum = 100;
maxGEN = 500;
popSize = 100; % 遗传算法种群大小
crossoverProbabilty = 0.9; %交叉概率
mutationProbabilty = 0.1; %变异概率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
gbest = Inf;
% 随机生成城市位置
%cities = rand(2,cityNum) * 100;%100是最远距离
 
% 计算上述生成的城市距离
% distances = calculateDistance(cities);

n = size(cities,2);
distances = zeros(n,n);
 for i = 1:n
    for j = 1:n
        if i ~= j
            S = V(i);
            T = V(j);
            [dist, route] = graphshortestpath(dg, S, T, 'Directed', true,'Method', 'Dijkstra');
            distances(i,j) = dist;
        else
            distances(i,j) = 0;
        end
    end
end
 
% 生成种群，每个个体代表一个路径
pop = zeros(popSize, cityNum);
for i=1:popSize
    begin=[1]; %先提取起点
    
    poptemp=2:cityNum;%除去起点后的数组
    
    randIndex_poptemp = randperm(cityNum-1);
    poptemp = poptemp(randIndex_poptemp);%将poptemp随机排列

    pop(i,:) = [begin poptemp]; 
    
   % pop(i,:) = randperm(cityNum); 
end
offspring = zeros(popSize,cityNum);
%保存每代的最小路劲便于画图
minPathes = zeros(maxGEN,1);
 
% GA算法
for  gen=1:maxGEN
 
    % 计算适应度的值，即路径总距离
    [fval, sumDistance, minPath, maxPath] = fitness(distances, pop);
 
    % 轮盘赌选择
    tournamentSize=4; %设置大小
    for k=1:popSize
        % 选择父代进行交叉
        tourPopDistances=zeros( tournamentSize,1);
        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end
 
        % 选择最好的，即距离最小的
        parent1  = min(tourPopDistances);
        [parent1X,parent1Y] = find(sumDistance==parent1,1, 'first');
        parent1Path = pop(parent1X(1,1),:);
        parent1Path = parent1Path([2:length(parent1Path)]);
 
        for i=1:tournamentSize
            randomRow = randi(popSize);
            tourPopDistances(i,1) = sumDistance(randomRow,1);
        end
        parent2  = min(tourPopDistances);
        [parent2X,parent2Y] = find(sumDistance==parent2,1, 'first');
        parent2Path = pop(parent2X(1,1),:);
        parent2Path = parent2Path([2:length(parent2Path)]);
 
        subPath = crossover(parent1Path, parent2Path, crossoverProbabilty);%交叉
        subPath = mutate(subPath, mutationProbabilty);%变异
        subPath = [begin subPath];
 
        offspring(k,:) = subPath(1,:);
        
        minPathes(gen,1) = minPath; 
    end
    fprintf('代数:%d   最短路径:%.2fKM \n', gen,minPath);
    % 更新
    pop = offspring;
    % 画出当前状态下的最短路径
    if minPath < gbest
        gbest = minPath;
        paint(cities, pop, gbest, sumDistance,gen);
    end
end
figure 
plot(minPathes, 'MarkerFaceColor', 'red','LineWidth',1);
title('收敛曲线图（每一代的最短路径）');
set(gca,'ytick',500:100:5000); 
ylabel('路径长度');
xlabel('迭代次数');
grid on
tEnd = toc(tStart);
fprintf('时间:%d 分  %f 秒.\n', floor(tEnd/60), rem(tEnd,60));