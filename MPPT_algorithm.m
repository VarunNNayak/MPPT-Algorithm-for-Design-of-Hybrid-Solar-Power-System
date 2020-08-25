% Varun Niranjan Nayak_MPPT algorithm
function duty = MPPT_algorithm(vpv,ipv,delta)
% Incremental Conductance MPPT algorithm 
duty_init = 0.1;
% Min and max value are used to limit duty between 0 and 1.06
duty_min=0;
duty_max=1.06;

persistent Vold Pold duty_old;
% Persistent variable type can store the data
% We need the old data by obtaining difference between old and new value
if isempty(Vold)
    Vold=0;
    Pold=0;
    duty_old=duty_init;
end
P= vpv*ipv; % power
dV= vpv - Vold; % difference between old and new voltage
dP= P - Pold;% difference between old and new power

% The algorithm in below search the dP/dV=0
% If the derivative equal to zero
% duty will not change if old and new power not equal &
% pv voltage bigger than 30V the algorithm will work
if dP ~= 0 && vpv>30
    if dP < 0
        if dV < 0
            duty = duty_old - delta;
        else
            duty = duty_old + delta;
        end
    else
        if dV < 0
            duty = duty_old + delta;
        else
            duty = duty_old - delta;
        end
    end
else
    duty = duty_old;
end

%If limits the duty between min and max
if duty >= duty_max
    duty=duty_max;
elseif duty<duty_min
    duty=duty_min;
end

% Stored data
duty_old=duty;
Vold=vpv;
Pold=P;