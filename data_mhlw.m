% data_mhlw.m
%%%%%%%%%%%%%%%%%%
% Download data from the MHLW web site.
websave('pcr_positive_daily.csv','https://www.mhlw.go.jp/content/pcr_positive_daily.csv');
websave('recovery_total.csv','https://www.mhlw.go.jp/content/recovery_total.csv');
Acsv=importdata('pcr_positive_daily.csv');
Bcsv=importdata('recovery_total.csv');

% Shape up the data.
% N: the number of days between d0 and the date of update. 
% A(n,1): total cases on the n-th day
% B(n,1): the number of total discharged cases on the n-th day
% C(n,1)=A(n,1)-B(n,1) the active cases and the deaths     
AA=Acsv.data;
BB=Bcsv.data;
aa=length(AA);
bb=length(BB);
N=aa-16;
A=zeros(N,1);
B=zeros(N,1);
n=transpose(1:N);
A17=zeros(17,1);
A17(1,1)=AA(1,1);
for l=2:17
    A17(l,1)=AA(l,1)+A17(l-1,1);
end
A(1,1)=A17(17,1);
for k=2:N
    A(k,1)=AA(16+k,1)+A(k-1,1);
end
B(n,1)=BB(3+n,1);
C=A-B;

% Plot the data. 
% d0: the initial day
% df: the date of update
d0=datetime(2020,2,1);
ddff=strrep(Acsv.textdata(aa+1,1),'/','-');
df=datetime(ddff);
l0=datestr(d0,'yyyy-mm-dd');
l1=datestr(d0+days(floor(N/3)),'yyyy-mm-dd');
l2=datestr(d0+days(floor(2*N/3)),'yyyy-mm-dd');
lf=datestr(df,'yyyy-mm-dd');
plot(n,A,n,C,n,B,'LineWidth',2)
title('COVID-19 in Japan (126M)')
xticks([0 floor(N/3) floor(2*N/3) N])
xticklabels({[l0],[l1],[l2],[lf]})
legend('Total Cases','Active Cases','Discharged','Location','northwest');
