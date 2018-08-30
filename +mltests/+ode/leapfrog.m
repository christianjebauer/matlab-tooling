classdef leapfrog < matlab.unittest.TestCase
  % LEAPFROG tests the leapfrog integration algorithm
  
  
  %% CLASS PROPERTIES
  properties
    
    % Maximum mass
    m_ = 10;
    % Actual mass
    m
    
    % Damping
    D = 0.01;
    
    % Eigenfrequency
    omega0 = 6/(2*pi);
    
    % Maximum initial position
    x0_ = 0.0;
    % Actual initial position
    x0
    % Maximum initial velocity
    v0_ = 1.0;
    % Actual initial velocity
    v0
    
    % Maximum magnitude of external foorce
    f0 = 5.0;
    % Time till force decays
    Tf = 10.0;
    % Scaling of eriodic frequency of external force wrt Eigenfrequency
    w = 0.8;
    
    % Step size
    h = 1e-2;
    % Final time
    T = 20.0;
    
    % Figure window handle
    HFig
    
    % Simulation result: time
    t
    % Simulation result: position
    x
    % Simulation result: velocity
    v
    % Name of test just run
    testname
    
  end
  
  
  %% TESTPARAMETERS
  properties ( TestParameter )

  end
  
  
  
  %% TESTMETHODSETUP
  methods ( TestMethodSetup )
    
    function createFigure(this)
      %% CREATEFIGURE creates the target figure
      
      % Create an invisible figure
      this.HFig = figure('Visible', 'off');
      
    end
    
    
    function randomizeParameters(this)
      
      this.m = this.m_*(1 + rand([1, 1]));
      this.x0 = this.x0_.*rand([1, 1]);
      this.v0 = this.v0_.*rand([1, 1]);
      
    end
    
  end
  
  
  
  %% TESTMETHODTEARDOWN
  methods ( TestMethodTeardown )
    
    function fillFigure(this)
      %% FILLFIGURE with simulation results
      
      
      % Select figure
      figure(this.HFig);
      
      % Get test name: remove the class name from the testname
      this.testname = last(strsplit(this.testname, '.'));
      
      % Set name of figure
      this.HFig.Name = this.testname;
      
      % Position/Positions
      hax(1) = subplot(2, 1, 1 ...
        , 'Parent', this.HFig ...
      );
      plot(hax(1) ...
        , this.t, this.x ...
      );
      xlabel(hax(1) ...
        , 'Time $t / \mathrm{s}$' ...
        , 'Interpreter', 'latex' ...
      );
      ylabel(hax(1) ...
        , 'Position $x / \mathrm{m}$' ...
        , 'Interpreter', 'latex' ...
      );
      
      % Velocity/Velocities
      hax(2) = subplot(2, 1, 2 ...
        , 'Parent', this.HFig ...
      );
      plot(hax(2) ...
        , this.t, this.v ...
      );
      xlabel(hax(2) ...
        , 'Time $t / \mathrm{s}$' ...
        , 'Interpreter', 'latex' ...
      );
      ylabel(hax(2) ...
        , 'Velocity $\dot{x} / \mathrm{m}\mathrm{s}^{-1}$' ...
        , 'Interpreter', 'latex' ...
      );
      
      % Update drawing
      drawnow();
      
      % Save figure to file
      saveas(this.HFig, this.testname, 'tiff');
      
      % Close figure
      close(this.HFig);
      
    end
    
  end

  
  
  %% TESTS
  methods ( Test )
      
    function drivenHarmonicOscillator(this)
      %% DRIVENHAROMONICOSCILLATOR

      tsp = tspan(0, this.T, this.h);

      function F = frc(t_, x_, v_)
        F = this.f0.*cos(this.w.*this.omega0.*(t_ - 20)).*exp(-(t_./this.Tf).^2);
      end

      function f = ode_rhs(t_, x_, v_)
        f = (-this.omega0^2*x_ - 2*this.D*this.omega0*v_ + frc(t_, x_, v_))/this.m;
      end

      [this.t, this.x, this.v] = leapfrog(@ode_rhs, tsp, this.x0, this.v0);

      this.assertNotEmpty(this.t);
      this.assertNotEmpty(this.x);
      this.assertNotEmpty(this.v);
      this.assertSize(this.t, size(tsp));
      this.assertSize(this.x, [numel(tsp), 1]);
      this.assertSize(this.v, [numel(tsp), 1]);
      this.assertEqual(this.t, tsp, 'AbsTol', 1000*eps);
      
      this.testname = funcname();

    end


    function drivenHarmonicOscillator_ConstantMassMatrix(this)
      %% DRIVENHAROMONICOSCILLATOR_CONSTANTMASSMATRIX

      tsp = tspan(0, this.T, this.h);

      function F = frc(t_, x_, v_)
        F = this.f0.*cos(this.w.*this.omega0.*(t_ - 20)).*exp(-(t_./this.Tf).^2);
      end

      function f = ode_rhs(t_, x_, v_)
        f = -this.omega0^2*x_ - 2*this.D*this.omega0*v_ + frc(t_, x_, v_);
      end

      [this.t, this.x, this.v] = leapfrog(@ode_rhs, tsp, this.x0, this.v0, odeset('Mass', this.m));

      this.assertNotEmpty(this.t);
      this.assertNotEmpty(this.x);
      this.assertNotEmpty(this.v);
      this.assertSize(this.t, size(tsp));
      this.assertSize(this.x, [numel(tsp), 1]);
      this.assertSize(this.v, [numel(tsp), 1]);
      this.assertEqual(this.t, tsp, 'AbsTol', 1000*eps);
      
      this.testname = funcname();

    end


