clc;
% clear;

Rond2=28;
    
for k=1:Rond2
    disp(k);
    filename=['res_' num2str(k) '.mat'];
    load(filename, 'h' )
    if k>1
        h=cat(3,hp,h);
    end
    for i=1:size(h,1)
        for j=1:size(h,2)   
            Maxh(i,j,k)=max(tsmovavg(squeeze(h(i,j,:))', 's', 4));
        end
    end
    hp=h(:,:,end-3:end-1);
    clear h
end
MaxhT = max(Maxh,[],3);