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
pn=0;po=1;    %pn������С�����ʺͣ�po�����������ڼ���

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
code(1:leng*2-1,1)='2';%��Ϊ��β��Ҳ�ǳ�ʼ��dimension֮��,����len�Ϳ�����
pos1=pos(p,tree(po,1),code);
pos2=pos(p,tree(po,2),code);
code(pos1,1:2)='12';
code(pos2,1:2)='02';
count=0;
for k=po:(-1):2
    %for the first
    position=posi(p,tree(k,1),code);%��һ���Ҳ�����δ����ֵ�ģ��ҵ����У���Ҫ�����ӽڵ�
    if position>leng    %�ҵ�ǰ256���еģ��������£���Ϊ�ѱ����ڵ㸳ֵ��
        position=rem(position,leng);
        cc=code(posi(p,tree(k,1),code),:);
        pos1=pos(p,tree(position,1),code);%����Ҫ��δ����ֵ�ģ�Ϊ�˸�ֵ
        if pos1~=0
            code(pos1,1:length(cc))=cc;  
            code(pos1,len(cc)+1)='1';
            code(pos1,len(cc)+2)='2';
            %һ��ʼ��������code���������ֻ��2����ʾδ���루δ�������������ǲ�����ģ����ⷢ��
            %��Щ2��code�е�λ�ö���tree������������ȵ�λ�ã���Ҫ�ȵ�p���ҵ���Ӧ�ĸ��ʣ���ȥtree�ң�
            %Ȼ��֪����ԭ����pos�����⡣���pos��û�и�ֵ����ô��һ��pos�϶��õ�����һ��һ���Ľ����
            %���Ǿ�����һ��code
            %Ϊʲô���ܰ�=��1����=��2��Ҳ������д�أ�
            %��Ϊ������д��code��dimension�������ˣ���һ�ξͲ���=cc�ˣ�ֻ�ɸ�dimension��ģ����ɸ�С�ģ�
            %��ʵ���֪�������ϳɹ��ˣ�2ֻ�����������28/256����˵���㷨û�����ǵ���©�����������
            %���codeҲ�ǰ��ո��ʵ������ݼ��ģ���������
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

   
    
    
    
    
    
    
    
    

    