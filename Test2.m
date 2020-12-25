k=1;
clear Area
TotalArea = sum(MaxhT(:)>0)*dx*dy/10000;
for i=0.01:0.001:2
Area(k)=sum(MaxhT(:)>i)*dx*dy/10000;
PArea(k)=Area(k)/TotalArea;
k=k+1;
end
plot(0.01:0.001:2,Area)
