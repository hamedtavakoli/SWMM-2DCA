% clc
% clear

CamandLine = 'swmm5.exe T6.inp T6.rpt T6.out';
OutputFileName = 'T6.out';
INPFileName = 'T6.inp';
% c = RunSwmmExe(CamandLine);
c = system(CamandLine);
k = OpenSwmmOutFile(OutputFileName);

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

AllEleName = GetSwmmElementsName(OutputFileName);
ConduteUpNode = GetSwmmNodeDownstreamLinkIndex(INPFileName);
NodeTable = AllEleName(SWMM_Nsubcatch+1:SWMM_Nsubcatch+SWMM_Nnodes);
NodeTable(2,:) = num2cell(1:SWMM_Nnodes);
NodeTable(3,:) = GetNodeOutLinkName(NodeTable,ConduteUpNode);
NodeTable(4,:) = GetNodeOutLinkIndex(NodeTable(3,:),AllEleName(SWMM_Nsubcatch+SWMM_Nnodes+1:end));
Cordinate = GetSwmmNodeCordinates(INPFileName);
NodeTable(5:6,:) = GetNodeCordinate(NodeTable,Cordinate);
InFlowCondition = GetSwmmNodeCondition(INPFileName);
NodeTable(7,:) = GetNodeCondition(NodeTable,InFlowCondition);

iType=swmm.Nodes;
vIndex=swmm.node.flooding;

 clear value
 value = GetSwmmResultAllElementsTimeSeries(OutputFileName,k,iType,vIndex);
 
 k=1;
  for i=1:size(value,2)
      if sum(value(:,i))>0
          NodeFloodedIndex(k) = i;
          k=k+1;
      end
  end
  
Inflow = value(:,NodeFloodedIndex);
TimeStepsInflow=(0:SWMM_ReportStep:(SWMM_Nperiods-1)*SWMM_ReportStep)';
  for i=1:size(Inflow,2)
      if sum(Inflow(i,:))>0
          InitialTimeStep=i;
          InitialTime=TimeStepsInflow(i);
        break
      end
  end
  
Inflow = Inflow(InitialTimeStep:end,:);
TimeStepsInflow=TimeStepsInflow(InitialTimeStep:end,:);

 k=1;
  for i=1:size(NodeTable,2)
      if NodeTable{7,i}==1
          NodeInflowIndex(k) = i;
          k=k+1;
      end
  end

