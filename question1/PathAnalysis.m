clc
clear all
close all
%路径分析
%% read file
tic
data1= xlsread('附件1：数据集1-终稿.xlsx','data1');
data1= xlsread('附件2：数据集2-终稿.xlsx','data2');
toc
tic
cor_pos.num=data1(:,1);
cor_pos.x=data1(:,2);
cor_pos.y=data1(:,3);
cor_pos.z=data1(:,4);
cor_pos.type=data1(:,5);
cor_pos.q3=data1(:,6);
figure
plot3(cor_pos.x,cor_pos.y,cor_pos.z,'.');
hold on
plot3(cor_pos.x(1),cor_pos.y(1),cor_pos.z(1),'rx')
hold on
plot3(cor_pos.x(end),cor_pos.y(end),cor_pos.z(end),'rx')
text(cor_pos.x(1),cor_pos.y(1),cor_pos.z(1),'A')
text(cor_pos.x(end),cor_pos.y(end),cor_pos.z(end),'B')
toc
figure
hp=(cor_pos.type==0);
vp=(cor_pos.type==1);
plot3(cor_pos.x(hp),cor_pos.y(hp),cor_pos.z(hp),'blue*');
hold on
plot3(cor_pos.x(vp),cor_pos.y(vp),cor_pos.z(vp),'green^');
hold on
plot3(cor_pos.x(1),cor_pos.y(1),cor_pos.z(1),'rx')
hold on
plot3(cor_pos.x(end),cor_pos.y(end),cor_pos.z(end),'rx')
text(cor_pos.x(1),cor_pos.y(1),cor_pos.z(1),'A')
text(cor_pos.x(end),cor_pos.y(end),cor_pos.z(end),'B')
%% parameter
% basic
% alpha1=25;alpha2=15;beta1=20;beta2=25;theta=30;deta=0.001;
%data2
alpha1=20;alpha2=10;beta1=15;beta2=20;theta=20;deta=0.001;
% algorithm
wire_rad=min([alpha1,alpha2,beta1,beta2,theta])/deta;
para=[alpha1,alpha2,beta1,beta2,theta,deta];
%% creat picture
N=length(cor_pos.x);
graph=zeros(N,N);
graph2=zeros(N,N);
for ii=1:N
    for jj=ii+1:N
        dist=sqrt((cor_pos.x(jj)-cor_pos.x(ii)).^2+(cor_pos.y(jj)-cor_pos.y(ii)).^2+(cor_pos.z(jj)-cor_pos.z(ii)).^2);
        graph2(ii,jj)=dist;
        if dist<wire_rad&&(cor_pos.type(jj)~=cor_pos.type(ii))
            graph(ii,jj)=dist  ;      
        end
%         if dist<wire_rad/2
%             graph(ii,jj)=dist  ; 
%         end
    end
end
% graph=graph+graph.';
graph(graph==0)=Inf;
graph2=graph2+graph2.';
disp(["路的条数",sum(sum((graph~=Inf)))/2])

max_num=0;
for ii=1:N
    if max_num<sum(graph(ii,:)~=inf)
        max_num=sum(graph(ii,:)~=inf);
    end
end
path_array=zeros(N,50);
for ii=1:N
    jj=1;
    for kk=1:N
        if graph(ii,kk)~=inf
            path_array(ii,jj)=kk;
            jj=jj+1;
        end
    end
end
%%
hold on
for ii=1:N
    for jj=1:N
        if graph(ii,jj)==inf
            continue;
        end
        pos=[ii,jj];
        plot3(cor_pos.x(pos),cor_pos.y(pos),cor_pos.z(pos),'black');
        hold on
    end

end
