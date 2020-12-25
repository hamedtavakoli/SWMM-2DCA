clear F
fig=figure;
% Blue=cool;
% Blue(:,1)=0;
% Blue(:,2)=0;
% Blue(:,3)=1/64:1/64:1;
%     cmin = min(w(:));
%     cmax = max(w(:));
%     C1 = min(m,round((m-1)*(w-cmin)/(cmax-cmin))+1);
%     C1(C1<1)=1;
%     cmin = min(Zm(:));
%     cmax = max(Zm(:));
%     C2 = min(m,round((m-1)*(w-cmin)/(cmax-cmin))+1);
%     C2(C2<1)=1;
%     C2 = 64+C2;
    rwinter=winter;
    rwinter(1:end,:)=rwinter(end:-1:1,:);
     rwinter=winter;
    
k=1;
colormap([rwinter;demcmap(64)]);
    m = 64;
    cmin = min(Zm(Zm>0));
    cmax = max(Zm(Zm>0));
    C2 = 64+min(m,round((m-1)*(Zm-cmin)/(cmax-cmin))+1);
    
    cmin=0;
    cmax = 5;
    
%     Rm = [0 -newcellsize; newcellsize 0; Xm(1,1) Ym(1,1)];
    Rm=R;
    Rond=1;
    Rond2=28;
    
for j=1:Rond2    
    filename=['res_' num2str(j) '.mat'];
    load(filename )
    Rond=Rond+1;
     
for t=1:50:size(T,2)

%     w=Zm+h(:,:,t);
    w=(h(:,:,t)+h(:,:,t+1)+h(:,:,t+2)+h(:,:,t+3))./4+Zm(:,:);
   
    w(h(:,:,t)==0)=NaN;
    w(B==0)=NaN;
    
    w2=Zm;
    w2(Zm(:,:)==0)=NaN;
    w2(B==0) = NaN;

    
    ploth(1) = mapshow(w,Rm,'DisplayType','surface');
    set(ploth(1),'FaceColor','interp','EdgeColor','interp')
    C1 = min(m,round((m-1)*((w-Zm)-cmin)/(cmax-cmin))+1);
    C1(isnan(w))=0;
%     C1(C1<1)=1;
    set(ploth(1),'CData',C1);
    hold on
    
    ploth(2) = mapshow(w2/3,Rm,'DisplayType','surface');
    set(ploth(2),'CData',C2);
    hold off
    
    view(2);
    axis equal; grid on
    caxis([min(C1(:)) max(C2(:))])
    
    hr=fix(T(t)/3600);
    mint=fix(mod(T(t),3600)/60);
    sec=mod(T(t),60);
    title(['T= ' num2str(hr) ':' num2str(mint) ':' num2str(round(sec))],'FontWeight','bold','FontSize',20)
    xlabel('X (m)','FontSize',14);
    ylabel('Y (m)','FontSize',14);

    F(k)=getframe(fig);
    k=k+1;
end
clear h
end