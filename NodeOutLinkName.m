function [ NodeOutLinkName ] = GetNodeOutLinkName( NodeTable,LinkUpNodeName)

for i=1:size(NodeTable,2)
    for j=1:size(LinkUpNodeName,1)
        dum = 0;
        if strcmp(NodeTable(1,i),LinkUpNodeName(j,2))==1
            v{i}=LinkUpNodeName(j,1);
            dum = 1;
            break
        end
    end
    if dum==0
        v{i}='*';
    end
end

NodeOutLinkName = v;

end

