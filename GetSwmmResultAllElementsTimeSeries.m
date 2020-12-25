function [ value ] = GetSwmmResultAllElementsTimeSeries( outFile,parameters,iType,vIndex )

SUBCATCH   = 0;
NODE       = 1;
LINK       = 2;
SYS        = 3;
RECORDSIZE = 4;  

  SWMM_Nperiods  = parameters(1);
  SWMM_FlowUnits = parameters(2);
  SWMM_Nsubcatch = parameters(3);
  SWMM_Nnodes    = parameters(4);
  SWMM_Nlinks    = parameters(5);
  SWMM_Npolluts  = parameters(6);
  SWMM_StartDate = parameters(7);
  SWMM_ReportStep= parameters(8);
  SubcatchVars   = parameters(9);
  NodeVars       = parameters(10); 
  LinkVars       = parameters(11);
  SysVars        = parameters(12);
  StartPos       = parameters(13);
  BytesPerPeriod = parameters(14);
  
  switch iType
   case 0
      Nelem=SWMM_Nsubcatch;
   case 1
      Nelem=SWMM_Nnodes;
   case 2
      Nelem=SWMM_Nlinks;
   otherwise
      Nelem=-999;
  end
  
  if ~( Nelem==-999)
        Fout = fopen(outFile, 'r');
        value = zeros(SWMM_Nperiods,Nelem);  
        for j=1:Nelem
              for i=1:SWMM_Nperiods

              offset = StartPos + (i-1)*BytesPerPeriod + 2*RECORDSIZE;

          if ( iType == SUBCATCH )
            offset = offset + RECORDSIZE*((j-1)*SubcatchVars + vIndex);
          elseif (iType == NODE)
            offset = offset + RECORDSIZE*(SWMM_Nsubcatch*SubcatchVars + (j-1)*NodeVars + vIndex);
          elseif (iType == LINK)
            offset = offset + RECORDSIZE*(SWMM_Nsubcatch*SubcatchVars + SWMM_Nnodes*NodeVars + (j-1)*LinkVars + vIndex);
          elseif (iType == SYS)
            offset = offset + RECORDSIZE*(SWMM_Nsubcatch*SubcatchVars + SWMM_Nnodes*NodeVars + SWMM_Nlinks*LinkVars + vIndex);
          else
          end

              SEEK_SET = fseek(Fout, offset, 'bof');
              value(i,j) = fread(Fout,1,'real*4');
              end
        end
        fclose(Fout);
  end
  

end

