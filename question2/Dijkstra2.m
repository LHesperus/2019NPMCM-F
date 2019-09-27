%
function dij_out = Dijkstra2(graph_in,graph_in2,para,type,start,start2,tmp,start_temp,x,y,z,lastendb2)
%% parameter
    max_value=inf;
    alpha1=para(1)-1;
    alpha2=para(2)-1;
    beta1=para(3)-1;
    beta2=para(4)-1;
    theta=para(5)-1;
    deta=para(6);
    dij_out.path=[];
    N=size(graph_in,1);
    SQ=ones(1,N);%S集合和Q集合,0->S,1->Q
    SQ(start)=0;
    w=max_value*ones(1,N);
    w(start)=0;
    path_last=zeros(1,N);%顶点前驱
    path_last(start)=start;
    errh=zeros(1,N);%校正后误差
    errv=zeros(1,N);
    errh2=zeros(1,N);%校正前误差
    errv2=zeros(1,N);
    errh(start)=tmp(1);
    errv(start)=tmp(2);
    errh2(start)=tmp(3);
    errv2(start)=tmp(4);
    %% iter
    ii=start;
    starttmp=start;
    if start==1
        flagstart=0;
    else
        flagstart=1;
    end
    
    while sum(SQ)>0&&ii~=N
        errhtmp=zeros(1,N);
        errvtmp=zeros(1,N);
        errhtmp2=zeros(1,N);
        errvtmp2=zeros(1,N);
        errflag=zeros(1,N);
		b2=zeros(3,N);
        for jj=1:N
            if graph_in(ii,jj)==max_value||jj==ii||SQ(jj)==0%没有路或本身或S中，跳过
                continue;
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%
            if start2==0&&start==1%起点A
                %做直线
				w_temp=w(ii)+graph_in(ii,jj);
				b2(:,jj)=[x(1),y(1),z(1)].';
                errhtmp(jj)=errh(ii)+graph_in(ii,jj)*deta;
                errvtmp(jj)=errv(ii)+graph_in(ii,jj)*deta;           
                errhtmp2(jj)=errhtmp(jj);
                errvtmp2(jj)=errvtmp(jj);

            end
			if ii==start&&start~=1&&flagstart==1%非A点，但是新dij的起点
				pos1=lastendb2;
				pos2=[x(start),y(start),z(start)];
				pos3=[x(jj),y(jj),z(jj)];
				[r,b2tmp]=go_cir(pos1,pos2,pos3);
                b2(:,jj)=b2tmp.';
				theta1=plotcircle(pos2,b2(:,jj).',r,pos2-pos1,0);
				cirlen=theta1*200;
                cirlen=cirlen+sqrt(sum((pos3-b2(:,jj).').^2));
				w_temp=w(ii)+cirlen;
                errhtmp(jj)=errh(ii)+cirlen*deta;
                errvtmp(jj)=errv(ii)+cirlen*deta;           
                errhtmp2(jj)=errhtmp(jj);
                errvtmp2(jj)=errvtmp(jj);
			end
            if ii~=start&&start~=1&&start~=0&&flagstart==1
				pos1=lastpos;
				pos2=[x(ii),y(ii),z(ii)];
				pos3=[x(jj),y(jj),z(jj)];
				[r,b2tmp]=go_cir(pos1,pos2,pos3);
                b2(:,jj)=b2tmp.';
				theta1=plotcircle(pos2,b2(:,jj).',r,pos2-pos1,0);
				cirlen=theta1*200;
                cirlen=cirlen+sqrt(sum((pos3-b2(:,jj).').^2));
				w_temp=w(ii)+cirlen;
                errhtmp(jj)=errh(ii)+cirlen*deta;
                errvtmp(jj)=errv(ii)+cirlen*deta;           
                errhtmp2(jj)=errhtmp(jj);
                errvtmp2(jj)=errvtmp(jj);
            end
            if type(jj)==0%h
                if errvtmp(jj)<beta1&&errhtmp(jj)<beta2
                    errhtmp(jj)=0;
                end
            elseif type(jj)==1%v
                 if errvtmp(jj)<alpha1&&errhtmp(jj)<alpha2
                    errvtmp(jj)=0;
                 end
            end
            flag=0;%1->误差可以承受
            if errvtmp(jj)<theta&&errhtmp(jj)<theta
                flag=1;
            end
            if(w_temp< w(jj))&&flag==1%更新权重和前驱
                w(jj)=w_temp;
                errh(jj)=errhtmp(jj);
                errv(jj)=errvtmp(jj);
                errh2(jj)=errhtmp2(jj);
                errv2(jj)=errvtmp2(jj);
                path_last(jj)=ii;
            end
            if flag==0
                 errflag(jj)=1;
            end
        end
        min_temp=max_value;
        min_pos=N;
        for kk=1:N        
            if SQ(kk)==1&&min_temp>w(kk)&&errflag(kk)==0
                min_pos=kk;
                min_temp=w(kk);

            end
        end
        SQ(min_pos)=0;%更新集合
        ii=min_pos;
		%% 记住b2
		lastpos=b2(:,ii).';
		dij_out.endb2=b2(:,ii).';
    end
    dij_out.w=w;
    dij_out.path_last=path_last;

%% 可能未找到N
flag=0;
%%
if flag==0
min_pos=start;
min_v=max_value;
   for ii=1:N
    if  path_last(ii)~=0&&min_v>graph_in2(ii,N)&&errh(ii)<10&&errv(ii)<10&&sum(graph_in(ii,:)~=inf)>1&&sum(start_temp==ii)==0%图1
        min_v=graph_in2(ii,N);
        min_pos=ii;
        flag=1;
    end
   end
end
if flag==0
    min_pos=start;
    min_v=max_value;
   for ii=1:N
    if path_last(ii)~=0&&min_v>graph_in2(ii,N)&&sum(start_temp==ii)==0&&errh(ii)<15&&errv(ii)<15
        min_v=graph_in2(ii,N);
        min_pos=ii;
        flag=1;
    end
   end 
end
if flag==0
%     disp('error')
end
stop=min_pos;
    path=path_last(stop);
    start=starttmp;
    while path(1)~=start
        path=[path_last(path(1)),path];
    end
    path=[path,stop];
    dij_out.path=path;
    %校正前误差
    dij_out.err.h=errh2(path);%horizontal
    dij_out.err.v=errv2(path);%vertical
    dij_out.stop=stop;
    dij_out.stop2=path(end-1);
    dij_out.errend=[errh(path(end)),errv(path(end))];%校正后误差
end

