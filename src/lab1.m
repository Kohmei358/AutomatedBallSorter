%%
% RBE3001 - Laboratory 1
%
% Instructions
% ------------
% Welcome again! This MATLAB script is your starting point for Lab
% 1 of RBE3001. The sample code below demonstrates how to establish
% communication between this script and the Nucleo firmware, send
% setpoint commands and receive sensor data.
%
% IMPORTANT - understanding the code below requires being familiar
% with the Nucleo firmware. Read that code first.

% Lines 15-37 perform necessary library initializations. You can skip reading
% to line 38.
clear
clear java
clear classes;

vid = hex2dec('16c0');
pid = hex2dec('0486');

disp (vid);
disp (pid);

javaaddpath ../lib/SimplePacketComsJavaFat-0.6.4.jar;
import edu.wpi.SimplePacketComs.*;
import edu.wpi.SimplePacketComs.device.*;
import edu.wpi.SimplePacketComs.phy.*;
import java.util.*;
import org.hid4java.*;
version -java
myHIDSimplePacketComs=HIDfactory.get();
myHIDSimplePacketComs.setPid(pid);
myHIDSimplePacketComs.setVid(vid);
myHIDSimplePacketComs.connect();

% Create a PacketProcessor object to send data to the nucleo firmware
pp = Robot(myHIDSimplePacketComs);
try

    SERV_ID = 1848;            % we will be talking to server ID 1848 on
    % the Nucleo
    SERVER_ID_READ =1910;% ID of the read packet
    DEBUG   = true;          % enables/disables debug prints
    
    % Instantiate a packet - the following instruction allocates 64
    % bytes for this purpose. Recall that the HID interface supports
    % packet sizes up to 64 bytes.
    packet = zeros(15, 1, 'single');
    
    % The following code generates a sinusoidal trajectory to be
    % executed on joint 1 of the arm and iteratively sends the list of
    % setpoints to the Nucleo firmware.
    
    motorValsArray = zeros(3000,3,'single');
    
    for k = 0:1
        
        %wating on converting this to setSetpoints untill Jason finsishes
        %the fucntion...
        packet = zeros(15, 1, 'single');
        packet(1) = 500;%one second time
        packet(2) = 0;%linear interpolation
        packet(3) = 0; % -90 -> 90
        packet(4) = 0;% Second link to 90 -> -45
        packet(5) = 0;% Third link to -90 -> 45
        
        % Send packet to the server and get the response
        %pp.write sends a 15 float packet to the micro controller
        pp.write(SERV_ID, packet);
        %pp.read reads a returned 15 float backet from the micro controller.
        motorValsArray(k+1,:) = pp.getPositions;
        disp(pp.getPositions);
        
    end
    
    figure(1)
    plot(1:length(motorValsArray),motorValsArray(:,1),"*r")
    title("Motor 1 positon V.S. Time")
    xlabel("Time (Number of for loops)")
    ylabel("Angle of motor 1 (Degrees)")
    
    figure(2)
    plot(1:length(motorValsArray),motorValsArray(:,2),"*r")
    title("Motor 2 positon V.S. Time")
    xlabel("Time (Number of for loops)")
    ylabel("Angle of motor 2 (Degrees)")
    
    figure(3)
    plot(1:length(motorValsArray),motorValsArray(:,3),"*r")
    title("Motor 3 positon V.S. Time")
    xlabel("Time (Number of for loops)")
    ylabel("Angle of motor 3 (Degrees)")
    
catch exception
    getReport(exception)
    disp('Exited on error, clean shutdown');
end
% Clear up memory upon termination
pp.shutdown()
