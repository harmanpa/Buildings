package MoistAir 
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="Moist air perfect gas",
     substanceNames={"water", "air"},
     final reducedX=true,
     final singleState=false,
     reference_X={0.01,0.99},
     fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                       Modelica.Media.IdealGases.Common.FluidData.N2});
  
  annotation (Documentation(info="<HTML>
<p>
This is a medium model that is similar to 
<a href=\"Modelica:Modelica.Media.Air.MoistAir\">
Modelica.Media.Air.MoistAir</a> but 
it has a constant specific heat capacity.
</p><p>
In particular, the medium is calorically perfect, i.e., 
<ul>
<li>
it is in thermodynamic equilibrium,
</li><li>
it is chemically not reacting, and
</li><li>
internal energy and enthalpy are functions of the temperature only.
</li>
</ul>
In addition, the gas is calorically perfect, i.e., the
specific heat capacities at constant pressure
and constant volume are both constant (Bower 1998).
</p>
<h3>References</h3>
Bower, William B. <i>A primer in fluid mechanics: Dynamics of flows in one
space dimension</i>. CRC Press. 1998.
</HTML>", revisions="<html>
<ul>
<li>
May 8, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  constant Integer Water=1 
    "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2 
    "Index of air (in substanceNames, massFractions X, etc.)";
  constant Real k_mair =  steam.MM/dryair.MM "ratio of molar weights";
  constant Buildings.Media.PerfectGases.Common.DataRecord dryair=
        Buildings.Media.PerfectGases.Common.SingleGasData.Air;
  constant Buildings.Media.PerfectGases.Common.DataRecord steam=
        Buildings.Media.PerfectGases.Common.SingleGasData.H2O;
  import SI = Modelica.SIunits;
  
  redeclare replaceable model extends BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    Xi(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)) 
    
    /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence. 
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */
    MassFraction x_water "mass of total water/mass of dry air";
    Real phi "relative humidity";
    annotation(structurallyIncomplete);
    
  protected 
    constant SI.MolarMass[2] MMX = {steam.MM,dryair.MM} 
      "molar masses of components";
    
    MassFraction X_liquid "mass fraction of liquid water";
    MassFraction X_steam "mass fraction of steam water";
    MassFraction X_air "mass fraction of air";
    MassFraction X_sat 
      "steam water mass fraction of saturation boundary in kg_water/kg_moistair";
    MassFraction x_sat 
      "steam water mass content of saturation boundary in kg_water/kg_dryair";
    AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
  equation 
    assert(T >= 200.0 and T <= 423.15, "
Temperature T is not in the allowed range
200.0 K <= (T ="
               + String(T) + " K) <= 423.15 K
required from medium model \""     + mediumName + "\".");
    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);
    
    p_steam_sat = min(saturationPressure(T),0.999*p);
    X_sat = min(p_steam_sat * k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat)*(1 - Xi[Water]), 1.0) 
      "Water content at saturation with respect to actual water content";
    X_liquid = max(Xi[Water] - X_sat, 0.0);
    X_steam  = Xi[Water]-X_liquid;
    X_air    = 1-Xi[Water];
    
    h = specificEnthalpy_pTX(p,T,Xi);
    R = dryair.R*(1 - X_steam/(1 - X_liquid)) + steam.R*X_steam/(1 - X_liquid);
    //                
    u = h - R*T;
    d = p/(R*T);
    /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
    state.p = p;
    state.T = T;
    state.X = X;
    
    // this x_steam is water load / dry air!!!!!!!!!!!
    x_sat    = k_mair*p_steam_sat/max(100*Modelica.Constants.eps,p - p_steam_sat);
    x_water = Xi[Water]/max(X_air,100*Modelica.Constants.eps);
    phi = p/p_steam_sat*Xi[Water]/(Xi[Water] + k_mair*X_air);
  end BaseProperties;
  
  function Xsaturation = Modelica.Media.Air.MoistAir.Xsaturation;
  
  redeclare function setState_pTX 
      extends Modelica.Media.Air.MoistAir.setState_pTX;
  end setState_pTX;
  
  redeclare function setState_phX 
     extends Modelica.Media.Air.MoistAir.setState_phX;
  end setState_phX;
  
  redeclare function setState_dTX 
     extends Modelica.Media.Air.MoistAir.setState_dTX;
  end setState_dTX;
  
  redeclare function gasConstant 
     extends Modelica.Media.Air.MoistAir.gasConstant;
  end gasConstant;
  
  function saturationPressureLiquid = 
      Modelica.Media.Air.MoistAir.saturationPressureLiquid;
  
  function sublimationPressureIce = 
      Modelica.Media.Air.MoistAir.sublimationPressureIce;
  
