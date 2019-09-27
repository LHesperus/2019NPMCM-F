% a:第一个点，b：第二个点，c：第三个点
% b2:圆上的另一个点
function [r,b2]= go_cir(a,b,c)

ab=b-a;
ac=c-a;
vabc=cross3d(ab,ac);%面法线
vbr=cross3d(ab,vabc);%b点至圆心方向
vbr=vbr/sqrt(sum(vbr.^2));
r1=b+200*vbr;
r2=b-200*vbr;
r=[r1;r2];
[~,tmp]=min([sum((r1-c).^2),sum((r2-c).^2)]);
r=r(tmp,:);
u=b-r;
v=cross3d(u,vabc);
u=u/sqrt(sum(u.^2));
v=v/sqrt(sum(v.^2));
t=(0:0.001:2*pi);
pos=r.'+200*(u.'.*cos(t)+v.'.*sin(t));
dir_cir=pos(:,2)-pos(:,1);
if ab*dir_cir>0%同向
    for ii=1:length(t)-1
        sig1=(pos(:,ii).'-r)*(c-pos(:,ii).').'>=0;
        sig2=(pos(:,ii+1).'-r)*(c-pos(:,ii+1).').'>=0;
        if sig1~=sig2
            tmp=ii+1;%找到切点
            break;
        end
    end
end
if ab*dir_cir<=0%反向
    for ii=length(t):-1:2
        sig1=(pos(:,ii-1).'-r)*(c-pos(:,ii-1).').'>=0;
        sig2=(pos(:,ii).'-r)*(c-pos(:,ii).').'>=0;
        if sig1~=sig2
            tmp=ii;%找到切点
            break;
        end
    end
end
b2=pos(:,tmp).';
end
% 3d向量叉乘
% http://blog.sina.com.cn/s/blog_5f9652ef0100ejhk.html
% u2v3-v2u3 , u3v1-v3u1 , u1v2-u2v1
function out=cross3d(a,b)
 out=zeros(1,3);
 out(1)=a(2)*b(3)-b(2)*a(3);
 out(2)=a(3)*b(1)-b(3)*a(1);
 out(3)=a(1)*b(2)-a(2)*b(1);
end
%测试程序
% clc
% clear all
% close all
% a=[0,200,0];b=[600,200,0];c=[800,-700,0];[r,b2]= go_cir(a,b,c);
% a=[0,200,0];b=[600,200,0];c=[800,700,0];[r,b2]= go_cir(a,b,c);
% figure;
% plot3([a(1),b(1)],[a(2),b(2)],[a(3),b(3)])
% hold on
% theta=plotcircle(b,b2,r,b-a,1)