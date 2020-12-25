% ----- This Code is 2D flow simulation based on Cellural Atomata (CA) ----
clc
clear

% ----- Reading Input Data ------------------------------------------------
[Zm,R] = arcgridread('et.txt');
[Bi,R] = arcgridread('ebz.txt');
Zm(Bi==0) = NaN;
clear Bi

[txt, val] = textread('et.txt','%s %f', 6);
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
% for i=1:size(Output,1)
% [val col_Output(i)]=min(abs(Xm(1,:)-Output(i,2)));
% [val row_Output(i)]=min(abs(Ym(:,1)-Output(i,3)));
% end

% ----- Time Steps Settings------------------------------------------------
save_step_h=5;
% save_step_o=30;
show_step=10;
Tsteps=20000;
dti=30;
dt=dti;
dtminn=5 ;
maxiter = 10;
Ts=(1:save_step_h:Tsteps).*0;
warn=0;
% Tso=(1:save_step_o:Tsteps).*0;

% ----- Creating Output Point Results Matrix-------------------------------
% outputres = zeros(size(Tso,2),size(Output,1));
% outputval = zeros(save_step_o,size(Output,1));

% ----- Creating h Matrix Results -----------------------------------------
hs=zeros(nX,nY,size(Ts,2));
hval=zeros(nX,nY,save_step_h);

% ------ Setting Manning Ceof.---------------------------------------------
n=0.07;

%---- e1 minimum significant water hight in a cell-------------------------
e1 = 0.00;
%---- e2 minimum ratio of water hight chenge in two time steps in a cell---
e2 = 1;
%---- e3 maximum ratio of water hight chenge in two time steps in a cell---
e3 = 1;
%---- e4 maximum water hight for ceking the volume change -----------------
e4 = dy * 0.01;

%----- H= water head in each cell------------------------------------------
H=zeros(nX,nY);
%----- V= water volume in each cell----------------------------------------
V=zeros(nX,nY);
%----- h= water depth in each cell-----------------------------------------
h=zeros(nX,nY);
%----- Q= water net discharge in each cell---------------------------------
Q =zeros(nX,nY);
%----- Qs= water discharge from sides -------------------------------------
Qs=zeros(nX,nY,5);
%----- B = Boundry conditions  (0=Closed cell 1=Opened cell) --------------
 B=zeros(nX,nY);
 B(Zm>0)=1;
 B(1,:)=0;
 B(end,:)=0;
 B(:,1)=0;
 B(:,end)=0; 
%----- initial water volume in each cell----------
V=h.*(dx*dy);
%----- initial water head in each cell----------
H = Zm + h(:,:);    
hs(:,:,1)=h;

% ----- Counter of Current Step Time---------------------------------------
T=InitialTime;
% ----- Counter of Previous Step Time--------------------------------------
Tp=0;
% ----- Counter of h Matrix Saving Results---------------------------------
ss=2;
% ----- Counter of Output Points Saving Results----------------------------
% sso=2;
% ----- Counter of Output h Matrix between tow steps-----------------------
ww1=1;
% ----- Counter of Output Points Saving Results between tow steps----------
% ww=1;

% ----- The Start of Simulation--------------------------------------------
disp(['Start The Simulation .... Initial Time = ' num2str(T)])
 for t=2:1:Tsteps
  for s=[1 3]
      for i=1:nX
          for j=1:nY
                if B(i,j)==1
                    switch s
                        case 1
                           if (B(i,j-1)==1 & ~(h(i,j)==0 & h(i,j-1)==0))
                               Qs(i,j,1)= Qij_1(H(i,j),H(i,j-1),h(i,j),h(i,j-1),n,dy,dx);
                               if (Qs(i,j,1)<0 && h(i,j)<=e1) || (Qs(i,j,1)>0 && h(i,j-1)<=e1)
                                   Qs(i,j,1)=0;
                               end
                           else
                               Qs(i,j,1)= 0;
                           end
                        case 2
                        case 3
                           if (B(i-1,j)==1 & ~(h(i,j)==0 & h(i-1,j)==0))
                           Qs(i,j,3)= Qij_1(H(i,j),H(i-1,j),h(i,j),h(i-1,j),n,dx,dy);
                           if (Qs(i,j,3)<0 && h(i,j)<=e1) || (Qs(i,j,3)>0 && h(i-1,j)<=e1)
                               Qs(i,j,3)=0;
                           end
                           else
                               Qs(i,j,3)= 0;
                           end
                        case 4
                    end
                else
