% ----- This Code is 2D flow simulation based on Cellural Atomata (CA) ----
clc
clear

% ----- Reading Input Data ------------------------------------------------
[Zm,R] = arcgridread('et_10.txt');
[Bi,R] = arcgridread('ebz_10.txt');

Zm(isnan(Zm))=0;
Bi(Bi==0)=1;
Bi(isnan(Bi))=0;
Zm(Bi==1)=0;

% Zm(Bi==0) = NaN;
% clear Bi

[txt, val] = textread('et_10.txt','%s %f', 6);
ncols=val(1);
nrows=val(2);
xllcorner=val(3);
yllcorner=val(4);
cellsize=val(5);

% Output = csvread('Test5_dataset_2010\Test5output.csv',1,0);
% Inflow = csvread('Test5_dataset_2010\Test5BC2.csv',1,0);
% Inflow(:,1)=Inflow(:,1).*60;

% ----- Generating X & Y Cordinations (The center of cells) ---------------
Xm=xllcorner:cellsize:xllcorner+(ncols-1).*cellsize;
Xm=Xm+cellsize./2;
Ym=yllcorner+(nrows-1).*cellsize:-cellsize:yllcorner;
Ym=Ym+cellsize./2;
[Xm,Ym] = meshgrid(Xm,Ym);

% ----- Converting the Mesh Grid Size & Creating the Topographic Matrix----
% newcellsize=50;
% Xm=xllcorner:newcellsize:xllcorner+(ncols-1).*cellsize;
% Xm=Xm+newcellsize./2;
% Ym=yllcorner+(nrows-1).*cellsize:-newcellsize:yllcorner;
% Ym=Ym+newcellsize./2;
% [Xm,Ym] = meshgrid(Xm,Ym);
% Zm = interp2(X,Y,Z,Xm,Ym);
nX=size(Zm,1);
nY=size(Zm,2);
dx=cellsize;
dy=cellsize;

SWMMCA_case

% ------ Finding the Index of Position of Inflow Hydrograph----------------
  for i=1:size(NodeFloodedIndex,2)
 [val col_Inflow(i)]=min(abs(Xm(1,:)-cell2mat(NodeTable(5,NodeFloodedIndex(i)))));
 [val row_Inflow(i)]=min(abs(Ym(:,1)-cell2mat(NodeTable(6,NodeFloodedIndex(i)))));
  end



% ------ Finding the Index of Position of Output Point Results-------------
if ~(exist('NodeInflowIndex','var')==0)
    NumberofNodeInflow=size(NodeInflowIndex,2);
    for i=1:NumberofNodeInflow
    [val col_Output(i)]=min(abs(Xm(1,:)-cell2mat(NodeTable(5,NodeInflowIndex(i)))));
    [val row_Output(i)]=min(abs(Ym(:,1)-cell2mat(NodeTable(6,NodeInflowIndex(i)))));
    end
else
    NumberofNodeInflow=0;
end


% ----- Time Steps Settings------------------------------------------------
dtmin=1;
dtmax=100;
% f_lim=0;
f_lim=.0001;
% n=0.03;
%  Vmin = 0.000000001*(mean([dx dy])).^2;
 Vmin=0;

%---- e1 minimum significant water hight in a cell -----
e1 = eps;

Tsteps=1000;
Terminate=1;
LastTime=10*3600;
Rond=1;

% ----- The Start of Simulation--------------------------------------------
while Terminate==1
disp(['Rond= ' num2str(Rond) '----------------------'])   
T=(1:Tsteps).*0;
if ~(exist('laststep.mat','file')==0)
    load('laststep.mat')
else
    Tend=InitialTime;
    ht=zeros(nX,nY);
end

T(1)=Tend;
%  dtFDL=T;
%  dtDCC=T;
% Dt=T;
Outflow=zeros(Tsteps,NumberofNodeInflow+1);


% ------ Setting Manning Ceof.---------------------------------------------
n=0.04;
g=9.8;

%----- H= water head in each cell------------------------------------------
H=zeros(nX,nY);
%----- V= water volume in each cell----------------------------------------
V=zeros(nX,nY);
%----- h= water depth in each cell-----------------------------------------
h=zeros(nX,nY,Tsteps);
h(:,:,1)=ht(:,:);
%----- Q= water net discharge in each cell---------------------------------
Q =zeros(nX,nY);
Adt1 =zeros(nX,nY);
Adt2 =zeros(nX,nY);

%----- Qs= water discharge from sides -------------------------------------
Qs=zeros(nX,nY,4);
%----- B = Boundry conditions  (0=Closed cell 1=Opened cell) --------------
 B=ones(nX,nY);
 B(Zm==0)=0;
 B(1,:)=0;
 B(end,:)=0;
 B(:,1)=0;
 B(:,end)=0;
 
