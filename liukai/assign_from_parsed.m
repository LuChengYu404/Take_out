function [bounds, node, way, relation] = assign_from_parsed(map)
% assign from parsed osm structure
%
% See also PLOT_WAY, EXTRACT_CONNECTIVITY.
%
% 2010.11.20 (c) Ioannis Filippidis, jfilippidis@gmail.com

disp('Parsed OpenStreetMap given.')

bounds = [];
node = map.nodes;
way = map.ways;
relation = []; 