redeclare function extends saturationPressure 
    "saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)" 
    
  annotation(Inline=false,smoothOrder=5);
algorithm 
  psat := Utilities.spliceFunction(saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
end saturationPressure;
  
 redeclare function pressure 
    extends Modelica.Media.Air.MoistAir.pressure;
 end pressure;
  
 redeclare function temperature 
    extends Modelica.Media.Air.MoistAir.temperature;
 end temperature;
  
 redeclare function density 
    extends Modelica.Media.Air.MoistAir.density;
 end density;
  
 redeclare function specificEntropy 
    extends Modelica.Media.Air.MoistAir.specificEntropy;
 end specificEntropy;
  
 redeclare function extends enthalpyOfVaporization 
    "enthalpy of vaporization of water" 
 algorithm 
  r0 := 2501014.5;
 end enthalpyOfVaporization;
  
  function HeatCapacityOfWater "specific heat capacity of water (liquid only)" 
    extends Modelica.Icons.Function;
    input Temperature T;
    output SpecificHeatCapacity cp_fl;
    annotation (Documentation(info="constant specific heat capacity of water"));
  algorithm 
    cp_fl := 4186;
  end HeatCapacityOfWater;
  
redeclare replaceable function extends enthalpyOfLiquid 
    
  annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid);
algorithm 
  h := (T - 273.15)*4186;
end enthalpyOfLiquid;
  
replaceable function der_enthalpyOfLiquid 
    "temperature derivative of enthalpy of liquid per unit mass of steam" 
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Temperature der_T "temperature derivative";
  output SpecificHeatCapacity der_h "derivative of liquid enthalpy";
algorithm 
  der_h := 4186;
end der_enthalpyOfLiquid;
  
redeclare function enthalpyOfCondensingGas 
    "enthalpy of steam per unit mass of steam" 
  extends Modelica.Icons.Function;
    
  annotation(smoothOrder=5, derivative=der_enthalpyOfCondensingGas);
  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm 
  h := (T-273.15) * steam.cp + enthalpyOfVaporization(T);
end enthalpyOfCondensingGas;
  
replaceable function der_enthalpyOfCondensingGas 
    "derivative of enthalpy of steam per unit mass of steam" 
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Temperature der_T "temperature derivative";
  output SpecificHeatCapacity der_h "derivative of steam enthalpy";
algorithm 
  der_h := steam.cp;
end der_enthalpyOfCondensingGas;
  
redeclare replaceable function extends enthalpyOfGas 
algorithm 
  h := enthalpyOfCondensingGas(T)*X[Water]
       + enthalpyOfDryAir(T)*(1.0-X[Water]);
end enthalpyOfGas;
  
replaceable function enthalpyOfDryAir 
  extends Modelica.Icons.Function;
  annotation(smoothOrder=5, derivative=der_enthalpyOfDryAir);
  input Temperature T "temperature";
  output SpecificEnthalpy h "dry air enthalpy";
algorithm 
  h := (T - 273.15)*dryair.cp;
end enthalpyOfDryAir;
  
replaceable function der_enthalpyOfDryAir 
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Temperature der_T "temperature derivative";
  output SpecificHeatCapacity der_h "derivative of dry air enthalpy";
algorithm 
  der_h := dryair.cp;
end der_enthalpyOfDryAir;
  
redeclare replaceable function extends specificHeatCapacityCp 
    "Return specific heat capacity at constant pressure" 
algorithm 
  cp := dryair.cp*(1-state.X[Water]) +steam.cp*state.X[Water];
end specificHeatCapacityCp;
  
redeclare replaceable function extends specificHeatCapacityCv 
    "Return specific heat capacity at constant volume" 
algorithm 
  cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
end specificHeatCapacityCv;
  
redeclare function extends dynamicViscosity 
algorithm 
  eta := 1.85E-5;
end dynamicViscosity;
  
