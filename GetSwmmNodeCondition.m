function [ value ] = GetSwmmNodeCondition( InpFile)
    
    couner = 1;
    Fout = fopen(InpFile, 'r');
    tline = fgetl(Fout);
    finP = 1;
    while ( ischar(tline) & finP==1)
        if strcmp(tline,'[JUNCTIONS]')
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
             if strcmp(S{1}(1:3),'In_')
                value{couner,1} =  1;
             else
                value{couner,1} =  0;
             end
             value{couner,2} =  S{1};
             couner = couner + 1;
             tline = fgetl(Fout);
           case 1
             tline = fgetl(Fout);  
       end
   end
      

    fclose(Fout);
  

end

