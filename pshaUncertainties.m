% clear all; close all;clc;format short e
% 
PGAREF=[0.50000E-02;0.70000E-02;0.98000E-02;0.13700E-01;0.19200E-01;0.26900E-01;...
0.37600E-01;0.52700E-01;0.73800E-01;0.10300E+00;0.14500E+00;0.20300E+00;...
0.28400E+00;0.39700E+00;0.55600E+00;0.77800E+00;0.10900E+01;0.15200E+01;...
0.22000E+01;0.33000E+01];

%% loading hazard curves from the 2016 model. 
[w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22] = ...
    textread('hazardCurve16.txt','%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
z5 = zeros(length(w1),1);
    w3(find(w3 <=0.0001)) = 0.0;    w8(find(w8 <=0.0001)) = 0.0;    w13(find(w13 <=0.0001)) = 0.0;    w17(find(w17 <=0.0001)) = 0.0;
    w4(find(w4 <=0.0001)) = 0.0;    w9(find(w9 <=0.0001)) = 0.0;    w13(find(w13 <=0.0001)) = 0.0;    w18(find(w18 <=0.0001)) = 0.0;
    w5(find(w5 <=0.0001)) = 0.0;    w10(find(w10 <=0.0001)) = 0.0;    w14(find(w14 <=0.0001)) = 0.0;    w19(find(w19 <=0.0001)) = 0.0;
    w6(find(w6 <=0.0001)) = 0.0;    w11(find(w11 <=0.0001)) = 0.0;    w15(find(w15 <=0.0001)) = 0.0;    w20(find(w20 <=0.0001)) = 0.0;
    w7(find(w7 <=0.0001)) = 0.0;    w12(find(w12 <=0.0001)) = 0.0;    w16(find(w16 <=0.0001)) = 0.0;    w21(find(w21 <=0.0001)) = 0.0;
    w22(find(w22 <=0.0001)) = 0.0;
% dis, lat, lon, PGAREF(1) ... PGAREF(20)
forcast16 = [z5,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,z5,z5];
% removing western hazard curves.
forcast16(find(forcast16(:,3) < -115.000),:) = [];

%% loading the adaptive model. 
    [w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22] = ...
    textread('./branch-adp/Llenos_max_NSH_CEUS.pga.txt','%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
     w3(find(w3 <=0.0001)) = 0.0;    w8(find(w8 <=0.0001)) = 0.0;    w13(find(w13 <=0.0001)) = 0.0;    w17(find(w17 <=0.0001)) = 0.0;
    w4(find(w4 <=0.0001)) = 0.0;    w9(find(w9 <=0.0001)) = 0.0;    w13(find(w13 <=0.0001)) = 0.0;    w18(find(w18 <=0.0001)) = 0.0;
    w5(find(w5 <=0.0001)) = 0.0;    w10(find(w10 <=0.0001)) = 0.0;    w14(find(w14 <=0.0001)) = 0.0;    w19(find(w19 <=0.0001)) = 0.0;
    w6(find(w6 <=0.0001)) = 0.0;    w11(find(w11 <=0.0001)) = 0.0;    w15(find(w15 <=0.0001)) = 0.0;    w20(find(w20 <=0.0001)) = 0.0;
    w7(find(w7 <=0.0001)) = 0.0;    w12(find(w12 <=0.0001)) = 0.0;    w16(find(w16 <=0.0001)) = 0.0;    w21(find(w21 <=0.0001)) = 0.0;
    w22(find(w22 <=0.0001)) = 0.0;
% %% no weight
% adaptiveNW = [w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,...
%            w16,w17,w18,w19,w20,w21,w22];
       
%% with weight 
adaptive = [w1,w2,(0.5).*w3,(0.5).*w4,(0.5).*w5,(0.5).*w6,(0.5).*w7,(0.5).*w8,...
        (0.5).*w9,(0.5).*w10,(0.5).*w11,(0.5).*w12,(0.5).*w13,(0.5).*w14,(0.5).*w15,...
        (0.5).*w16,(0.5).*w17,(0.5).*w18,(0.5).*w19,(0.5).*w20,(0.5).*w21,(0.5).*w22];   

%% loading informed branches from logic tree. 
% reading branch weights.
[bw] = textread('weights_2016.txt','%f');

all = dir('branch-infv');
branches = all(4:length(all));
cc = 0;

for bnum = 1:numel(branches);
    b = bw(bnum);
       cc = cc+1
    [w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22] = ...
    textread(sprintf('./branch-infv/%s',branches(bnum).name),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
    w3(find(w3 <=0.0001)) = 0.0;    w8(find(w8 <=0.0001)) = 0.0;    w13(find(w13 <=0.0001)) = 0.0;    w17(find(w17 <=0.0001)) = 0.0;
    w4(find(w4 <=0.0001)) = 0.0;    w9(find(w9 <=0.0001)) = 0.0;    w13(find(w13 <=0.0001)) = 0.0;    w18(find(w18 <=0.0001)) = 0.0;
    w5(find(w5 <=0.0001)) = 0.0;    w10(find(w10 <=0.0001)) = 0.0;    w14(find(w14 <=0.0001)) = 0.0;    w19(find(w19 <=0.0001)) = 0.0;
    w6(find(w6 <=0.0001)) = 0.0;    w11(find(w11 <=0.0001)) = 0.0;    w15(find(w15 <=0.0001)) = 0.0;    w20(find(w20 <=0.0001)) = 0.0;
    w7(find(w7 <=0.0001)) = 0.0;    w12(find(w12 <=0.0001)) = 0.0;    w16(find(w16 <=0.0001)) = 0.0;    w21(find(w21 <=0.0001)) = 0.0;
    w22(find(w22 <=0.0001)) = 0.0;
    br = [w1,w2,b.*w3,b.*w4,b.*w5,b.*w6,b.*w7,b.*w8,b.*w9,b.*w10,b.*w11,b.*w12,b.*w13,...
        b.*w14,b.*w15,b.*w16,b.*w17,b.*w18,b.*w19,b.*w20,b.*w21,b.*w22];
    branchHazW{cc} = br; %% with weight
    brnw = [w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22];
    branchHazNW{cc} = brnw; %% without weight
end
branchHazNW{cc+1} = adaptive;



% load('haz2016');

%  %% Bootstrapping
% % constructing informed model
% for k = 1:30; k
% r = randi([2 length(haz2016.brnach)],1,floor(length(haz2016.brnach)*0.9));
% informedNW = haz2016.brnach{r(1)}.C;
% for i = 1:length(r);
%     iii = r(i);
% for ii = 3 : 22
%     temp = haz2016.brnach{iii}.C;
%     informedNW(:,ii) = informedNW(:,ii) + temp(:,ii);
%     
% end   
% end
% modelR(:,ii) = informedNW(:,ii);
%    bootmodel{k} = modelR;
% end

%% Bootstraping 
% constructing informed model
Nsampling = 50;
for k = 1: Nsampling; k
WW = 0;
% r = randi([1 length(haz2016.brnach)],1,floor(length(haz2016.brnach)*0.9));
r = linspace(1,length(branchHazNW),length(branchHazNW));
ns = floor(length(branchHazNW)*0.9);
y = datasample(r,ns); 
informedNW = branchHazNW{y(1)};
bm = informedNW;
for i = 2:length(y);
    iii = y(i);
    temp = branchHazNW{iii};
    informedNW(:,3:22) = informedNW(:,3:22) + temp(:,3:22);
end  
    bootmodel{k} = informedNW;
end

informedNW(:,3:23)=0;
mean = informedNW; stboot = informedNW;
for E = 1:length(informedNW);
    (E./length(informedNW))*100
    for EE = 1 : 22
        vartmp = [];
        for EEE = 1:Nsampling
            tempp = bootmodel{EEE};
            vartmp = [vartmp, tempp(E,EE)];
        end   
    mean(E,EE) = sum(vartmp)/length(vartmp);
    stboot(E,EE) = 1.96*(std(vartmp));
    end   
end


%% extracting the hazard form curves
haz = zeros(length(branchHazNW),3);
ucr = zeros(length(branchHazNW),3);
ucrP = zeros(length(branchHazNW),3);
temp2 = branchHazNW{1};
for j = 1 : length(mean)
    
   H = mean(j,3:22);
   U = stboot(j,3:22);
   
   [c index1] = min(abs(H-0.0101));
   closestValues1 = H(index1); % finding the first minimum.

   if closestValues1 == 0.0101;
          yi = PGAREF(index1);
          ui = U(index1);
%           zi = (ui)./0.0101;
          
   elseif closestValues1 > 0.0101
      index2 = index1 + 1;
      closestValues2 = H(index2); 
      
   pga1 = PGAREF(index1); % finding the associated PGAs 
   pga2 = PGAREF(index2);
   y = [pga1;pga2];
   x = [closestValues1;closestValues2];
   yi = interp1(x,y,0.0101,'linear'); % 'nearest' 'linear
   u = [U(index1);U(index2)];
   ui = interp1(x,u,0.0101,'linear'); % 'nearest' 'linear
%    zi = (ui)./0.0101;   
%     ui = (U(index1)+U(index2))./2;   

   elseif closestValues1 < 0.0101
       if index1 == 1
          yi = PGAREF(index1);
          ui = U(index1);
%           zi = (ui)./0.0101;
       else
          index2 = index1; 
          index1 = index2 - 1;
          closestValues1 = H(index1);
          closestValues2 = H(index2);
          pga1 = PGAREF(index1); % finding the associated PGAs 
          pga2 = PGAREF(index2);
          y = [pga1;pga2];
          x = [closestValues1;closestValues2];
          yi = interp1(x,y,0.0101,'linear'); % 'nearest' 'linear
          u = [U(index1);U(index2)];
          ui = interp1(x,u,0.0101,'linear'); % 'nearest' 'linear
%           zi = (ui)./0.0101;  
%           ui = (U(index1)+U(index2))./2;
       end
   end
 
   haz(j,1) = temp2(j,2); haz(j,2) = temp2(j,1); haz(j,3) = yi; 
   ucr(j,1) = temp2(j,2); ucr(j,2) = temp2(j,1); ucr(j,3) = ui;
   ucrP(j,1) = temp2(j,2); ucrP(j,2) = temp2(j,1); ucrP(j,3) = ui./yi;
   
end
haz(isnan(haz)) = 0; ucr(isnan(ucr)) = 0; ucrP(isnan(ucr)) = 0;


% %% Bootstraping 
% % constructing informed model
% Nsampling = 50;
% for k = 1: Nsampling; k
% WW = 0;
% % r = randi([1 length(haz2016.brnach)],1,floor(length(haz2016.brnach)*0.9));
% r = linspace(1,length(haz2016.brnach),length(haz2016.brnach));
% ns = floor(length(haz2016.brnach)*0.9);
% y = datasample(r,ns); 
% informedNW = haz2016.brnach{y(1)}.C;
% bm = informedNW;
% WW = informedNW(1,23);
% informedNW(:,3:22).*WW;
% for i = 2:length(y);
%     iii = r(i);
%     temp = haz2016.brnach{iii}.C;
%     WT = temp(1,23); 
%     WW = WW + WT;
%     informedNW(:,3:22) = informedNW(:,3:22) + temp(:,3:22).*WT;
% end  
%     RW = 4.982- WW;
%     y2 = datasample(r,1); 
%     temp2 = haz2016.brnach{y2}.C;
%     bm(:,3:22) = informedNW(:,3:22)+temp2(:,3:22).*RW;
%     bootmodel{k} = bm;
% end
% 
% informedNW(:,3:23)=0;
% mean = informedNW; stboot = informedNW;
% for E = 1:length(informedNW);
%     (E./length(informedNW))*100
%     for EE = 1 : 22
%         vartmp = [];
%         for EEE = 1:Nsampling
%             tempp = bootmodel{EEE};
%             vartmp = [vartmp, tempp(E,EE)];
%         end   
%     mean(E,EE) = sum(vartmp)/length(vartmp);
%     stboot(E,EE) = 1.96*(std(vartmp));
%     end   
% end
% 
% 
% %% extracting the hazard form curves
% haz = zeros(length(haz2016.brnach{y(1)}.C),3);
% ucr = zeros(length(haz2016.brnach{y(1)}.C),3);
% ucrP = zeros(length(haz2016.brnach{y(1)}.C),3);
% temp2 = haz2016.brnach{y(1)}.C;
% for j = 1 : length(mean)
%     
%    H = mean(j,3:22);
%    U = stboot(j,3:22);
%    
%    [c index1] = min(abs(H-0.0101));
%    closestValues1 = H(index1); % finding the first minimum.
% 
%    if closestValues1 == 0.0101;
%           yi = PGAREF(index1);
%           ui = U(index1);
% %           zi = (ui)./0.0101;
%           
%    elseif closestValues1 > 0.0101
%       index2 = index1 + 1;
%       closestValues2 = H(index2); 
%       
%    pga1 = PGAREF(index1); % finding the associated PGAs 
%    pga2 = PGAREF(index2);
%    y = [pga1;pga2];
%    x = [closestValues1;closestValues2];
%    yi = interp1(x,y,0.0101,'linear'); % 'nearest' 'linear
%    u = [U(index1);U(index2)];
%    ui = interp1(x,u,0.0101,'linear'); % 'nearest' 'linear
% %    zi = (ui)./0.0101;   
% %     ui = (U(index1)+U(index2))./2;   
% 
%    elseif closestValues1 < 0.0101
%        if index1 == 1
%           yi = PGAREF(index1);
%           ui = U(index1);
% %           zi = (ui)./0.0101;
%        else
%           index2 = index1; 
%           index1 = index2 - 1;
%           closestValues1 = H(index1);
%           closestValues2 = H(index2);
%           pga1 = PGAREF(index1); % finding the associated PGAs 
%           pga2 = PGAREF(index2);
%           y = [pga1;pga2];
%           x = [closestValues1;closestValues2];
%           yi = interp1(x,y,0.0101,'linear'); % 'nearest' 'linear
%           u = [U(index1);U(index2)];
%           ui = interp1(x,u,0.0101,'linear'); % 'nearest' 'linear
% %           zi = (ui)./0.0101;  
% %           ui = (U(index1)+U(index2))./2;
%        end
%    end
%  
%    haz(j,1) = temp2(j,2); haz(j,2) = temp2(j,1); haz(j,3) = yi; 
%    ucr(j,1) = temp2(j,2); ucr(j,2) = temp2(j,1); ucr(j,3) = ui;
%    ucrP(j,1) = temp2(j,2); ucrP(j,2) = temp2(j,1); ucrP(j,3) = ui./yi;
%    
% end
% haz(isnan(haz)) = 0; ucr(isnan(ucr)) = 0; ucrP(isnan(ucr)) = 0;

delete('onePercent_1YrModel.pga.1pc1.txt')
fileID = fopen('onePercent_1YrModel.pga.1pc1.txt','w');
for k = 1 : length(haz)
fprintf(fileID,'%3.3f %2.3f %f\n',haz(k,:));
end
fclose(fileID);

delete('onePercent_1YrModel.pga.1pc2.txt')
fileID = fopen('onePercent_1YrModel.pga.1pc2.txt','w');
for k = 1 : length(ucr)
fprintf(fileID,'%3.3f %2.3f %f\n',ucr(k,:));
end
fclose(fileID);

delete('onePercent_1YrModel.pga.1pc3.txt')
fileID = fopen('onePercent_1YrModel.pga.1pc3.txt','w');
for k = 1 : length(haz)
fprintf(fileID,'%3.3f %2.3f %f\n',ucrP(k,:));
end
fclose(fileID);
    