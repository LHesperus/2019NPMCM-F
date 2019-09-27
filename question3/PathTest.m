clc
clear all
close all

%%
%% read file
tic
data1= xlsread('附件1：数据集1-终稿.xlsx','data1');
%  data1= xlsread('附件2：数据集2-终稿.xlsx','data2');
toc
tic
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
toc
%% parameter
% basic
alpha1=25;alpha2=15;beta1=20;beta2=25;theta=30;deta=0.001;
%data2
% alpha1=20;alpha2=10;beta1=15;beta2=20;theta=20;deta=0.001;
% algorithm
wire_rad=min([alpha1,alpha2,beta1,beta2,theta])/deta;
para=[alpha1,alpha2,beta1,beta2,theta,deta];
%% data1
% path=[1,201,355 , 70,507 , 29,184,582,542 ,195,451 ,449 , 54 ,595,398,437,502, 19 , 613];%p=0.5，117894
% path=[ 1   201   355    70   507    29   184   582   542   195   451   449    54   595   398   437   502   303   502    19   255    19   613];%0.5，129338
% path=[1   504    70   238   156   339   458   556   437   371    19   255    19   613];%p=0.0625，111916
%  path=[1   504    70   238   156   339   458   556   437   371    19     613];%p=0.0625，106252

%加概率约束
% path=[1   504    70   238   156   339   458   556   437   371    19   255   561   498   613];%0.0625，116954
% path=[1   504    70   238   156   339   458   556   437   613];%0.0625,点最少，104898
path=[ 1   504   295    92    76   525   195   451   287   369   613];%1,106250,概率最大
  %% data2
%   path=[1   141   164   115   235   223     9   310   306   124   232   161    93    94    62   293   136    60   327];%4.882812500000000e-04
%加概率约束
% path=[ 1   141   151   106   105   129     9   310   306   124   232   161    93    94    62   293   136    60   327];
% path=[ 1   170   267   101   138   189   239   235   223     9   310   306   124   315   169    87   168    77     7   250   275    13   217    17   217    280   302    39   288    62   293   136   327];%0.0625
% path=[ 1   141   164   115   235   223     9   226   256   124   315   169    87   168    77     7   250   275    13   217    17   217    13   322   212 182   192   161    93    94    39   111   100   293   100   327];%0.0039
% path=[ 1   141   151   106   105   129     9   310   231   226   256   124   315   169    87   168    77     7   250   275    13   217    17   217   280 94    62   293   327];%0.003906250000000
% path=[1   185   137   227   289   260    49   260   238   281    66   326   309   196    53     8   146   240    33    63    21    88   247   314   312 62   293   100   293   327];%p=0.5
% path=[1   170   267   101   138   195   206   259   251   244   168    77     7   250   275    13   217    17   217   280    94    62   293   327];%0.0625
% path=[1   185   137   227   289    41   291   159   236   281    66   326   309   196    53     8   146   240    33    63    21    88   247   314   312  62   293   100   293   327];%0.25
% path=[1   185   137   227   289   260    49   260   238   281    66   326   309   196    53     8   146   240    33    63    21    88   247   314   312 62   293   100   293   327];%p=0.8
% path=[1   185   137   227   289   260    49   260   238   281    66   326   309   196    53     8   146   240    33    63    21    88   247   314   312 62   293       327];%p=0.8


%% 一些信息
%起点终点距离
tmp=[cor_pos.x(end)-cor_pos.x(1),cor_pos.y(end)-cor_pos.y(1),cor_pos.z(end)-cor_pos.z(1)];
disp(["AB距离",sqrt(sum(tmp.^2))])
len= get_len(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path));
disp(["路总长",len])
%% 路径测试
err= get_err(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path),cor_pos.type(path),para);
legend([p1,p2],"水平校正点","垂直校正点")%
flag = path_iferr(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path),cor_pos.type(path),para);
%% 概率测试
% cor_pos.q3(path)
% sum(cor_pos.q3(path))
npath=length(path);
type2=cor_pos.q3(path);
typen=find(type2==1);
testn=2^sum(cor_pos.q3(path));


pmn=0;
pall=0;
tic
tmpflag=[];
tmpp=[];
% type2tmp=zeros(1,npath);
for ii=1:length(typen)
    Cmn=nchoosek(typen,ii);
    for jj=1:size(Cmn,1)
        type2tmp=zeros(1,npath); 
        type2tmp(Cmn(jj,:))=1;
        pmn=0.2^sum(type2tmp)*0.8^(length(typen)-sum(type2tmp));
        [err3,flag3]= get3_err(cor_pos.x(path),cor_pos.y(path),cor_pos.z(path),cor_pos.type(path),para,type2tmp);
        tmpflag=[tmpflag,flag3];
        tmpp=[tmpp;pmn];
        pall=pall+pmn*(~flag3);
    end
end
pall=pall+0.8^length(typen);%加上全不出错的情况
