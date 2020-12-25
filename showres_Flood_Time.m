clc;
% clear;

Rond2=28;
    
for k=1:Rond2
    disp(k);
    filename=['res_' num2str(k) '.mat'];
%     load(filename, 'h', 'T' )
%     if k>1
%         h=cat(3,hp,h);
%     end
    
            DT = T(2:end)-T(1:end-1);
            DT(end+1)=0;
            
    for i=1:size(h,1)
        for j=1:size(h,2)   
%             Maxh(i,j,k)=max(tsmovavg(squeeze(h(i,j,:))', 's', 4));
            D=(tsmovavg(squeeze(h(i,j,:))', 's', 4));
            Timh(i,j,k)=sum(DT(D>0))
        end
    end
%     hp=h(:,:,end-3:end-1);
%     clear h
end
TimeTotal = sum(Timh,[],3);