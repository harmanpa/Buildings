within Buildings.Utilities.IO.Python27.Functions;
function exchange "Function that communicates with Python"
  input String moduleName
    "Name of the python module that contains the function";
  input String functionName=moduleName "Name of the python function";

  input Real    dblValWri[max(1, nDblWri)] "Double values to write";
  input Integer intValWri[max(1, nIntWri)] "Integer values to write";
  input String  strValWri[max(1, nStrWri)] "String values to write";

  input Integer nDblWri(min=0) "Number of double values to write";
  input Integer nDblRea(min=0) "Number of double values to read";

  input Integer nIntWri(min=0) "Number of integer values to write";
  input Integer nIntRea(min=0) "Number of integer values to read";

  input Integer nStrWri(min=0) "Number of strings to write";
//  input Integer nStrRea(min=0) "Number of strings to read";
//  input Integer strLenRea(min=0)
//    "Maximum length of each string that is read. If exceeded, the simulation stops with an error";

  output Real    dblValRea[max(1, nDblRea)] "Double values returned by Python";
  output Integer intValRea[max(1, nIntRea)] "Integer values returned by Python";

  external "C" pythonExchangeValues(moduleName, functionName,
                                    dblValWri, nDblWri,
                                    dblValRea, nDblRea,
                                    intValWri, nIntWri,
                                    intValRea, nIntRea,
                                    strValWri, nStrWri)
    annotation (Library={"ModelicaBuildingsPython2.7", "python2.7"});
  annotation (Documentation(info="<html>
<p>
This function exchanges data with Python.
See 
<a href=\"modelica://Buildings.Utilities.IO.Python27.UsersGuide\">
Buildings.Utilities.IO.Python27.UsersGuide</a>
for instructions, and 
<a href=\"modelica://Buildings.Utilities.IO.Python27.Functions.Examples\">
Buildings.Utilities.IO.Python27.Functions.Examples</a>
for examples.
</p>
</html>", revisions="<html>
<ul>
<li>
January 31, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end exchange;
