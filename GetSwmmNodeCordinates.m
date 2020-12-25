function [ value ] = GetSwmmNodeCordinates( InpFile)
    
    couner = 1;
    Fout = fopen(InpFile, 'r');
    tline = fgetl(Fout);
    finP = 1;
    while ( ischar(tline) & finP==1)
        if strcmp(tline,'[COORDINATES]')
            finP=0;
        else
        tline = fgetl(Fout);
        end
    end
 
   tline = fgetl(Fout);
  
   while ~(strcmp(tline,''))
       switch strcmp(tline(1),';')
           case 0
             S = strsplit(tline);  
             value{couner,1} =  S{1};
             value{couner,2} =  str2num(S{2});
             value{couner,3} =  str2num(S{3});
             couner = couner + 1;
             tline = fgetl(Fout);
           case 1
             tline = fgetl(Fout);  
       end
   end
      

    fclose(Fout);
  

end

