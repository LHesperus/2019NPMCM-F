function err= get_err(x,y,z,type,para)
N=length(x);
alpha1=para(1);
alpha2=para(2);
beta1=para(3);
beta2=para(4);
theta=para(5);
deta=para(6);

%
errh=zeros(1,N);
errv=zeros(1,N);
errh2=zeros(1,N);
errv2=zeros(1,N);
for ii=2:N
    dist=sqrt((x(ii)-x(ii-1))^2+(y(ii)-y(ii-1))^2+(z(ii)-z(ii-1))^2);
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
% plot3(x,y,z)
end