%----- initial water volume in each cell----------
V=h(:,:,1).*(dx*dy);
%----- initial water head in each cell----------
H = Zm + h(:,:,1);

% ----- The Start of Simulation--------------------------------------------
disp(['Start The Simulation .... Initial Time = ' num2str(T(1))])

 for t=2:Tsteps
  ht=h(:,:,t-1);
  for s=[1 3]
      for i=1:nX
          for j=1:nY
                if B(i,j)==1
                    switch s
                        case 1
                           if (B(i,j-1)==1 ...
                          && ~(ht(i,j)==0 && ht(i,j-1)==0)...
                          && ~(sign(H(i,j-1)-H(i,j))<0 && ht(i,j)<=e1)...
                          && ~(sign(H(i,j)-H(i,j-1))<0 && ht(i,j-1)<=e1)...
                          && ~((abs(H(i,j-1)-H(i,j))/dx)<f_lim))
                      
                               Qs(i,j,1)= Qij_1(H(i,j),H(i,j-1),ht(i,j),ht(i,j-1),n,dy,dx);
                           else
                               Qs(i,j,1)= 0;
                           end
                        case 2
                        case 3
                           if (B(i-1,j)==1 ...
                          && ~(ht(i,j)==0 && ht(i-1,j)==0)...
                          && ~(sign(H(i-1,j)-H(i,j))<0 && ht(i,j)<=e1)...
                          && ~(sign(H(i,j)-H(i-1,j))<0 && ht(i-1,j)<=e1)...
                          && ~((abs(H(i-1,j)-H(i,j))/dy)<f_lim))
                      
                               Qs(i,j,3)= Qij_1(H(i,j),H(i-1,j),ht(i,j),ht(i-1,j),n,dx,dy);
                           else
                               Qs(i,j,3)= 0;
                           end
                        case 4
                    end
                else
                     Qs(i,j,:)=0;
                end
          end
      end
  end
    
    
    Qs(:,1:end-1,2)= -1.*Qs(:,2:end,1);
    Qs(1:end-1,:,4)= -1.*Qs(2:end,:,3);
    
    Q = sum(Qs,3);
    
    for i=1:size(NodeFloodedIndex,2)
        Q(row_Inflow(i),col_Inflow(i)) = Q(row_Inflow(i),col_Inflow(i)) + interp1(TimeStepsInflow,Inflow(:,i),T(t-1),'linear','extrap');
    end
    
    
    for i=1:nX
        for j=1:nY
            if B(i,j)==1
                if ((sign((H(i,j)-H(i,j+1))/(Q(i,j)-Q(i,j+1)))<0) ...
                        && (B(i,j+1)==1)...
                        && ~(ht(i,j)==0 || ht(i,j+1)==0))
                    Adt1(i,j)=(abs(H(i,j)-H(i,j+1))/abs(Q(i,j)-Q(i,j+1)))*(dx*dy);
                else
                    Adt1(i,j)=0;
                end
                if ((sign((H(i,j)-H(i+1,j))/(Q(i,j)-Q(i+1,j)))<0) ...
                        && (B(i+1,j)==1)...
                        && ~(ht(i,j)==0 || ht(i+1,j)==0))
                    Adt2(i,j)=(abs(H(i,j)-H(i+1,j))/abs(Q(i,j)-Q(i+1,j)))*(dx*dy);
                else
                    Adt2(i,j)=0;
                end
            end
        end
    end
    
    k = min([min(Adt2(Adt2>0)) min(Adt1(Adt1>0))]);
    if ~isempty(k)
    dtFDL(t) = min([min(Adt2(Adt2>0)) min(Adt1(Adt1>0))]);
%      disp(['dtFDL= ' num2str(dtFDL(t))])
    else
        dtFDL(t)=NaN;
%          disp('dtFDL= No Limit')
    end

    dtDC=abs(V(Q<0)./Q(Q<0));
    
    k = min(dtDC(isfinite(dtDC)));
    if ~isempty(k)
    dtDCC(t) = min(dtDC(isfinite(dtDC)));
%      disp(['dtDCC= ' num2str(dtDCC(t))])
    else    
    dtDCC(t) = NaN;
%      disp('dtDCC= No Limit')
    end
        
    
    dt = min([max([min([dtFDL(t) dtDCC(t)]) dtmin]) dtmax]);
    if (isnan(dtFDL(t)) && isnan(dtDCC(t)))
        dt = dtmax;
    end
