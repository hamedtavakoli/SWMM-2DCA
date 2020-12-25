function [ value ] = GetSwmmResult2( outFile,parameters,iType,iIndex,vIndex,period )

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
  
  offset = StartPos + (period-1)*BytesPerPeriod + 2*RECORDSIZE;
  
  if ( iType == SUBCATCH )
    offset = offset + RECORDSIZE*(iIndex*SubcatchVars + vIndex);
  elseif (iType == NODE)
    offset = offset + RECORDSIZE*(SWMM_Nsubcatch*SubcatchVars + iIndex*NodeVars + vIndex);
  elseif (iType == LINK)
    offset = offset + RECORDSIZE*(SWMM_Nsubcatch*SubcatchVars + SWMM_Nnodes*NodeVars + iIndex*LinkVars + vIndex);
  elseif (iType == SYS)
    offset = offset + RECORDSIZE*(SWMM_Nsubcatch*SubcatchVars + SWMM_Nnodes*NodeVars + SWMM_Nlinks*LinkVars + vIndex);
  else
  end
  
  Fout = fopen(outFile, 'r');
%   if (Fout == NULL) return ;

  SEEK_SET = fseek(Fout, offset, 'bof');
  value = fread(Fout,1,'real*4');
  fclose(Fout);
  

end