%                     Qs(i,j,:)=0;
                end
          end
      end
  end

    for i=1:size(NodeFloodedIndex,2)
      Qs(row_Inflow(i),col_Inflow(i),5) = interp1(TimeStepsInflow,Inflow(:,i),T);
    end
    
    Qs(:,1:end-1,2)= -1.*Qs(:,2:end,1);
    Qs(1:end-1,:,4)= -1.*Qs(2:end,:,3);
    Qs=roundn(Qs,-3);
    
  dt=dti;
  eq=1;
  control1 = 1;
  control2 = 0;
  control3 = 0;
  
  while control3<maxiter
    control3 = control3+1;   

    Q = sum(Qs,3);
    ccc= (abs(Q.*dt)>V) & (B==1) & (Q<0);
    [indr, indc, val] = find(ccc);
    linearInd = sub2ind(size(V), indr, indc);
    
    if isempty(val)
        eq=0;
        break
    end
    
    if control3>maxiter
        break
    end
    
    if control1==1
        %ind = (B==1 & Q<0 & h>=e4); 
        %dtmin=abs(((V(ind).*e3)./Q(ind)));   
        %ind = (V>0 & B==1 & Q>0 & h>e4);    
        %dtmax=abs(((V(ind).e2)/Q(ind)));
        kd1=min(abs(((V(V>0 & B==1 & Q~=0).*e3)./Q(V>0 & B==1 & Q~=0))));
        %kd1 = min(dtmin);
        %kd2 = min(dtmax);
%         if ~(isempty(kd1))                      
            %dt=min([kd1 10]);
            dt=min([kd1 dtminn]);
            dt=roundn(dt,-3);
            %dt=min([kd1 kd2 10]);
%         end
        control1=0;
        control2=1;
        continue
    end
    
    if control2==1
        %dt = round(dt.*1000)./1000;
%         nn = ones(linearInd,1);
        nn = abs(V(linearInd)./(Q(linearInd).*dt));
        %nn(nn>1)=1;
        %nn(nn<1 & Q>0)=1;
        %ind = (Q<0 & nn<1);
        for i=1:length(indr)
                if Qs(indr(i), indc(i),1)<0
                    Qs(indr(i), indc(i),1)=Qs(indr(i), indc(i),1).*nn(i);
                    Qs(indr(i), indc(i)-1,2)=-Qs(indr(i), indc(i),1);
                end
                if Qs(indr(i), indc(i),2)<0
                    Qs(indr(i), indc(i),2)=Qs(indr(i), indc(i),2).*nn(i);
                    Qs(indr(i), indc(i)+1,2)=-Qs(indr(i), indc(i),1);
                end 
                if Qs(indr(i), indc(i),3)<0
                    Qs(indr(i), indc(i),3)=Qs(indr(i), indc(i),3).*nn(i);
                    Qs(indr(i)-1, indc(i),4)=-Qs(indr(i), indc(i),3);
                end
                if Qs(indr(i), indc(i),4)<0
                    Qs(indr(i), indc(i),4)=Qs(indr(i), indc(i),4).*nn(i);
                    Qs(indr(i)+1, indc(i),3)=-Qs(indr(i), indc(i),4);
                end
        end
%         Qs=roundn(Qs,-3);                    
     end
  end
    %eq=eq+1; 
    Q = sum(Qs,3);
%     Q=roundn(Q,-3);
    V=roundn(Q.*dt,-3)+V;
    
        if sum(sum(isnan(V)))>0
            disp('Warning..............')
            break
        end

    %     V(V<0)=0;
    if control3>=maxiter
     disp(control3)
    end 
    T=T+dt;

    warn = warn + abs(sum(sum(V(V<0.00001))));
    V(V<0.00001)=0;
    h=V./(dx*dy);
    h=roundn(h,-3);
    hm=max(max(h(h>0)));

    %       h(h<e4)=0;
    %     h= round(h.*10000)./10000; 
    H = Zm + h;
    
   if mod(t,show_step)==0
        disp(['Step= ' num2str(t) ' | Time= ' num2str(T) ' | dt= ' num2str(abs((T-Tp)./show_step)) ' | warn= ' num2str(warn) ' | h= ' num2str(hm) ]);
        Tp=T;
   end
    
% ----- Saving The Results for h Matrix -----------------------------------
    hval(:,:,ww1)=h;
    ww1=ww1+1;
     if mod(t,save_step_h)==0
         hs(:,:,ss)=mean(hval,3);
         Ts(ss)=T;
         ss=ss+1;
         ww1=1;
     end
     
% ----- Saving The Results for Output Points ------------------------------
%      for i=1: size(Output,1)
%      outputval(ww,i)=h(row_Output(i),col_Output(i));
%      end
%      ww=ww+1;
%      if mod(t,save_step_o)==0
%          outputres(sso,:)=mean(outputval);
%          Tso(sso)=T;
%          sso=sso+1;
%          ww=1;
%          outputval=outputval.*0;
%      end
     
     Qs = Qs .* 0;
         
 end

 showres3