redeclare function extends thermalConductivity 
algorithm 
  lambda := Polynomials_Temp.evaluate({(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
   Cv.to_degC(state.T));
end thermalConductivity;
  
function h_pTX 
    "Compute specific enthalpy from pressure, temperature and mass fraction" 
  extends Modelica.Icons.Function;
  input SI.Pressure p "Pressure";
  input SI.Temperature T "Temperature";
  input SI.MassFraction X[nX] "Mass fractions of moist air";
  output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
    
  annotation(Inline=false,smoothOrder=1);
  protected 
  SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
  SI.MassFraction x_sat "steam water mass fraction of saturation boundary";
  SI.MassFraction X_liquid "mass fraction of liquid water";
  SI.MassFraction X_steam "mass fraction of steam water";
  SI.MassFraction X_air "mass fraction of air";
  SI.SpecificEnthalpy hDryAir "Enthalpy of dry air";
algorithm 
  p_steam_sat :=saturationPressure(T);
  x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
  X_liquid :=max(X[Water] - x_sat/(1 + x_sat), 0.0);
  X_steam  :=X[Water] - X_liquid;
  X_air    :=1 - X[Water];
    
/* THIS DOES NOT WORK --------------------------    
  h := enthalpyOfDryAir(T) * X_air + 
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
--------------------------------- */
    
/* THIS WORKS!!!! +++++++++++++++++++++
  h := (T - 273.15)*dryair.cp * X_air + 
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
 +++++++++++++++++++++*/
    
  hDryAir := (T - 273.15)*dryair.cp;
  h := hDryAir * X_air +
       ((T-273.15) * steam.cp + 2501014.5) * X_steam +
       (T - 273.15)*4186*X_liquid;
end h_pTX;
  
redeclare function extends specificEnthalpy "specific enthalpy" 
algorithm 
  h := h_pTX(state.p, state.T, state.X);
end specificEnthalpy;
  
redeclare function extends specificInternalEnergy 
    "Return specific internal energy" 
  extends Modelica.Icons.Function;
algorithm 
  u := h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T;
end specificInternalEnergy;
  
redeclare function extends specificGibbsEnergy 
  extends Modelica.Icons.Function;
algorithm 
  g := h_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
end specificGibbsEnergy;
  
redeclare function extends specificHelmholtzEnergy 
  extends Modelica.Icons.Function;
algorithm 
  f := h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T - state.T*specificEntropy(state);
end specificHelmholtzEnergy;
  
function T_phX "Compute temperature from specific enthalpy and mass fraction" 
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "specific enthalpy";
  input MassFraction[:] X "mass fractions of composition";
  output Temperature T "temperature";
  protected 
package Internal 
      "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)" 
  extends Modelica.Media.Common.OneNonLinearEquation;
  redeclare record extends f_nonlinear_Data 
        "Data to be passed to non-linear function" 
    extends Buildings.Media.PerfectGases.Common.DataRecord;
  end f_nonlinear_Data;
      
  redeclare function extends f_nonlinear 
  algorithm 
      y := h_pTX(p,x,X);
  end f_nonlinear;
      
  // Dummy definition has to be added for current Dymola
  redeclare function extends solve 
  end solve;
end Internal;
    
algorithm 
 /* The function call below has been changed from 
      Internal.solve(h, 200, 6000, p, X[1:nXi], steam);
    to  
      Internal.solve(h, 200, 6000, p, X, steam);
    The reason is that when running the problem
       Buildings.Media.PerfectGases.Examples.MoistAirComparison
    then an assertion is triggered because the vector X had the wrong
    dimension. The above example verifies that T(h(T)) = 0.
 */
  T := Internal.solve(h, 200, 6000, p, X, steam);
end T_phX;
  
  package Utilities "utility functions" 
    function spliceFunction 
        input Real pos;
        input Real neg;
        input Real x;
        input Real deltax=1;
        output Real out;
        annotation (derivative=spliceFunction_der);
    protected 
        Real scaledX;
        Real scaledX1;
        Real y;
    algorithm 
        scaledX1 := x/deltax;
        scaledX := scaledX1*Modelica.Math.asin(1);
        if scaledX1 <= -0.999999999 then
          y := 0;
        elseif scaledX1 >= 0.999999999 then
          y := 1;
        else
          y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
        end if;
        out := pos*y + (1 - y)*neg;
    end spliceFunction;
    
    function spliceFunction_der 
        input Real pos;
        input Real neg;
        input Real x;
        input Real deltax=1;
        input Real dpos;
        input Real dneg;
        input Real dx;
        input Real ddeltax=0;
        output Real out;
    protected 
        Real scaledX;
        Real scaledX1;
        Real dscaledX1;
        Real y;
    algorithm 
        scaledX1 := x/deltax;
        scaledX := scaledX1*Modelica.Math.asin(1);
        dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
        if scaledX1 <= -0.99999999999 then
          y := 0;
        elseif scaledX1 >= 0.9999999999 then
          y := 1;
        else
          y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
        end if;
        out := dpos*y + (1 - y)*dneg;
        if (abs(scaledX1) < 1) then
          out := out + (pos - neg)*dscaledX1*Modelica.Math.asin(1)/2/(
            Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
            scaledX))^2;
        end if;
    end spliceFunction_der;
    
  end Utilities;
end MoistAir;