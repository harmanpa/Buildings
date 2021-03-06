within Buildings.Fluid.HeatExchangers.Examples;
model DryEffectivenessNTUMassFlow
  "Model of epsilon-NTU dry coil that tests variable mass flow rates"
  extends Modelica.Icons.Example;
  import Buildings;
  extends
    Buildings.Fluid.HeatExchangers.Examples.BaseClasses.EffectivenessNTUMassFlow(
    sou_1(nPorts=1),
    sin_1(nPorts=1),
    sou_2(nPorts=1),
    sin_2(nPorts=1));

  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal(displayUnit="Pa") = 3000,
    Q_flow_nominal=Q_flow_nominal,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    show_T=true)             annotation (Placement(transformation(extent={{40,20},
            {60,40}},     rotation=0)));

  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
                                                     redeclare package Medium
      = Medium2, m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{20,14},{0,34}})));
equation
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{18,62},{28,62},{28,36},{40,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{60,36},{90,36},{90,60},{120,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{60,24},{118,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port_a, hex.port_b2) annotation (Line(
      points={{20,24},{40,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port_b, sin_2.ports[1]) annotation (Line(
      points={{-5.55112e-16,24},{-22,24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}}), graphics),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/DryEffectivenessNTUMassFlow.mos"
        "Simulate and plot"));
end DryEffectivenessNTUMassFlow;
