% sir2_mhlw.m
%%%%%%%%%%%%%%%%%%%%%%
% Download the open data from the MHLW web site 
websave('pcr_positive_daily.csv','https://www.mhlw.go.jp/content/pcr_positive_daily.csv');
websave('recovery_total.csv','https://www.mhlw.go.jp/content/recovery_total.csv');
Acsv=importdata('pcr_positive_daily.csv');
Bcsv=importdata('recovery_total.csv');

% Pick up information from the data.
AAA=Acsv.data;
BB=Bcsv.data;
aa=length(AAA);
bb=length(BB);
AA=zeros(aa,1);
for n=2:aa
    AA(n,1)=AAA(n,1)+AA(n-1,1);
end

% Set the date of update as the initial date. 
dd00=strrep(Acsv.textdata(aa+1,1),'/','-');

% d0: The initial date
% T0: total cases
% R0: discharged 
d0=datetime(dd00);
T0=AA(aa,1);
R0=BB(bb,1);

% d2: 7 days before d0
% T2: total cases
% R2: discharged 
d2=datetime(d0-days(7));
T2=AA(aa-7,1);
R2=BB(bb-7,1);

% total population
N=125710000;

% simulation period [days]
D=5*7;

% Set the constants beta and gamma of the SIR model. 
T1=(T0-T2)/days(d0-d2);
R1=(R0-R2)/days(d0-d2);
beta=T1/(T0-R0)/(N-T0);
gamma=R1/(T0-R0);

% Solve the initial value ptoblem.
[t,u]=ode45(@(t,u) [-beta*u(1)*u(2); beta*u(1)*u(2)-gamma*u(2); gamma*u(2)], [0,D], [N-T0;T0-R0;R0]);

% Plot the results. 
l0=datestr(d0,'dd mmm yyyy');
l1=datestr(d0+days(2*7),'dd mmm yyyy');
l2=datestr(d0+days(4*7),'dd mmm yyyy');
plot(t,u(:,2)+u(:,3),t,u(:,2),t,u(:,3),'LineWidth',2); 
title('SIR model for COVID-19 in Japan (126M)');
xticks([0 2*7 4*7]);
xticklabels({[l0],[l1],[l2]});
ylabel('population');
legend('Total Cases','Active Cases','Discharged','Location','northwest');
