%% 


                         %when there is surplus renewable energy
                         
                         if t<max_range_load  % time interval check
                         Pl_range=Pl(t+1:max_range_load);  % range for load within 24hours
                         Pw_range=Pw(t+1:max_range_load);
                         Pp_range= Pp(t+1:max_range_load);
                         Pwv_sum_range=Pw_range +Pp_range'; % sum rene in 24hours
                         high_load=(Pl_range/uinv)-Pwv_sum_range; % surplus renew
                         [kk]= find(high_load > 0);   % check for high future load for shifting
                         
                          if ~isempty(kk)  
                          cc= max(high_load(kk)); % check for max load
                          bb=find(cc== high_load); % find index where high_load equals cc
                          aa=bb(1);
                          load_shift= high_load(aa);  % determine load shift
                          
%                              
                          if  load_shift >.2*Pl(t+aa)    % for 20% load shift
                              load_shift=.2*Pl(t+aa);
                          end 
                          
                         
                          if Edump(t) > load_shift        % excess unused renewable 
                          Pl(t+aa)= Pl(t+aa)- load_shift;  % reduce the future load
                          Pl(t)=Pl(t)+load_shift;           % increase presence load
                          Edump(t)=Edump(t)-load_shift;     % decrease Edump
                          
                          elseif  Edump(t)< load_shift    % if excess unused renewable exceed load_shift
                          Pl(t+aa)= Pl(t+aa)- Edump(t);   % shift by the Edump
                          Pl(t)=Pl(t)+Edump(t);            % increase present load
                          Edump(t)=0 ;                      % Edump zero
                                                         
                          end
                         
                          end
                          end