	function [d]=datnum(n,m)
		cll=0;
		n=n-1;
		d=ones(n+1);
		AAA=cell(n+1,n+1);
		ld=0;
		if m==1 && n==1
			for i=0:n
				s=0;
				for j=0:n
					if j~=i
						d(i+1,j+1)=(((-1)^(m-j))*factorial(m)*1)/(factorial(j)*factorial(n-j));
						s=s+d(i+1,j+1);
					end
				end
				d(i+1,i+1)=-1*s;
			end
			return
		end
		for i=0:n
			for j=0:n
				K=[];
				for k=0:n
					if k~=j
						if k~=i
							if j~=i
								K=[K,k-i];
							end
						end
					end
				end
				if ~isempty(K)
					lop=length(K);
					if m==1 && m~=n
						AA2=cumprod(K);
						AA=AA2(lop);
					elseif m==n
						AA=1;
					elseif m==n-1
						AA=cumsum(K);
						AA=AA(length(K));
					elseif m==n-2
						L=K;
						s=0;
						for f1=1:2*n-m
							for k1=f1+1:lop
								pr=1*L(f1)*L(k1);
								s=s+pr;
							end
						end
						AA=s;
					else
						c=nchoosek(K,(n-m));
						dr=cumprod(c')';
						as=size(dr);
						df=dr(:,as(2));
						ld=ld+1;
						cll=cll+1;						
						sss=0;
						for gh=1:as(1)
							sss=sss+df(gh);
						end
						AA=sss;	
					end
					AAA{i+1,j+1}=AA;
				end
			end
		end
		for i=0:n
			s=0;
			for j=0:n
				if j~=i
					d(i+1,j+1)=(((-1)^(m-j))*factorial(m)*AAA{i+1,j+1})/(factorial(j)*factorial(n-j));
					s=s+d(i+1,j+1);
					ld=ld+1;
				end
			end
			d(i+1,i+1)=-1*s;
		end