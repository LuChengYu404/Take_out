%%
map = loadosm('map.osm') ;
%%
figure(1) ; clf ; hold on ; grid on ;
hw = find([map.ways.isHighway]) ;

figure(1)
lines=geo2xy(osmgetlines(map, hw)) ; plot(lines(1,:), lines(2,:), 'b-', 'linewidth', 1.5) ;

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
%%
S = 85;
T = 40;
[dist, route] = graphshortestpath(dg, S, T, 'Directed', true,'Method', 'Dijkstra')

xy = geo2xy(k(2:3,route));

plot(xy(1,:), xy(2,:), 'g-','linewidth', 5) ;
hold on;

%% DijkstraÀ„∑®
sb = 85;
db = 40;
dg;
[dist,mypath]=Dijkstra(dg,sb,db);

xy1 = geo2xy(k(2:3,mypath));

plot(xy1(1,:), xy1(2,:), 'g-','linewidth', 5) ;
hold on;
%% FloyedÀ„∑®
sb = 85;
db = 40;
dg;
[dist,mypath]=Floyed(dg,sb,db);

xy1 = geo2xy(k(2:3,mypath));

plot(xy1(1,:), xy1(2,:), 'g-','linewidth', 5) ;
hold on;
