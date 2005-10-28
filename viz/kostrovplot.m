% Plot Kostrov results

clear all
addpath ../g

meta
dark = 1;
fig

dofilter = 1;
for ir = 10:10:30
  sensor = ihypo + [ ir 0 0 ];
  [ tt vt ta va ] = timeseries( 'sv', sensor, 1 );
  labels{2} = sprintf( 'r=%g', rg );
  tsplot
end

%print -dpsc2 kost.ps

