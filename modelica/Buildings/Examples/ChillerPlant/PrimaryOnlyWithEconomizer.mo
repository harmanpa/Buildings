within Buildings.Examples.ChillerPlant;
model PrimaryOnlyWithEconomizer
  "Chiller plant system with water side economizer for data center"
  extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.GasesPTDecoupled.SimpleAir "Medium model";
  package MediumCHW = Buildings.Media.ConstantPropertyLiquidWater
    "Medium model";
  package MediumCW = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=28.43
    "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=mAir_flow_nominal*
      1000/4200*18/23 "Nominal mass flow rate at chilled water";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=4*mCHW_flow_nominal/
      COPc_nominal*(COPc_nominal + 1)
    "Nominal mass flow rate at condenser water";
  parameter Modelica.SIunits.Pressure dp_nominal=500
    "Nominal pressure difference";
  Buildings.Fluid.Movers.FlowMachine_m_flow fan(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    m_flow_max=mAir_flow_nominal,
    dp(start=249),
    m_flow(start=mAir_flow_nominal),
    T_start=293.15)
    annotation (Placement(transformation(extent={{288,-235},{268,-215}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(
    redeclare package Medium1 = MediumCHW,
    redeclare package Medium2 = MediumAir,
    m2_flow_nominal=mAir_flow_nominal,
    m1_flow_nominal=mCHW_flow_nominal,
    dp1_nominal(displayUnit="Pa") = 100,
    UA_nominal=1e6,
    m1_flow(start=mCHW_flow_nominal),
    m2_flow(start=mAir_flow_nominal),
    dp2_nominal=249) "Cooling coil"
    annotation (Placement(transformation(extent={{238,-185},{218,-165}})));
  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{258,-211},
            {278,-191}}, rotation=0)));
  BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = MediumAir,
    nPorts=2,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    m_flow_nominal=mAir_flow_nominal,
    QRoo_flow=200000) "Room model"
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={204,-238})));
  inner Modelica.Fluid.System system(T_ambient=283.15)
    annotation (Placement(transformation(extent={{-322,-151},{-302,-131}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pumCHW(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    m_flow_max=mCHW_flow_nominal,
    dp(start=329460),
    m_flow(start=mCHW_flow_nominal)) "Chilled water pump" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={162,-126})));
  Modelica.Blocks.Sources.Constant mPumCHW(k=mCHW_flow_nominal)
    "Flow rate of primary system" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={114,-131})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumCHW, VTot=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{198,-147},{218,-127}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=6,
    dp_nominal=47776) "Cooling tower" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={208,233})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pumCW(
    redeclare package Medium = MediumCW,
    m_flow_max=mCW_flow_nominal,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=37474)) "Condenser water pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={290,216})));
  Modelica.Blocks.Sources.Constant mCWFlo(k=mCW_flow_nominal)
    "Flow rate of condenser water side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={244,209})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res4(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=1000) "Fixed resistance " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={128,203})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res3(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=1000) "Fixed resistance " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={290,181})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness wse(
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=59720,
    dp2_nominal=59720,
    eps=0.8) "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{68,83},{48,103}})));
  Fluid.Actuators.Valves.TwoWayLinear           val5(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=44790) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={128,153})));
  Fluid.Actuators.Valves.TwoWayLinear                    val1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=44790)
    "Bypass control valve for economizer. 1: disable economizer, 0: enable economoizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={162,-40})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium =
        MediumCW, VTot=1)
    annotation (Placement(transformation(extent={{178,143},{198,163}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl wseCon
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-148,-29})));
  Modelica.Blocks.Sources.RealExpression expTowTApp(y=cooTow.TApp_nominal)
    "Cooling tower approach" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-218,-65})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=89580,
    dp2_nominal=89580,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_823kW_6_28COP_Vanes())
    annotation (Placement(transformation(extent={{218,83},{198,103}})));
  Fluid.Actuators.Valves.TwoWayLinear           val6(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=44790) "Control valve for chilled water leaving from chiller"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={292,33})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch chiSwi(
      deaBan(displayUnit="K") = 1) "Control unit switching chiller on or off "
    annotation (Placement(transformation(extent={{-226,83},{-206,103}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = MediumCHW,
    dp_nominal=1000,
    m_flow_nominal=mCHW_flow_nominal) "Fixed resistance in chilled water loop"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={162,67})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond triAndRes(
    yMax=1,
    yMin=0,
    nActDec=0,
    nActInc=1,
    n=1,
    yEqu0=0,
    uTri=0.8,
    yDec=-0.01,
    tSam=240,
    yInc=0.02) "trim and respond logic"
    annotation (Placement(transformation(extent={{-146,193},{-126,213}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x2=1,
    x1=0.5,
    y11=1,
    y10=0.3,
    y21=273.15 + 5.56,
    y20=273.15 + 12) "Translate the control signal for chiller setpoint reset"
    annotation (Placement(transformation(extent={{-108,193},{-88,213}})));
  Modelica.Blocks.Sources.Constant TSupSet(k=273.15 + 18)
    "Set temperature for room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-216,222})));
  Buildings.Controls.Continuous.LimPID limPID(
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    Td=0,
    Ti=100,
    k=1) annotation (Placement(transformation(extent={{-186,192},{-166,212}})));
  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-186,144},{-166,164}})));
  Modelica.Blocks.Math.BooleanToReal chiCon "Contorl signal for chiller"
    annotation (Placement(transformation(extent={{-161,23},{-141,43}})));
  Modelica.Blocks.Logical.Switch swi
    annotation (Placement(transformation(extent={{-101,82},{-81,102}})));
  Modelica.Blocks.Sources.Constant off(k=0) "Control signal of chiller"
    annotation (Placement(transformation(extent={{-142,63},{-122,83}}, rotation=
           0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=100) "Fixed resistance in CHW loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={108,-19})));
  Fluid.Actuators.Valves.TwoWayLinear           val4(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=44790) "Control valve for condenser water loop of economizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={38,151})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSupAir(redeclare package Medium
      = MediumAir, m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature to data center" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={240,-225})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiCHWST(redeclare package Medium
      = MediumCHW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water entering chiller" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={162,-3})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiCWST(redeclare package Medium
      = MediumCW, m_flow_nominal=mCW_flow_nominal)
    "Condenser water supply temperature for economizer and chiller" annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={272,113})));
  Modelica.Blocks.Sources.Constant cooTowFanCon(k=1)
    "Control singal for cooling tower fan" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,271})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage           val2(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=44790)
    "Bypass valve for chiller. It controls the mass flow rate of chilled water going into the chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={214,13})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU KMinusU(k=1)
    annotation (Placement(transformation(extent={{-66,82},{-46,102}})));
  Fluid.Actuators.Valves.TwoWayLinear                    val3(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=44790)
    "Control valve for economizer. 0: disable economizer, 1: enable economoizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={63,-59})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res5(
    redeclare package Medium = MediumCHW,
    dp_nominal=1000,
    m_flow_nominal=mCHW_flow_nominal,
    m_flow(fixed=true, start=mCHW_flow_nominal)) "Fixed resistance in CHW loop"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={185,-167})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TWseCHWST(redeclare package Medium
      = MediumCHW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water goes into the WSE" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={162,-87})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res6(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=44990) "Fixed resistance in chilled water loop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={258,13})));
  Fluid.Sensors.MassFlowRate mChiCHW(redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={292,65})));
  BaseClasses.WeatherData weaData(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-332,-98},{-312,-78}})));
