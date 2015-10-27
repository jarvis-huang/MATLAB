function [val, code] = my_huff_encode(i)

i=reshape(i,1,[]); %convert to one-line array
if max(i)==min(i)
    val = i(1);
    code = '02';
    return;
end
edge=min(i):max(i);
p=histc(i,edge);  %calculate the number(probability) of gray code in each 0--255 code
p=p/sum(p);       %number/sum=probability
[p,gray]=sort(p); %sort from smallest to greatest
pp=p;
%if sum(p)~=1
%    error('Sum not equal to 1.');
%end

leng=length(p);
pn=0;po=1;    %pn计算最小两概率和，po计算生成树第几层

while(1)
    if(pn>=1) break;
    else
        [pm,p2]=min(p(1:leng));p(p2)=1.1;  % probability =1.1, avoid being selected again
        [pm2,p3]=min(p(1:leng));p(p3)=1.1;
        pn=pm+pm2;
        p(leng+1)=pn;
        tree(po,1)=pm;tree(po,2)=pm2;
        po=po+1;leng=leng+1;
    end
end
p=pp;
leng=max(i)-min(i)+1;
p(leng+1:2*leng-1)=tree(:,1)'+tree(:,2)';
po=po-1;
c(po,1)='0';
c(po,2)='1';
code(1:leng*2-1,1)='2';%作为结尾，也是初始化dimension之用,这样len就可用了
pos1=pos(p,tree(po,1),code);
pos2=pos(p,tree(po,2),code);
code(pos1,1:2)='12';
code(pos2,1:2)='02';
count=0;
for k=po:(-1):2
    %for the first
    position=posi(p,tree(k,1),code);%第一次找不用找未赋过值的，找到就行，主要是找子节点
    if position>leng    %找到前256个中的，不用做事，因为已被父节点赋值了
        position=rem(position,leng);
        cc=code(posi(p,tree(k,1),code),:);
        pos1=pos(p,tree(position,1),code);%现在要找未赋过值的，为了赋值
        if pos1~=0
            code(pos1,1:length(cc))=cc;  
            code(pos1,len(cc)+1)='1';
            code(pos1,len(cc)+2)='2';
            %一开始发现最终code中有许多项只有2，表示未编码（未遍历到），这是不允许的，另外发现
            %这些2在code中的位置都是tree中左右两项相等的位置（需要先到p中找到相应的概率，再去tree找）
            %然后知道，原来是pos的问题。如果pos后没有赋值，那么下一个pos肯定得到和上一个一样的结果，
            %于是就少了一个code
            %为什么不能把=‘1’，=‘2’也提上来写呢？
            %因为提上来写，code的dimension就增大了，下一次就不能=cc了（只可赋dimension大的，不可赋小的）
            %其实早就知道基本上成功了，2只是少数情况（28/256），说明算法没错，就是当中漏掉了特殊情况
            %结果code也是按照概率递增而递减的，符合理论
        end
        pos2=pos(p,tree(position,2),code);
        if pos2~=0
            code(pos2,1:length(cc))=cc;
            code(pos2,len(cc)+1)='0';
            code(pos2,len(cc)+2)='2';
        end
    
    end
    %for the second
    position=posi(p,tree(k,2),code);
    if position>leng
       position=rem(position,leng);
       cc=code(posi(p,tree(k,2),code),:);
       if tree(k,2)==tree(k,1)
           new_pos = pos(p,tree(k,2),code);
           if new_pos~=0
               cc=code(new_pos,:);
           else
               continue;
           end
       end
       pos1=pos(p,tree(position,1),code);
       if pos1~=0
           code(pos1,1:length(cc))=cc; 
           code(pos1,len(cc)+1)='1';
           code(pos1,len(cc)+2)='2';
       end
       pos2=pos(p,tree(position,2),code);
       if pos2~=0
           code(pos2,1:length(cc))=cc;   
           code(pos2,len(cc)+1)='0';
           code(pos2,len(cc)+2)='2';
       end
    end
end

code=code(1:leng,:);
val = edge(gray);
% For the same index,
% code gives the 1/0 bitstream code (terminated by a '2'),
% while val gives the actual data that corresponds to this code

   
    
    
    
    
    
    
    
    

    