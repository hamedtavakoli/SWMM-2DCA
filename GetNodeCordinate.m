function [ NodeCordinate ] = GetNodeCordinate( NodeTable,Cordinate)

for i=1:size(NodeTable,2)
    
    for j=1:size(Cordinate,1)
        if strcmp(NodeTable{1,i},Cordinate{j,1}')==1
            v(i,1) = Cordinate{j,2};
            v(i,2) = Cordinate{j,3};
            break
        end
    end

end

NodeCordinate = num2cell(v');

end

