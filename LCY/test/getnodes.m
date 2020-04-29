function [x,y] = getnodes(map)
    lines = {map.ways.points}; 
    lines = horzcat(lines{:});
    x = lines(1,:);
    y = lines(1,:);
end