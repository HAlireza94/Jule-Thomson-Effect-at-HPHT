function [Pr, Tr, V]=Calculation_JTIC_PR_EoS_For_Pure(alpha_Function,p,Pc,Tc,T,w)
  


R=8.3144598;


  a=(0.45724*(R^2)*(Tc^2))/Pc;
  b=(0.07780*R*Tc)/Pc;

    x0=(R*T)/p;
    Tr=T/Tc;
    
    
    switch lower(alpha_Function)

        case 'original'
        
        k=0.37464+(1.54226*w)-(0.26992*w^2);
        alpha=((1+(k*(1-(Tr^0.5))))^2);
        first_order_alpha=-(k/T)*(sqrt(Tr))*(sqrt(alpha));

        case 'coquelet'
            
         k1=0.41287+(1.34494*w)+(0.00421*w^2);
            k2=0.03982+(0.08551*w)-(1.05521*w^2);
            k3=-0.01871+(1.93328*w);


            if Tr>1
                
        alpha=exp(k1*(1-Tr));
        first_order_alpha=-(k1/Tc)*alpha;
       
            elseif Tr<1
                
           alpha=(((exp(k1*(1-(T/Tc)))))*((1+(k2*(1-sqrt(Tr))^2)+(k3*(1-sqrt(Tr))^3))^2));
     
        x1=(1/(Tc^4))*((((Tc^1.5)*(1+k2+k3-(k3*Tr^1.5)))-...
    (Tc*sqrt(T)*((2*k2)+(3*k3)))+(T*sqrt(Tc)*(k2+(3*k3))))^2);

x2=1+k2+k3-(sqrt(Tr)*((2*k2)+(3*k3)))+(Tr*(k2+(3*k3)))-(k3*Tr^1.5);

x3=((-((2*Tc*k2*(1-sqrt(Tr)))+((3*k3*(sqrt(Tc)-sqrt(T)))^2)))/(2*sqrt(T)*Tc^1.5));

% y1=((k2+(3*k3))/Tc)-(((2*k2)+(3*k3))/(2*sqrt(Tc)*sqrt(T)))-((1.5*k3*sqrt(Tr))/Tc);
% 
% y2=x3;
% 
% y3=(-((2*sqrt(Tc)*k2*(-sqrt(T)-(sqrt(Tc)*(1-sqrt(Tr)))))+(3*k3*(T-Tc)))/(4*(Tc*T)^1.5));
% 
% y4=x2;

% x4=((k1/Tc)^2)*(((exp(k1*(1-(T/Tc)))))*((1+(k2*(1-sqrt(Tr))^2)+(k3*(1-sqrt(Tr))^3))^2));
% 
% x5=2*(exp(k1*(1-Tr)))*((y1*y2)+(y3*y4));
% 
% x6=((-4*k1)/Tc)*y2*y4*(exp(k1*(1-Tr)));

first_order_alpha=(exp(k1*(1-Tr)))*((2*x2*x3)-(k1*x1));
% second_order_alpha=x4+x5+x6;
            
            end
            
        case 'haghtalab'
             
                n2=1.7309+(1.6571*w)+(0.1554*w^2);
            alpha=(exp(1-(n2^(log(Tr)))));    
first_order_alpha=((-(exp(1-(n2^(log(Tr)))))*(T^(log(n2)-1))*(log(n2)))/(Tc^(log(n2))));

%         second_order_alpha=(((-log(n2))*(exp(1-(n2^(log(Tr)))))*...
%     (Tr^(log(n2)))*((log(n2))-1-((log(n2))*(Tr^(log(n2))))))/(T^2));


            
        case 'saffari'
            
            k1=0.003091+(0.013145*w);
            k2=-0.006478+(0.482173*w);
            k3=(3.58616*w)+0.721306;
            alpha=(exp((k1*Tr)+(k2*(log(Tr)))+(k3*(1-(Tr^0.5)))));

            first_order_alpha=(exp((k1*Tr)+(k3*(1-(Tr^0.5)))))*...
                (((2*k2*(Tc^1.5)*(T^(k2-1)))-(k3*Tc*(T^(k2-0.5)))+...
                (2*k1*sqrt(Tc)*(T^k2)))/(2*(Tc^(k2+1.5))));
            
%             y1=((k2*(T^(k2-1)))/(Tc^k2))*((k2/T)-(k3/(2*sqrt(Tc)*sqrt(T)))+(k1/Tc));
%             
%             y2=(Tr^k2)*((k3/(4*(T^1.5)*sqrt(Tc)))-(k2/(T^2)));
                                    
%             second_order_alpha=((exp((k1*Tr)+(k3*(1-(Tr^0.5)))))*...
%                 ((k1/Tc)-(k3/(2*sqrt(Tc)*sqrt(T))))*(Tr^k2)*...
%                 ((k2/T)-(k3/(2*sqrt(Tc)*sqrt(T)))+(k1/Tc)))+...
%                 ((y1+y2)*(exp((k1*Tr)+(k3*(1-(Tr^0.5))))));                                                                                                    
    end
    
    
    
    F=@(x) (T*((R/(x-b))-((a*first_order_alpha)/((x^2)+(2*b*x)-(b^2)))))...
        +(x*((((2*a*alpha*(x+b))/(((x^2)+(2*b*x)-(b^2))^2)))-...
        ((R*T)/((x-b)^2))));
    
    V=fzero(F,x0);
    
    P=((R*T)/(V-b))-((a*alpha)/((V^2)+(2*b*V)-b^2));
    
    Pr=P/Pc;
    
 
end        