%     Dt(t)=dt;
    
    if ~(isempty(k))
        while (dt>k && k>0)
            ccc= (abs(Q.*dt)>V) & (Q<0);
           [indr, indc, val] = find(ccc);
             for i=1:length(indr)
                 Qp=sum((Qs(indr(i), indc(i),:)+abs(Qs(indr(i), indc(i),:)))./2);
                 Qn=sum((Qs(indr(i), indc(i),:)-abs(Qs(indr(i), indc(i),:)))./2);
                 
%                 nc = abs((V(indr(i), indc(i)).*dt-Qp)./(Qn));
% Thanks to Xing chen for this important coorection ---------------------
                  nc = abs((V(indr(i), indc(i))/*dt+Qp)./(Qn));
% -----------------------------------------------------------------------
                    if Qs(indr(i), indc(i),1)<0
                        Qs(indr(i), indc(i),1)=Qs(indr(i), indc(i),1).*nc;
                        Qs(indr(i), indc(i)-1,2)=Qs(indr(i), indc(i)-1,2).*nc;
                    end
                    if Qs(indr(i), indc(i),2)<0
                        Qs(indr(i), indc(i),2)=Qs(indr(i), indc(i),2).*nc;
                        Qs(indr(i), indc(i)+1,1)=Qs(indr(i), indc(i)+1,1).*nc;
                    end 
                    if Qs(indr(i), indc(i),3)<0
                        Qs(indr(i), indc(i),3)=Qs(indr(i), indc(i),3).*nc;
                        Qs(indr(i)-1, indc(i),4)=Qs(indr(i)-1, indc(i),4).*nc;
                    end
                    if Qs(indr(i), indc(i),4)<0
                        Qs(indr(i), indc(i),4)=Qs(indr(i), indc(i),4).*nc;
                        Qs(indr(i)+1, indc(i),3)=Qs(indr(i)+1, indc(i),3).*nc;
                    end
             end
            Q = sum(Qs,3);
            for i=1:size(NodeFloodedIndex,2)
                Q(row_Inflow(i),col_Inflow(i)) = Q(row_Inflow(i),col_Inflow(i)) + interp1(TimeStepsInflow,Inflow(:,i),T(t-1),'linear','extrap');
            end
                dtDC=abs(V(Q<0)./Q(Q<0));
                k = min(dtDC(isfinite(dtDC)));
                if (isempty(k))
                    break
                end
        end
    end

    V=Q.*dt+V;
    T(t)=T(t-1)+dt;
    
%----- calculation of return inflow to mains----------
if ~(NumberofNodeInflow==0)
        C0=1;
        A0=1;
       for i=1:NumberofNodeInflow
        QI(i)=sqrt(2*g*ht(row_Output(i),col_Output(i)))*C0*A0;
        if QI(i)*dt<=V(row_Output(i),col_Output(i))
            QI(i)=V(row_Output(i),col_Output(i))/dt;
        end
            V(row_Output(i),col_Output(i))=V(row_Output(i),col_Output(i))-QI(i)*dt;
            Outflow(t,i+1)=QI(i);
       end
end
       Outflow(t,1)=T(t);
%-------------------------------------------------

    V(V<Vmin)=0;
    
    if mod(t,10)==0
        disp(['Time= ' num2str(T(t)) ' s | Step= ' num2str(t) ' | R= ' num2str(Rond)])
    end
%      disp(['dt= ' num2str(dt)])
    
    h(:,:,t)=V./(dx*dy);
    
%     if t>=4
%        D1= sign(h(:,:,t)-h(:,:,t-1));
%        D2= sign(h(:,:,t-1)-h(:,:,t-2));
%        D3= sign(h(:,:,t-2)-h(:,:,t-3));
%            ccc= ((~D1==0|~D2==0|~D3==0) & abs(D1+D3-D2)==3);
%            [indr, indc, val] = find(ccc);
%            if ~(isempty(indr))
%                for i=1:length(indr)
%                      h(indr(i), indc(i),t)=1/2*(h(indr(i), indc(i),t)+...
%                          h(indr(i), indc(i),t-1));
%                end   
%            end   
%     end
      
    V=h(:,:,t).*(dx*dy);
    H = Zm + h(:,:,t);
    
%     QS(:,:,t)=Q;
    Q=0;
    Qs=0;
         
 end
fclose all; 
%%-------------------------------------------------------------------------------------
    ht=h(:,:,end);
    Tend=T(end);
    save('laststep.mat' , 'Tend', 'ht')
    if Tend>=LastTime
        Terminate=0;
    end
    
    filename=['res_' num2str(Rond) '.mat'];
    save(filename , 'h', 'T', 'Outflow')
    Rond=Rond+1;
    
end
Rond2=Rond-1;
showres3
