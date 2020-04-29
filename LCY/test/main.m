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
%map = loadosm('map.osm') ;
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
