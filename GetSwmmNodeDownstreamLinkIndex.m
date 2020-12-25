function [ value ] = GetSwmmNodeDownstreamLinkIndex( outFile)
    
    couner = 1;
    Fout = fopen(outFile, 'r');
    tline = fgetl(Fout);
    finP = 1;
    while ( ischar(tline) & finP==1)
        if strcmp(tline,'[CONDUITS]')
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
             value{couner,2} =  S{2};
             couner = couner + 1;
             tline = fgetl(Fout);
           case 1
             tline = fgetl(Fout);  
       end
   end
      

    fclose(Fout);
  

end

