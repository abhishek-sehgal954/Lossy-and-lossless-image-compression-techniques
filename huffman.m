function [sig_encoded dict symbol] = huffman( string )
symbol=[];                                %initialise variables
count=[];
j=1;
%------------------------------------------loop to separate symbols and how many times they occur
for i=1:length(string)                   
  flag=0;    
  flag=ismember(symbol,string(i));      %symbols
      if sum(flag)==0
      symbol(j) = string(i);
      k=ismember(string,string(i));
      c=sum(k);                         %no of times it occurs  
      count(j) = c;
      j=j+1;
      end 
end    
ent=0;
total=sum(count);                         %total no of symbols
prob=[];                                         
%-----------------------------------------for loop to find probability and
for i=1:1:size((count)');                   
prob(i)=count(i)/total ;            
end
[dict avglen]=huffmandict(symbol,prob); %creating the huffman dictionary
sig_encoded=huffmanenco(string,dict) ;
prob ;
symbol ;
end

