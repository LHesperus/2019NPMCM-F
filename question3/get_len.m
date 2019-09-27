function len= get_len(x,y,z)
pos=[x.';y.';z.'];
pos2=pos(:,2:end)-pos(:,1:end-1);
len=sum(sqrt(sum(pos2.^2,1)));
end

