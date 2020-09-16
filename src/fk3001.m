
function EEPos = fk3001(jointAngles)
%FK3001 reutnrs a 3x1 matrix for end effector position based on a 3x1
%matrix of join angles
%   Detailed explanation goes here
    jointAngles = deg2rad(jointAngles);
    T0to2 = DHtoMatrix(jointAngles(1),95,0,-pi/2);
    T2to3 = DHtoMatrix(jointAngles(2)-(pi/2), 0,100,0);
    T3to4 = DHtoMatrix(jointAngles(3)+(pi/2),0,100,0);
    
    FinalMatrix = T0to2 * T2to3 * T3to4;
    
    EEPos = zeros(3,1);
    EEPos(1) = FinalMatrix(1,4);
    EEPos(2) = FinalMatrix(2,4);
    EEPos(3) = FinalMatrix(3,4);
end

function Tmatrix = DHtoMatrix(Theta,D,A,Alpha)
    Tmatrix = zeros(4,'double');
    
    %Row 1
    Tmatrix(1,1) = cos(Theta);
    Tmatrix(1,2) = -sin(Theta)*cos(Alpha);
    Tmatrix(1,3) = sin(Theta)*sin(Alpha);
    Tmatrix(1,4) = A*cos(Theta);
    
    %Row 2
    Tmatrix(2,1) = sin(Theta);
    Tmatrix(2,2) = cos(Theta)*cos(Alpha);
    Tmatrix(2,3) = -cos(Theta)*sin(Alpha);
    Tmatrix(2,4) = A*sin(Theta);
    
    %Row 3
    Tmatrix(3,2) = sin(Alpha);
    Tmatrix(3,3) = cos(Alpha);
    Tmatrix(3,4) = D;
    
    Tmatrix(4,4) = 1;
end