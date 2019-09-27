clc
clear all
close all
%% read file
tic
data1= xlsread('附件1：数据集1-终稿.xlsx','data1');
% data1= xlsread('附件2：数据集2-终稿.xlsx','data2');
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
%% parameter
% basic
alpha1=25;alpha2=15;beta1=20;beta2=25;theta=30;deta=0.001;
%data2
% alpha1=20;alpha2=10;beta1=15;beta2=20;theta=20;deta=0.001;
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
        if dist<wire_rad/2
            graph(ii,jj)=dist  ; 
        end
    end
end
graph=graph+graph.';
graph(graph==0)=Inf;
graph2=graph2+graph2.';

disp(['路的条数',sum(sum((graph~=Inf)))/2])
%% Dijkstra
dij_out.stop=1;
tmp=[0,0,0,0];%校正后误差，校正前误差
start_temp=1;
path=[];
err=[];
while dij_out.stop~=N
    dij_out=Dijkstra1(graph,graph2,para,cor_pos.type,dij_out.stop,tmp,start_temp);
    tmp=[dij_out.errend,dij_out.err.h(end),dij_out.err.v(end)];
    start_temp=[start_temp,dij_out.stop];
    path=[path,dij_out.path(2:end)];
    err=[err;dij_out.err];
end
path=[1,path];
plot3(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path),'black')
err2= get_err(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path),cor_pos.type(path),para);
len= get_len(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path));
strlen=sqrt((cor_pos.x(1)-cor_pos.x(end))^2+(cor_pos.y(1)-cor_pos.y(end))^2+(cor_pos.z(1)-cor_pos.z(end))^2);
disp(["路径长度",len])
disp(["AB线段距离",strlen])