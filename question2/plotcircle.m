%输入：起点a，终点b，圆心：center，入射方向：dir
%输出：角度
%https://blog.csdn.net/menjiawan/article/details/43021507
function theta=plotcircle(a,b,center,dir,plotflag)
    %计算半径
    r=sqrt(sum((a-center).^2));
    %计算圆面法向量n
    u=a-center;%与n正交的向量,以a-center可确保t=0时的点为a
   % u2=b-center;
    n=cross3d(u,dir);
    %计算与 u，n都正交的向量
    v=cross3d(u,n);
    %u,v归一化
    u=u/sqrt(sum(u.^2));
    v=v/sqrt(sum(v.^2));
    t=(0:0.001:2*pi);
    pos=center.'+r*(u.'.*cos(t)+v.'.*sin(t));

    
    %找到b点
    btmp=sum((b.'-pos).^2,1);
    [~,min_b]=min(btmp);
    at=1;
    bt=(min_b);
    %判断方向    
    dirc=(center.'+r*(u.'.*cos(t(2))+v.'.*sin(t(2))))-(center.'+r*(u.'.*cos(t(1))+v.'.*sin(t(1))));%圆弧前进方向
    if dir*dirc>0%同向
       if plotflag==1
        plot3(pos(1,at:bt),pos(2,at:bt),pos(3,at:bt),'r');
       end
       thetatmp=2*pi*(bt-at+1)/length(t);
    else
       if plotflag==1
        plot3(pos(1,bt:end),pos(2,bt:end),pos(3,bt:end),'r');
       end
       thetatmp=2*pi*(length(t)-bt+1)/length(t);
    end
    %计算角度
    theta=get_theta(a,b,center);
    theta= [theta,2*pi-theta];
    [~,min_t]=min(abs(thetatmp-theta));
    theta=theta(min_t);
%     if length(t)/abs(at-bt)<0.5
%         theta=2*pi-theta;
%     end
%     disp(["角度为：",theta/pi,"pi"])
end
%计算角度
% http://www.ab126.com/geometric/7300.html
function theta=get_theta(a,b,center)
a1=a-center;
b1=b-center;
c1=a-b;
al=sqrt(sum(a1.^2));
bl=sqrt(sum(b1.^2));
cl=sqrt(sum(c1.^2));
theta=acos((al^2+bl^2-cl^2)/(2*al*bl));
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
% 测试程序
%close all
%figure
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(a,b,center,[1,1,0])
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(a,b,center,[1,-1,0])
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(a,b,center,[-1,1,0])
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(a,b,center,[-1,-1,0])
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(b,a,center,[1,1,0])
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(b,a,center,[1,-1,0])
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(b,a,center,[-1,1,0])
%a=[0,1,0];b=[1,0,0];center=[0,0,0];plotcircle(b,a,center,[-1,-1,0])