%     function drivenHarmonicOscillator_TimeDependentMassMatrix(this)
%       %% DRIVENHAROMONICOSCILLATOR_TIMEDEPENDENTMASSMATRIX
% 
%       tsp = tspan(0, this.T, this.h);
% 
%       function F = frc(t_, x_, v_)
%         F = this.f0.*cos(this.w.*this.omega0.*(t_ - 20)).*exp(-(t_./this.Tf).^2);
%       end
% 
%       function f = ode_rhs(t_, x_, v_)
%         f = -this.omega0^2*x_ - 2*this.D*this.omega0*v_ + frc(t_, x_, v_);
%       end
% 
%       [this.t, this.x, this.v] = leapfrog(@ode_rhs, tsp, this.x0, this.v0, odeset('Mass', @(t_) this.m, 'MStateDependence', 'none'));
% 
%       this.assertNotEmpty(this.t);
%       this.assertNotEmpty(this.x);
%       this.assertNotEmpty(this.v);
%       this.assertSize(this.t, size(tsp));
%       this.assertSize(this.x, [numel(tsp), 1]);
%       this.assertSize(this.v, [numel(tsp), 1]);
%       this.assertEqual(this.t, tsp, 'AbsTol', 1000*eps);
%       
%       this.testname = funcname();
% 
%     end


    function drivenHarmonicOscillator_StateDependentMassMatrix(this)
      %% DRIVENHAROMONICOSCILLATOR_STATEDEPENDENTMASSMATRIX

      tsp = tspan(0, this.T, this.h);

      function F = frc(t_, x_, v_)
        F = this.f0.*cos(this.w.*this.omega0.*(t_ - 20)).*exp(-(t_./this.Tf).^2);
      end

      function f = ode_rhs(t_, x_, v_)
        f = -this.omega0^2*x_ - 2*this.D*this.omega0*v_ + frc(t_, x_, v_);
      end

      [this.t, this.x, this.v] = leapfrog(@ode_rhs, tsp, this.x0, this.v0, odeset('Mass', @(t_, x_, v_) this.m));

      this.assertNotEmpty(this.t);
      this.assertNotEmpty(this.x);
      this.assertNotEmpty(this.v);
      this.assertSize(this.t, size(tsp));
      this.assertSize(this.x, [numel(tsp), 1]);
      this.assertSize(this.v, [numel(tsp), 1]);
      this.assertEqual(this.t, tsp, 'AbsTol', 1000*eps);
      
      this.testname = funcname();

    end
    
    
    function drivenHarmonicOscillators(this)
      %% DRIVENHAROMONICOSCILLATORS

      tsp = tspan(0, this.T, this.h);

      function F = frc(t_, x_, v_)
        F = this.f0.*cos(this.w.*this.omega0.*(t_ - 20)).*exp(-(t_./this.Tf).^2);
      end

      function f = ode_rhs(t_, x_, v_)
        f = (-this.omega0^2.*x_ - 2*this.D.*this.omega0.*v_ + frc(t_, x_, v_))./this.m;
      end

      [this.t, this.x, this.v] = leapfrog(@ode_rhs, tsp, this.x0.*rand(3, 1), this.v0.*rand(3, 1));

      this.assertNotEmpty(this.t);
      this.assertNotEmpty(this.x);
      this.assertNotEmpty(this.v);
      this.assertSize(this.t, size(tsp));
      this.assertSize(this.x, [numel(tsp), 3]);
      this.assertSize(this.v, [numel(tsp), 3]);
      this.assertEqual(this.t, tsp, 'AbsTol', 1000*eps);
      
      this.testname = funcname();

    end


    function drivenHarmonicOscillators_StateDependentMassMatrix(this)
      %% DRIVENHAROMONICOSCILLATORS_STATEDEPENDENTMASSMATRIX

      tsp = tspan(0, this.T, this.h);

      function F = frc(t_, x_, v_)
        F = this.f0.*cos(this.w.*this.omega0.*(t_ - 20)).*exp(-(t_./this.Tf).^2);
      end

      function f = ode_rhs(t_, x_, v_)
        f = -this.omega0^2.*x_ - 2*this.D.*this.omega0.*v_ + frc(t_, x_, v_);
      end

      [this.t, this.x, this.v] = leapfrog(@ode_rhs, tsp, this.x0.*rand(3, 1), this.v0.*rand(3, 1), odeset('Mass', @(t_, x_, v_) this.m));

      this.assertNotEmpty(this.t);
      this.assertNotEmpty(this.x);
      this.assertNotEmpty(this.v);
      this.assertSize(this.t, size(tsp));
      this.assertSize(this.x, [numel(tsp), 3]);
      this.assertSize(this.v, [numel(tsp), 3]);
      this.assertEqual(this.t, tsp, 'AbsTol', 1000*eps);
      
      this.testname = funcname();

    end

  end
  
end
