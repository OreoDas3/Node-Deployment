close all
clear
clc
addpath(genpath(cd))
warning('off')
N=20;
area=[100,100];
Trange=15;
tg=250;
nodes.pos=area(1).*rand(N,2);
lambda=0.125;
nodes.major = Trange;
nodes.minor = lambda*Trange;
redundantNo=round(10*N/100);
xm=100;
ym=100;
x=0;
y=0;
Eo=2;
sinkx=120;
sinky=120;
p=100;
c=30;
m=30;

cnt=1;
for ii=1:N      
    for jj=1:N
        if ii~=jj
            nodes.distance(ii,jj)=pdist([nodes.pos(ii,:);nodes.pos(jj,:)]);
            if nodes.distance(ii,jj)<Trange || nodes.distance(ii,jj)==Trange
                nodes.inrange(ii,jj)=1;
            else
                nodes.inrange(ii,jj)=0;
            end
        end
    end
end
P=population(p);
K=0;
[x1 y1]=size(P);
P1=0;
for i=1:tg
    Cr=crossover(P,c);
    Mu=mutation(P,m);
    P(p+1:p+2*c,:)=Cr;
    P(p+2*c+1:p+2*c+m,:)=Mu;
    E=evaluation(P);
    [P S]=selection(P,E,p);
    K(i,1)=sum(S)/p;
    K(i,2)=S(1);
end
figure(3)
F5=plot(nodes.pos(:,1),nodes.pos(:,2),'.','color','r');
hold on
for ii=1:N                   
    [nodes.circle.x(ii,:),nodes.circle.y(ii,:)]=circle(nodes.pos(ii,1),nodes.pos(ii,2),Trange);
    F6=fill(nodes.circle.x(ii,:),nodes.circle.y(ii,:),[0.25,0.25,0.25]);
    alpha 0.3
    hold on
end
axis on
xlabel('x(m)')
ylabel('y(m)')
title('Initial Placement of Nodes with circular transmission range')
TRI = delaunay(nodes.pos(:,1),nodes.pos(:,2));
figure(4)
F5 = plot(nodes.pos(:,1),nodes.pos(:,2),'.','color','r');
hold on
for ii=1:N                   
    [nodes.circle.x(ii,:),nodes.circle.y(ii,:)]=circle(nodes.pos(ii,1),nodes.pos(ii,2),Trange);
    F6=fill(nodes.circle.x(ii,:),nodes.circle.y(ii,:),[0.25,0.25,0.25]);
    alpha 0.3
    hold on
end
axis on
xlabel('x(m)')
ylabel('y(m)')
title('Coverage hole in initial position of Nodes')
hold on
triplot(TRI,nodes.pos(:,1),nodes.pos(:,2))
[holeDetected.circle,Circmcenter.circle,circumradius.circle]=holeDetection(TRI,nodes,F5,F6,Trange,area,2,1);
display(['--> No of detected Holes for Circular = ',num2str(numel(find(holeDetected.circle)))])
nvars = 2*(N);
fun=@(x)objf(x,Trange,area);
lb=zeros(nvars,1);
ub=area(1).*ones(nvars,1);
options = optimoptions(@particleswarm,'Display','iter','MaxIterations',100,'PlotFcn','pswplotbestf');
[x,fval] = particleswarm(fun,nvars,lb,ub,options);
finalPos = reshape(x,[numel(x)/2,2]);
figure(5)
plot(finalPos(:,1),finalPos(:,2),'o','color','r');
%p = nsidedpoly(3, 'Center', [sa(nodes).xaxis, sa(nodes).yaxis], 'SideLength', 2);
%plot(p);
hold on
for ii=1:N                 
    [finalcircle.x(ii,:),finalcircle.y(ii,:)]=circle(finalPos(ii,1),finalPos(ii,2),Trange);
    fill(finalcircle.x(ii,:),finalcircle.y(ii,:),[0.25,0.25,0.25]);
    alpha 0.3
    hold on
end
axis on
xlabel('x(m)')
ylabel('y(m)')
title('Optimized location of Nodes with circular transmission range')