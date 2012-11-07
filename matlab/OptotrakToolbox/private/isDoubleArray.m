function [isDoubleArray] = isDoubleArray(var,nrows,ncols)
%Test if var is a 2dim array of type double with nrows and ncols
%If nrows or ncols are set to the character ':', then this 
%dimension is not checked...

isDoubleArray=true; 
if(~strcmp(class(var) ,'double')) 
  isDoubleArray=false; 
end
if(length(size(var))~=2) 
  isDoubleArray=false; 
end
if(~strcmp(nrows,':') & nrows~=length(var(:,1)))
    isDoubleArray=false; 
  end
if(~strcmp(ncols,':') & ncols~=length(var(1,:)))       
  isDoubleArray=false; 
end
