% ----- This Code is 2D flow simulation based on Cellural Atomata (CA) ----
clc
clear

% ----- Reading Input Data ------------------------------------------------
[Z,R] = arcgridread('Test5_dataset_2010\Test5DEM.asc');
[txt, val] = textread('Test5_dataset_2010\Test5DEM.asc','%s %f', 6);
ncols=val(1);
nrows=val(2);
xllcorner=val(3);
yllcorner=val(4);
cellsize=val(5);
Output = csvread('Test5_dataset_2010\Test5output.csv',1,0);
Inflow = csvread('Test5_dataset_2010\Test5BC2.csv',1,0);
Inflow(:,1)=Inflow(:,1).*60;

% ----- Generating X & Y Cordinations (The center of cells) ---------------
X=xllcorner:cellsize:xllcorner+(ncols-1).*cellsize;
X=X+cellsize./2;
Y=yllcorner+(nrows-1).*cellsize:-cellsize:yllcorner;
Y=Y+cellsize./2;
[X,Y] = meshgrid(X,Y);

% ----- Converting the Mesh Grid Size & Creating the Topographic Matrix----
newcellsize=50;
Xm=xllcorner:newcellsize:xllcorner+(ncols-1).*cellsize;
Xm=Xm+newcellsize./2;
Ym=yllcorner+(nrows-1).*cellsize:-newcellsize:yllcorner;
Ym=Ym+newcellsize./2;
[Xm,Ym] = meshgrid(Xm,Ym);
Zm = interp2(X,Y,Z,Xm,Ym);
nX=size(Zm,1);
nY=size(Zm,2);
dx=newcellsize;
dy=newcellsize;

% ------ Finding the Index of Position of Inflow Hydrograph----------------
[val col_Inflow]=min(abs(Xm(1,:)-232690));
[val row_Inflow]=min(abs(Ym(:,1)-830385));

% ------ Finding the Index of Position of Output Point Results-------------
for i=1:size(Output,1)
[val col_Output(i)]=min(abs(Xm(1,:)-Output(i,2)));
[val row_Output(i)]=min(abs(Ym(:,1)-Output(i,3)));
end

% ----- Time Steps Settings------------------------------------------------
save_step_h=60;
save_step_o=30;
show_step=100;
Tsteps=5000;
dt=1;
Ts=(1:save_step_h:Tsteps).*0;
Tso=(1:save_step_o:Tsteps).*0;

% ----- Creating Output Point Results Matrix-------------------------------
outputres = zeros(size(Tso,2),size(Output,1));
outputval = zeros(save_step_o,size(Output,1));

% ----- Creating h Matrix Results -----------------------------------------
hs=zeros(nX,nY,size(Ts,2));
hval=zeros(nX,nY,save_step_h);

% ------ Setting Manning Ceof.---------------------------------------------
n=0.04;

%---- e1 minimum significant water hight in a cell-------------------------
e1 = 0.00;
%---- e2 minimum ratio of water hight chenge in two time steps in a cell---
e2 = 1;
%---- e3 maximum ratio of water hight chenge in two time steps in a cell---
e3 = 1;
%---- e4 maximum water hight for ceking the volume change -----------------
e4 = 0.01;

%----- H= water head in each cell------------------------------------------
H=zeros(nX,nY);
%----- V= water volume in each cell----------------------------------------
V=zeros(nX,nY);
%----- h= water depth in each cell-----------------------------------------
h=zeros(nX,nY);
%----- Q= water net discharge in each cell---------------------------------
Q =zeros(nX,nY);
%----- Qs= water discharge from sides -------------------------------------
Qs=zeros(nX,nY,4);
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
T=0;
% ----- Counter of Previous Step Time--------------------------------------
Tp=0;
% ----- Counter of h Matrix Saving Results---------------------------------
ss=2;
% ----- Counter of Output Points Saving Results----------------------------
sso=2;
% ----- Counter of Output h Matrix between tow steps-----------------------
ww1=1;
% ----- Counter of Output Points Saving Results between tow steps----------
ww=1;

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
  
    Qs(:,1:end-1,2)= -1.*Qs(:,2:end,1);
    Qs(1:end-1,:,4)= -1.*Qs(2:end,:,3);

    Q = sum(Qs,3);
    
    Q(row_Inflow,col_Inflow) = Q(row_Inflow,col_Inflow) + interp1(Inflow(:,1),Inflow(:,2),T);
    
    ind = (V>0 & B==1 & Q<0 & h>e4); 
    dtmin=abs(((V(ind).*e3)./Q(ind)));   
%     ind = (V>0 & B==1 & Q>0 & h>e4);    
%     dtmax=abs(((V(ind).e2)/Q(ind)));

    kd1 = min(dtmin);
%     kd2 = min(dtmax);

     if ~(isempty(kd1))                      
         dt=min([kd1 10]);
%          dt=min([kd1 kd2 10]);
     end

    dt = round(dt.*100)./100; 
    V=Q.*dt+V;
    V(V<0)=0;
    T=T+dt;
    
    if mod(t,show_step)==0
        disp(['Step= ' num2str(t) ' | Time= ' num2str(T) ' | dt= ' num2str(abs((T-Tp)./show_step))]);
        Tp=T;
    end
        
    h=V./(dx*dy);
    h(h<=0.01)=0;
    h= round(h.*100)./100; 
    H = Zm + h;
    
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
     for i=1: size(Output,1)
     outputval(ww,i)=h(row_Output(i),col_Output(i));
     end
     ww=ww+1;
     if mod(t,save_step_o)==0
         outputres(sso,:)=mean(outputval);
         Tso(sso)=T;
         sso=sso+1;
         ww=1;
         outputval=outputval.*0;
     end
     
     Qs = Qs .* 0;
         
 end

 showres3