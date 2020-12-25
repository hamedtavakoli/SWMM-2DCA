
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
    
colormap([winter;gray]);
    m = 64;
    
    Rm=R;
    

    w = MaxhT+Zm;
    w(MaxhT==0) = NaN;
    w(B==0) = NaN;
    cmin = min(w(:));
    cmax = max(w(:));
    ploth(1) = mapshow(w,Rm,'DisplayType','surface');
%     set(ploth(1),'FaceColor','interp','EdgeColor','interp')
    C1 = round((m-1)*(w-cmin)/(cmax-cmin))+1;
    C1(isnan(w))=0;
    set(ploth(1),'CData',C1);
    hold on
    
    w2=Zm;
    w2(B==0) = NaN;
    ploth(2) = mapshow(w2,Rm,'DisplayType','surface');
    cmin = min(Zm(Zm>0));
    cmax = max(Zm(Zm>0));
    C2 = 64+round((m-1)*(Zm-cmin)/(cmax-cmin));
    C2(isnan(w2))=0;
    set(ploth(2),'CData',C2);
    
    
  roadspec = makesymbolspec('Line',...
                          {'Cat','0','Color','cyan','LineWidth',1}, ...
                          {'Cat','1','Color','red','LineWidth',2});
                      
   mapshow('Net\Links.shp','SymbolSpec',roadspec);
   
    hold off
    
    view(2);
    axis equal; grid on
    caxis([min(C1(:)) max(C2(:))])
    
    xlabel('X (m)','FontSize',14);
    ylabel('Y (m)','FontSize',14);
