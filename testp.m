    


% w2=Zm;
% w2(B==0) = NaN;
% demcmap(w2);
% mapshow(w2,Rm,'DisplayType','surface');
% camp = colormap;
%     cmin = min(Zm(Zm>0));
%     cmax = max(Zm(Zm>0));
%     C2 = round((m-1)*(w2-cmin)/(cmax-cmin));

% % % % geotiffwrite('AA1.tif',uint8(C2),camp,Rm)
    w = MaxhT;
    w(MaxhT==0) = NaN;
    w(B==0) = NaN;
%     cmin = min(w(:));
%     cmax = max(w(:));
%     ploth(1) = mapshow(w,Rm,'DisplayType','surface');
%     set(ploth(1),'FaceColor','interp','EdgeColor','interp')
%     C1 = round((m-1)*(w-cmin)/(cmax-cmin))+1;
%     C1(isnan(w))=0;
%     set(ploth(1),'CData',C1);
wa=w;
wa(isnan(w))=-9999;

save('n.txt','wa', '-ascii');
