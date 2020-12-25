writerObj = VideoWriter('peaks4.mp4','MPEG-4');
open(writerObj);

for k = 1:size(F,2)  
writeVideo(writerObj,F(k)); 
end

close(writerObj);