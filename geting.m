clear
a = 'swmm5.exe watereyd.inp watereyd.rpt watereyd.out';
d = 'watereyd.out';
c = RunSwmmExe(a);

k = OpenSwmmOutFile(d);

  SWMM_Nperiods  = k(1);
  SWMM_FlowUnits = k(2);
  SWMM_Nsubcatch = k(3);
  SWMM_Nnodes    = k(4);
  SWMM_Nlinks    = k(5);
  SWMM_Npolluts  = k(6);
  SWMM_StartDate = k(7);
  SWMM_ReportStep= k(8);
  SubcatchVars   = k(9);
  NodeVars       = k(10); 
  LinkVars       = k(11);
  SysVars        = k(12);
  StartPos       = k(13);
  BytesPerPeriod = k(14);

swmm_code
  
iType=swmm.Links;
vIndex=swmm.link.filledfrac;
iIndex=0;

clear value
%  value = GetSwmmResultTimeSeries(d,k,iType,iIndex,vIndex);
 value = GetSwmmResultAllElementsTimeSeries(d,k,iType,vIndex);
% for j=0:SWMM_Nlinks-1
%   for i=0:SWMM_Nperiods-1
%      value(i+1,j+1) = GetSwmmResult2(d,k,iType,j,vIndex,i);
%   end
% end
%    plot(0:SWMM_ReportStep:SWMM_Nperiods.*SWMM_ReportStep-1,value);
%    xlabel('Time (s)')
%    ylabel(['Unit ('  Unit(SWMM_FlowUnits+1,:)  ')']);
%    hold on
% end

% plot(0:SWMM_ReportStep:SWMM_Nperiods.*SWMM_ReportStep-1,value);
% xlabel('Time (s)')
% ylabel(['Unit ('  Unit(SWMM_FlowUnits+1,:)  ')']);
 plot(value)
