for i=1:NumberofNodeInflow
    D(i)=B(row_Output(i),col_Output(i));
end
        
for i=1:size(NodeFloodedIndex,2)
    K(i)=B(row_Inflow(i),col_Inflow(i));
end