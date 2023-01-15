
%% When there is low renewable energy i.e the load exceed the the sum of solar and wind source 

%%

xx=1; yy=24;        %% lower and upper boundary for load partitioning into 24hours
jj=ones(365,24);
for k=1:365
    jj(k,:)= xx:yy;
    xx=xx+24; yy=yy+24;
    
end

 [row,~]=find(jj==t);         % locate the index boundary of the load value to determine shifting range in 24hours                         

 max_range_load=max(jj(row,:)); % boundary of the load value to determine shifting range in 24hours

%%

  if Pw(t)+Pp(t)<(Pl(t)/uinv) & t < max_range_load %% if true proceed with load shift, i.e renewable less than load  and within time interval check
  
  load_shift=(Pl(t)/uinv)-(Pw(t)+Pp(t)); % equation( 18) in the publication, load shift value at time instance
  if  load_shift >.2*Pl(t)     
      load_shift=.2*Pl(t);  % equation 19 in the publication              
  end 
  
% check for location with surplus renewable energy for load shift
Pl_range=Pl(t+1:max_range_load);  % range for load within 24hours
Pw_range=Pw(t+1:max_range_load);   
Pp_range= Pp(t+1:max_range_load);
Pwv_sum_range=Pw_range + Pp_range'; % sum renenewable energy in 24hours
high_rene=Pwv_sum_range-(Pl_range/uinv); % surplus renew
[kk]= find( high_rene>0); % index location for surplus renewable energy

 if ~isempty(kk)    %check if there is availabe renewable energy in future
 cc=  high_rene(kk); %value of the available renewable energy
 sum_high_rene= sum(cc); 

 if  sum_high_rene < load_shift 
     load_shift= sum_high_rene;   % equation (20) in the publication 
 end
 
if load_shift > 0               % iterate until load shift is zero
 
for i=1:1:length(Pl_range)
    
          if high_rene(i) > 0 & high_rene(i) > load_shift    % check if available renwable at the time exceed required load shift
          Pl(t+i)=load_shift + Pl(t+i);                      % shift load to future
          Pl(t)=Pl(t)-load_shift;                            %  reduce present load
          load_shift=0;                     
          break                                               % exit
          elseif high_rene(i) < load_shift &  high_rene(i)>0  %insufficient renewable energy to absorb the total loadshift at the time
          load_shiff_diff= load_shift-high_rene(i);       %reduce load shift at the time
          Pl(t+i)= load_shiff_diff+ Pl(t+i);               % increase future load by the difference
          Pl(t)=Pl(t)-load_shiff_diff;                     %reduce present load by the diff
          load_shift=load_shift-load_shiff_diff;           % new load shift
          end
end

end 

 end
 end