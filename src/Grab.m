classdef Grab
    %G Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        downPos;
        robot;
        nextState;
        open = 0;
        close = 90;
        SERVO_WAIT = 250;
        state;
    end
    
    methods
        function obj = Grab(moveDown, robot)
            obj.downPos = moveDown;
            obj.robot = robot;
        end
        
        
        function update(obj)
            %moveDown is the xyz coordinate where the arm should move down
            switch(obj.state)
                case subStates.INIT
                    obj.nextState = subStates.ARM_WAIT; %Set the next state after waiting for the gripper
                    obj.robot.pathPlanTo(obj.downPos); %Path Plan to Down Pos
                    obj.robot.setGripper(obj.open); %Set Gripper To Open
                    tic %Start Timer
                    obj.state = subStates.GRIPPER_WAIT; %Go to GRIPPER WAIT to wait for timer to finish
                    
                case subStates.ARM_WAIT
                    if obj.robot.isRobotDone() == 1
                        obj.nextState = subStates.Done;
                        tic
                        obj.state = subStates.GRIPPER_WAIT;
                    end
                    
                case subStates.GRIPPER_WAIT
                    if(toc > obj.SERVO_WAIT)
                        obj.state = obj.nextState;
                    end
                    
                case subStates.DONE
                    
            end
        end
        
    end
end
