function [err,disall]= get_q2err(x,y,z,type,para)
N=length(x);
alpha1=para(1);
alpha2=para(2);
beta1=para(3);
beta2=para(4);
theta=para(5);
deta=para(6);
disall=0;
%
errh=zeros(1,N);
errv=zeros(1,N);
errh2=zeros(1,N);
errv2=zeros(1,N);
for ii=2:N
    %dist=sqrt((x(ii)-x(ii-1))^2+(y(ii)-y(ii-1))^2+(z(ii)-z(ii-1))^2);
    b=[x(ii),y(ii),z(ii)];
    a=[x(ii-1),y(ii-1),z(ii-1)];
    if ii==2
        plot3([a(1),b(1)],[a(2),b(2)],[a(3),b(3)],'black')
        lastb2=a;
        theta=0;
        hold on
    else
        [r,b2]= go_cir(lastb2,a,b);
        theta=plotcircle(a,b2,r,a-lastb2,1);
        hold on
        plot3([b2(1),b(1)],[b2(2),b(2)],[b2(3),b(3)],'black')
        lastb2=b2;
    end
    dist=200*theta+sqrt(sum((b-lastb2).^2));
    disall=disall+dist;
    errh(ii)=errh(ii-1)+dist*deta;
    errv(ii)=errv(ii-1)+dist*deta;
    errh2(ii)=errh(ii);
    errv2(ii)=errv(ii);
    if type(ii)==0%h
        if errv(ii)<beta1&&errh(ii)<beta2
            errh(ii)=0; 
        end    
    elseif type(ii)==1
        if errv(ii)<alpha1&&errh(ii)<alpha2
            errv(ii)=0; 
        end
    end
end
err.hv=[errh;errv];
err.hv2=[errh2;errv2];
% figure;
% plot3(x,y,z,'black')
hold on
plot3(x(1),y(1),z(1),'rx')
hold on
plot3(x(end),y(end),z(end),'rx')
text(x(1),y(1),z(1),'出发点A')
text(x(end),y(end),z(end),'目标点B')

xlabel('x/m')
ylabel('y/m')
zlabel('z/m')
title('data1 航迹规划路径')
end