equation
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation (Line(
      points={{208,-147},{208,-169},{218,-169}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(expTowTApp.y, wseCon.towTApp) annotation (Line(
      points={{-207,-65},{-178,-65},{-178,-36.6},{-158.8,-36.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupSet.y, limPID.u_s) annotation (Line(
      points={{-205,222},{-196,222},{-196,202},{-188,202}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limPID.y, triAndRes.u[1]) annotation (Line(
      points={{-165,202},{-150,202},{-150,209.667},{-147.333,209.667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(linPieTwo.y[1], swi.u1) annotation (Line(
      points={{-87,202.3},{-76,202.3},{-76,122},{-112,122},{-112,100},{-103,100}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(off.y, swi.u3) annotation (Line(
      points={{-121,73},{-112,73},{-112,84},{-103,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(triAndRes.y, linPieTwo.u) annotation (Line(
      points={{-125.333,203},{-110,203}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chiSwi.y, chiCon.u) annotation (Line(
      points={{-205,92.4},{-196,92.4},{-196,33},{-163,33}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(cooTow.port_b, pumCW.port_a) annotation (Line(
      points={{218,233},{290,233},{290,226}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumCW.m_flow_in, mCWFlo.y) annotation (Line(
      points={{281.8,221},{266,221},{266,209},{255,209}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumCW.port_b, res3.port_a) annotation (Line(
      points={{290,206},{290,191}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res4.port_a, val5.port_b) annotation (Line(
      points={{128,193},{128,163}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val5.port_a, chi.port_b1) annotation (Line(
      points={{128,143},{128,99},{198,99}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(expVesChi.port_a, chi.port_b1) annotation (Line(
      points={{188,143},{188,99},{198,99}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val4.port_a, wse.port_b1) annotation (Line(
      points={{38,141},{38,99},{48,99}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val4.port_b, res4.port_a) annotation (Line(
      points={{38,161},{38,175},{128,175},{128,193}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, chi.port_a2) annotation (Line(
      points={{162,77},{162,87},{198,87}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chiSwi.y, chi.on) annotation (Line(
      points={{-205,92.4},{-170,92.4},{-170,129},{234,129},{234,96},{220,96}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(linPieTwo.y[2], chi.TSet) annotation (Line(
      points={{-87,203.3},{-64,203.3},{-64,125},{226,125},{226,90},{220,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chiCon.y, val6.y) annotation (Line(
      points={{-140,33},{-124,33},{-124,49},{270,49},{270,33},{284,33}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chiCon.y, val5.y) annotation (Line(
      points={{-140,33},{-124,33},{-124,49},{112,49},{112,153},{120,153}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(chiSwi.y, pre1.u) annotation (Line(
      points={{-205,92.4},{-196,92.4},{-196,155},{-192,155},{-188,154}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(chiSwi.y, swi.u2) annotation (Line(
      points={{-205,92.4},{-153.5,92.4},{-153.5,92},{-103,92}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(linPieTwo.y[2], chiSwi.TSet) annotation (Line(
      points={{-87,203.3},{-64,203.3},{-64,249},{-274,249},{-274,88},{-227,88}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(cooTowFanCon.y, cooTow.y) annotation (Line(
      points={{183,271},{192,271},{192,241},{196,241}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCoi.port_b2, fan.port_a) annotation (Line(
      points={{238,-181},{314,-181},{314,-225},{288,-225}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(
      points={{279,-201},{283,-201},{283,-216.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupAir.T, limPID.u_m) annotation (Line(
      points={{240,-214},{240,-201},{-266,-201},{-266,179},{-176,179},{-176,190}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(swi.y, KMinusU.u) annotation (Line(
      points={{-80,92},{-67.8,92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(KMinusU.y, val2.y) annotation (Line(
      points={{-45,92},{-38,92},{-38,39},{214,39},{214,21}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mPumCHW.y, pumCHW.m_flow_in) annotation (Line(
      points={{125,-131},{153.8,-131}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val6.port_b, cooCoi.port_a1) annotation (Line(
      points={{292,23},{292,-169},{238,-169}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wse.port_a2, val3.port_b) annotation (Line(
      points={{48,87},{38,87},{38,-59},{53,-59}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res5.port_a, cooCoi.port_b1) annotation (Line(
      points={{195,-167},{210,-167},{210,-169},{218,-169}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumCHW.port_a, res5.port_b) annotation (Line(
      points={{162,-136},{162,-167},{175,-167}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wseCon.y2, val1.y) annotation (Line(
      points={{-137.6,-35.24},{134,-35.24},{134,-40},{154,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCon.y1, val3.y) annotation (Line(
      points={{-137.6,-24.6},{2,-24.6},{2,-39},{63,-39},{63,-51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCon.y1, val4.y) annotation (Line(
      points={{-137.6,-24.6},{2,-24.6},{2,151},{30,151}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupAir.port_a, fan.port_b) annotation (Line(
      points={{250,-225},{268,-225}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo.airPorts[1], TSupAir.port_b) annotation (Line(
      points={{202.15,-228},{202.15,-225},{230,-225}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo.airPorts[2], cooCoi.port_a2) annotation (Line(
      points={{205.85,-228},{205.85,-225},{162,-225},{162,-181},{218,-181}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wse.port_b2, res1.port_a) annotation (Line(
      points={{68,87},{84,87},{84,-19},{98,-19}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWseCHWST.port_a, pumCHW.port_b) annotation (Line(
      points={{162,-97},{162,-116}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TChiCHWST.port_b, res2.port_a) annotation (Line(
      points={{162,7},{162,57}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TChiCHWST.port_b, val2.port_a) annotation (Line(
      points={{162,7},{162,13},{204,13}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, TChiCHWST.port_a) annotation (Line(
      points={{118,-19},{162,-19},{162,-13}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TChiCHWST.port_a, val1.port_b) annotation (Line(
      points={{162,-13},{162,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_a, TWseCHWST.port_b) annotation (Line(
      points={{162,-50},{162,-77}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val3.port_a, TWseCHWST.port_b) annotation (Line(
      points={{73,-59},{162,-59},{162,-77}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res4.port_b, cooTow.port_a) annotation (Line(
      points={{128,213},{128,233},{198,233}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res3.port_b, TChiCWST.port_a) annotation (Line(
      points={{290,171},{290,113},{282,113}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TChiCWST.port_b, chi.port_a1) annotation (Line(
      points={{262,113},{242,113},{242,99},{218,99}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TChiCWST.port_b, wse.port_a1) annotation (Line(
      points={{262,113},{84,113},{84,99},{68,99}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val2.port_b, res6.port_a) annotation (Line(
      points={{224,13},{248,13}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res6.port_b, val6.port_b) annotation (Line(
      points={{268,13},{292,13},{292,23}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pre1.y, triAndRes.sta) annotation (Line(
      points={{-165,154},{-158,154},{-158,196.333},{-147.333,196.333}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TChiCHWST.T, chiSwi.chiCHWST) annotation (Line(
      points={{151,-3},{-244,-3},{-244,100},{-227,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCon.wseCWST, TChiCWST.T) annotation (Line(
      points={{-158.8,-21.4},{-296,-21.4},{-296,289},{328,289},{328,133},{272,
          133},{272,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wseCon.wseCHWST, TWseCHWST.T) annotation (Line(
      points={{-158.8,-27},{-234,-27},{-234,-87},{151,-87}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mChiCHW.port_b, val6.port_a) annotation (Line(
      points={{292,55},{292,43}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mChiCHW.port_a, chi.port_b2) annotation (Line(
      points={{292,75},{292,87},{218,87}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-340,-90},{-331,-90},{-331,-88},{-322,-88}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(wseCon.TWetBul, weaBus.TWetBul) annotation (Line(
      points={{-158.8,-32.6},{-322,-32.6},{-322,-88}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cooTow.TAir, weaBus.TWetBul) annotation (Line(
      points={{196,237},{24,237},{24,268},{-322,268},{-322,-88}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-400,-300},{400,
            300}}), graphics),
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/PrimaryOnlyWithEconomizer.mos"
        "Simulate and plot"),
    Icon(graphics),
    Documentation(info="<HTML>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant with water-side economizer for cooling of a data center.
The system has the following properties:</p>
<p>
<ul>
<li>This is a primary-only integrated water side economizer system.</li>
<li>The data center room is simplified as a mixed air volume with heat source. The only means to transfer heat out of the room is through the HVAC system. Heat conduction and air infiltration through building leakage is neglected since the heat exchange between the room and the ambient environment is small compared to the heat released by the servers.</li>
<li>The control objective is to maintain the temperature of the supply air into data center room and to reduce energy consumption of the chiller, fans and pumps by maximizing the usage of the water-side economizer (WSE) for free cooling.</li>  
<li>The current system only specifies the control of the chiller (on/off and set point reset) and the WSE, which may be on or off.</li>
</ul>
</p>
<h4>Enabling/Disabling the WSE</h4>
<p>
The WSE is enabled when
<ol>
<li>The WSE has been disabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>WSE_CHWST</sub> &gt; 0.9 T<sub>WetBul</sub> + T<sub>TowApp</sub> + T<sub>WSEApp</sub> </li>
</ol>
<br/>
The WSE is disabled when
<ol>
<li>The WSE has been enabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>WSE_CHWRT</sub> &lt; 1 + T<sub>WSE_CWST</sub></li>
</li>
</ol>
<br/>
where <i>T<sub>WSE_CHWST</sub></i> is the chilled water supply temperature for the WSE, 
<i>T<sub>WetBul</sub></i> is the wet bulb temperature, <i>T<sub>TowApp</sub></i> is the cooling tower approach, <i>T<sub>WSEApp</sub></i> is the approach for the WSE, <i>T<sub>WSE_CHWRT</sub></i> is the chilled water return temperature for the WSE, and <i>T<sub>WSE_CWST</sub></i> is the condenser water return temperature for the WSE.
</p> 
<p>
<b>Note:</b> The formulas use temperature in Fahrenheit. The input and output data for the WSE control unit are in SI units. The WSE control component internally converts the data between SI units and IP units.</p>

<h4>Enabling/Disabling the Chiller</h4>
<p>
The control strategy is as follows:<ul>
<li>The chiller is enabled when 
<i>
  T<sub>Chi_CHWST</sub> &gt; T<sub>ChiSet</sub> + T<sub>DeaBan</sub> </i>
<li>The chiller is disabled when 
<i>
  T<sub>Chi_CHWST</sub> &le; T<sub>ChiSet</sub></i>
</li>
</ul>
where <i>T<sub>Chi_CHWST</sub></i> is the chiller chilled water supply temperature, <i>T<sub>ChiSet</sub></i> is the set point temperature for the chilled water leaving the chiller, and <i>T<sub>DeaBan</sub></i> is the dead-band to prevent short cycling. 
</p>
<h4>Chiller Set Point Reset</h4>
<p>
The chiller set point reset strategy is to first increase the mass flow rate of the chiller chilled water, <i>m</i>. If <i>m</i> reaches the maximum value and further cooling is still needed, the return temperature set point of the chilled water will be reduced. 
If there is too much cooling, the set point will be changed in the reverse direction.
This strategy is realized by using a trim and respond logic as follows:
<ul>
<li>A cooling request is triggered if the input signal, <i>u<sub>1</sub></i> is larger than <i>u<sub>tri</sub>(=0.8)</i>. <i>u<sub>1</sub></i> is the output from a PI controller which controls the temperature of the supply air for the data center room.</li>
<li>The request is sampled every 4 minutes. If there is a cooling request, the set point <i>u</i> is increased by <i>0.02</i>, 
where <i>0 &le; u &le; 1</i>. If there is no cooling request,  <i>u</i> is decreased by <i>0.01</i>. </li>
</ul>
<br/>
The chiller set point <i>u</i> is converted to control signals for the mass flow rate <i>m</i> and for the chiller set point temperature <i>T</i> as follows:
<ul>
<li>
If <i>u &isin; [0, x<sub>1</sub>]</i> then <i>m = m<sub>0</sub> + u &nbsp; (m<sub>1</sub>-m<sub>0</sub>)/(x<sub>1</sub>-0)</i>
and <i>T = T<sub>0</sub></i></li>
<li>
If <i>u &isin; (x<sub>1</sub>, 1]</i> then <i>m = m<sub>1</sub></i>
and
<i>T = T<sub>0</sub> + (u-x<sub>1</sub>) &nbsp; (T<sub>1</sub>-T<sub>0</sub>)/(1-x<sub>1</sub>)
</i></li>
</ul>
where <i>m<sub>0</sub></i> and <i>m<sub>1</sub></i> are minimum and maximum flow rates,
and <i>T<sub>0</sub></i> and <i>T<sub>1</sub></i> are the highest and lowest values for the set point of CHWRT for the chiller.

<h4>Nomenclature</h4>
<table>
<tr><td>CW:</td><td>condenser water</td></tr>
<tr><td>CWST:</td><td>condenser water supply temperature</td></tr>
<tr><td>CWRT:</td><td>condenser water return temperature</td></tr>
<tr><td>CHW:</td><td>chilled water</td></tr>
<tr><td>CHWST:</td><td>chilled water supply temperature</td></tr>
<tr><td>CHWRT:</td><td>chilled water return temperature</td></tr>
<tr><td>WSE:</td><td>water side economizer</td></tr>
</table>
</p>
<h4>Reference</h4>
Stein, J. (2009). Waterside Economizing in Data Centers: Design and Control Considerations. ASHRAE Transactions, 115(2), 192-200.
</HTML>
", revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br>
Add comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul></HTML>"));
end PrimaryOnlyWithEconomizer;