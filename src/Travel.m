classdef Travel
    %TRAVELSTATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dest;
        robot;
        
    end
    
    methods
        function obj = Travel(destination)
            obj.dest = destination;
        end
        
        function update(~)
            state = subStates.INIT;
                       
            switch(state)
                case subStates.INIT
                    robot.currentSetpoint = [0 0 0];
                    state = subStates.ARM_WAIT;
                    toTarget = 1;
                case subStates.ARM_WAIT
                    if robot.isAtTarget() == 0
                        robot.setSetpointsSlow(kinematics.fk3001();
                        pause(0.3);
                    end
                    robot.currentSetpoint = [obj.dest(1) obj.dest(2) obj.dest(3)];
                    state = ARM_WAIT;
                    else
                        while robot.isAtTarget() == 0
                            robot.setSetpointsSlow(kinematics.fk3001([obj.dest(1) obj.dest(2) obj.dest(3)]));
                            pause(0.3);
                        end
                        state = subStates.DONE;
                    end
                case subStates.DONE
                    %Clear activeColor
            end
        end
    end
end

