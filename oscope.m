function y = oscope(asuiohg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    clear all;
    close all;
    SampleRate = 48000;
    FrameSize = 24000;
    
    TB = str2num(input('Choose time base 1 = 0.2, 2 = 0.1, 3 = 0.05, 4 = 0.02, 5 = 0.01 ', 's'));
    GF = str2num(input('Choose a gain factor: ', 's'));
    TimeBase = [.2, .1, .05, .02, .01];
    Increment = TimeBase(TB)*100;

    try % VERY IMPORTANT

        % This sets up the characteristics of playback
        ap = dsp.AudioPlayer;
        set(ap, 'SampleRate', SampleRate);
        set(ap, 'BufferSizeSource', 'Property');
        set(ap, 'BufferSize', FrameSize);
        set(ap, 'QueueDuration', 0.3);

        % This sets up the characteristics of recording
        ar = dsp.AudioRecorder;
        set(ar, 'DeviceDataType', '16-bit integer');
        set(ar, 'SamplesPerFrame', FrameSize);
        set(ar, 'SampleRate', SampleRate);

        % This records the first set of data
        disp('Starting processing');
        input_data = step(ar); % This gets the first block of data from the sound card.
        loop_count = 0;
        while loop_count < 10
            loop_count = loop_count + 1;

            %%%%%% Put your dsp code or function call here! %%%%%%%%%%%%%%%%%%%%

            y_data = input_data*GF;
            trigger = .7*max(y_data);
            starting_point_1 = 0;
            starting_point_2 = 0;
            for i = 1:length(y_data),
                if(y_data(i,1) >= trigger)
                    starting_point_1 = i;
                    break;
                end
               
            end
            for i = 1:length(y_data),
               
                if(y_data(i,2) >= trigger)
                    starting_point_2 = i;
                    break;
                end
            end
            
            data_to_plot_1 = y_data(starting_point_1:Increment:starting_point_1+479*Increment,1);
            data_to_plot_2 = y_data(starting_point_2:Increment:starting_point_2+479*Increment,2);
            %data_to_plot=[data_to_plot_1;data_to_plot_2];
            
            x_axis=[0:TimeBase(TB)/480:TimeBase(TB)-TimeBase(TB)/480];
            
            figure(1);
            plot(x_axis,data_to_plot_1, x_axis,data_to_plot_2, 'g');
            %plot(x_axis,data_to_plot_2, 'g');
            axis([0 TimeBase(TB) -1.5*GF 1.5*GF]);
            title('My O-scope');
            xlabel('Time(s)');
            ylabel('Voltage(V)');
            grid on;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %step(ap, y_data); %PLAYING
            input_data = step(ar);       
            drawnow;
        end

        % You want to make sure that you release the system resources after using
        % them and they don't get tied up.
        release(ar)
        release(ap)

    catch err 
        release(ar)
        release(ap)
        rethrow(err)
    end

    y = 0;

end

