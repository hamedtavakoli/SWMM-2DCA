function [ NodeOutLinkIndex ] = GetNodeOutLinkIndex( NodeTable,AllEleName)

for i=1:size(NodeTable,2)
    
    if strcmp(NodeTable{1,i},'*')==1
        v(i)=-999;
    end
    
    for j=1:size(AllEleName,2)
        if strcmp(NodeTable{1,i},AllEleName{1,j}')==1
            v(i) = j;
            break
        end
    end

end

NodeOutLinkIndex = num2cell(v);

end

