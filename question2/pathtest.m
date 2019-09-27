clc
clear all
close all

%%
%% read file

data1= xlsread('附件1：数据集1-终稿.xlsx','data1');
%  data1= xlsread('附件2：数据集2-终稿.xlsx','data2');
cor_pos.num=data1(:,1);
cor_pos.x=data1(:,2);
cor_pos.y=data1(:,3);
cor_pos.z=data1(:,4);
cor_pos.type=data1(:,5);
cor_pos.q3=data1(:,6);
hp=(cor_pos.type==0);
vp=(cor_pos.type==1);
figure
p1=plot3(cor_pos.x(hp),cor_pos.y(hp),cor_pos.z(hp),'green.');
hold on
p2=plot3(cor_pos.x(vp),cor_pos.y(vp),cor_pos.z(vp),'blue.');
hold on
plot3(cor_pos.x(1),cor_pos.y(1),cor_pos.z(1),'rx')
hold on
plot3(cor_pos.x(end),cor_pos.y(end),cor_pos.z(end),'rx')
text(cor_pos.x(1),cor_pos.y(1),cor_pos.z(1),'A')
text(cor_pos.x(end),cor_pos.y(end),cor_pos.z(end),'B')

%% parameter
% basic
alpha1=25;alpha2=15;beta1=20;beta2=25;theta=30;deta=0.001;
%data2
% alpha1=20;alpha2=10;beta1=15;beta2=20;theta=20;deta=0.001;
% algorithm
wire_rad=min([alpha1,alpha2,beta1,beta2,theta])/deta;
para=[alpha1,alpha2,beta1,beta2,theta,deta];
%% data1
% path=[ 1    41    65    70    48    10    50    29    57    28     3    12   100   114    60   134    94    17   117    19   613];
% path=[  1   417    30     7    51    48    10    50    29    57    28     3    12   100   114    60   134    94    17   117    19   613];
% path=[ 1   504    70   238   156   339   458   556   437   371    19   255    19   613];
% path=[ 1   504    70   507    29   184   194   289   114   486   249   502    19   255    19   613];% 1.1319e+05
path=[ 1   504    70   507    29   184   194   289   114   486   249   502    19     613];% 1.0659e+05
  %% data2
% path=[1   141   164   115   252   138   195   206   197   120    87   168    77     7   250   275    13   217    17   217    13   322   212   182  192   161   192    20    51   324    62   293   136    60   327];
% %2.2402e+05
% path=[1   141   164   115   252   138   195   206   197   120    87   168    77     7   250   275    13      322   212   182  192     20    51   324    62   293   136    60   327];
% % 1.9897e+05
% path=[1   141   164   115   252   138   195   206   197   120    87   168    77     7   250   275    13      322   212   182  192     20    51   324    62   293   136     327];
% %  1.8496e+05
% path=[1   141   164   115   252   138   195   206   197   120    87   168    77     7   250   275    13      322   212   182  192     20    51   324    62   293   327];
%    %1.8444e+05
% path=[  1   141   164   115   252   138   195   206   197   120    87   168    77     7   250   275    13   217   280   302    39   288    62   293 136   327];
   % 1.6114e+05

%% 一些信息
%起点终点距离
tmp=[cor_pos.x(end)-cor_pos.x(1),cor_pos.y(end)-cor_pos.y(1),cor_pos.z(end)-cor_pos.z(1)];
disp(["AB距离",sqrt(sum(tmp.^2))])
%% 路径测试
% figure
[err2,disall]= get_q2err(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path),cor_pos.type(path),para);
legend([p1,p2],"水平校正点","垂直校正点")%
disp(["航迹总长",disall])