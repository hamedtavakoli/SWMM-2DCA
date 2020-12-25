Rond=1;
TotalOutflow=zeros(1,NumberofNodeInflow);
TotalT=0;

for j=1:Rond2    
    filename=['res_' num2str(j) '.mat'];
    load(filename,'Outflow')
    Rond=Rond+1;     
    TotalOutflow=[TotalOutflow ; Outflow(2:end,2:end)];
    TotalT=[TotalT ; Outflow(2:end,1)];
    clear Outflow
end

TStandard = 0:60:TotalT(end);

TotalOutflowStandard = interp1(TotalT,TotalOutflow,TStandard,'linear','extrap');

hr=fix(TStandard/3600);
mint=fix(mod(TStandard,3600)/60);
sec=mod(TStandard,60);


for i=1:NumberofNodeInflow
    filename=['TSInflow_' NodeTable{1,NodeInflowIndex(i)}' '.dat'];
    Fout = fopen(filename, 'w');
    for j=1:size(TStandard,2)
        TimingTxt=[num2str(hr(j)) ':' num2str(mint(j)) ':' num2str(round(sec(j)))];
        FlowTxt= num2str(TotalOutflowStandard(j,i));
        fprintf(Fout,'%s\t%s\n',TimingTxt,FlowTxt);
    end
    fclose(Fout);
end

%---------Creating new inp File -------------------------------------------
    CheckInflowTag=0;
    FoutR = fopen(INPFileName, 'r');
    NewInpFile=['N_' INPFileName];
    FoutW = fopen(NewInpFile, 'w');
    
%--------Check if there is any INFLOW section in inp file------------------ 
    tline = fgetl(FoutR);
    while ischar(tline)
        if strcmp(tline,'[INFLOWS]')
            CheckInflowTag=1;
            break
        end
        tline = fgetl(FoutR);
    end
    fseek(FoutR, 0, 'bof');        
%--------------------------------------------------------------------------
    
    tline = fgetl(FoutR);
    finP = 0;
    finP2 = 0;
    
switch CheckInflowTag
    %------The inp file dose not have any INFLOW section-------------------
    case  0
        while ischar(tline)
            if strcmp(tline,'[TIMESERIES]')
                finP = 1;
                fprintf(FoutW,'%s\n','[INFLOWS]');
                fprintf(FoutW,'%s\n',';;Node           Constituent      Time Series      Type     Mfactor  Sfactor  Baseline Pattern');
                fprintf(FoutW,'%s\n',';;-------------- ---------------- ---------------- -------- -------- -------- -------- --------');
                for i=1:NumberofNodeInflow
                    TimingTxt1=NodeTable{1,NodeInflowIndex(i)}';
                    TimingTxt2='FLOW';
                    TimingTxt3=['TSInflow_' NodeTable{1,NodeInflowIndex(i)}'];
                    TimingTxt4='FLOW';
                    TimingTxt5='1.0';
                    fprintf(FoutW,'%s\t%s\t%s\t%s\t%s\t%s\n',TimingTxt1,TimingTxt2,TimingTxt3,TimingTxt4,TimingTxt5,TimingTxt5);
                end
                fprintf(FoutW,'\n');
            end
            if finP == 1
                if isempty(tline)
                    finP = 0;
                    for i=1:NumberofNodeInflow
                        TimingTxt1=';';
                        TimingTxt2=['TSInflow_' NodeTable{1,NodeInflowIndex(i)}'];
                        TimingTxt3=['FILE "' 'TSInflow_' NodeTable{1,NodeInflowIndex(i)}' '.dat' '"'];
                        fprintf(FoutW,'%s\n%s\n%s\t%s\n',TimingTxt1,TimingTxt1,TimingTxt2,TimingTxt3);
                    end
                end
            end
            fprintf(FoutW,'%s\n',tline);
            tline = fgetl(FoutR);
        end
    %------The inp file have INFLOW section already------------------------    
    case  1
        while ischar(tline)
            if strcmp(tline,'[INFLOWS]')
                finP = 1;
            end
            if strcmp(tline,'[TIMESERIES]')
                finP2 = 1;
            end
            if finP == 1 
                if isempty(tline)
                    finP = 0;
                    for i=1:NumberofNodeInflow
                        TimingTxt1=NodeTable{1,NodeInflowIndex(i)}';
                        TimingTxt2='FLOW';
                        TimingTxt3=['TSInflow_' NodeTable{1,NodeInflowIndex(i)}'];
                        TimingTxt4='FLOW';
                        TimingTxt5='1.0';
                        fprintf(FoutW,'%s\t%s\t%s\t%s\t%s\t%s\n',TimingTxt1,TimingTxt2,TimingTxt3,TimingTxt4,TimingTxt5,TimingTxt5);
                    end
                fprintf(FoutW,'\n');
                end
            end
            if finP2 == 1
                if isempty(tline)
                    finP2 = 0;
                    for i=1:NumberofNodeInflow
                        TimingTxt1=';';
                        TimingTxt2=['TSInflow_' NodeTable{1,NodeInflowIndex(i)}'];
                        TimingTxt3=['FILE "' 'TSInflow_' NodeTable{1,NodeInflowIndex(i)}' '.dat' '"'];
                        fprintf(FoutW,'%s\n%s\n%s\t%s\n',TimingTxt1,TimingTxt1,TimingTxt2,TimingTxt3);
                    end
                end
            end
            fprintf(FoutW,'%s\n',tline);
            tline = fgetl(FoutR);
         end   
end     

    fclose(FoutW);
    fclose(FoutR);