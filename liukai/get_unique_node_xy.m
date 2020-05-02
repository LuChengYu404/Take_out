function [intersection_nodes] = ...
                    get_unique_node_xy(map, intersection_node_indices)
% get the x,y coordinates of unique nodes at road intersections
%
% 2010.11.20 (c) Ioannis Filippidis, jfilippidis@gmail.com

ids = map.nodes.id(:, intersection_node_indices);
xys = map.nodes.id(:, intersection_node_indices);

intersection_nodes.id = ids;
intersection_nodes.xys = xys;
