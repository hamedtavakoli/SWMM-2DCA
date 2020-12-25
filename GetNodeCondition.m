function [ NodeCondition ] = GetNodeCondition( NodeTable,InFlowCondition)

for i=1:size(NodeTable,2)
    
    for j=1:size(InFlowCondition,1)
        dum = 0;
        if strcmp(NodeTable{1,i}',InFlowCondition{j,2})==1
            v(i) = InFlowCondition(j,1);
            dum = 1;
            break
        end
    end
    if dum==0
        v{i}=0;
    end

end

NodeCondition = v';

end

