
% SWMM Type
swmm.Subcatchments = 0;
swmm.Nodes         = 1;
swmm.Links         = 2;
swmm.System        = 3;

% SWMM Units
swmm.CFS           = 0;
swmm.GPM           = 1;
swmm.MGD           = 2;
swmm.CMS           = 3;
swmm.LPS           = 4;
swmm.LPD           = 5;

%% SWMM Value Index
%  subcatchment variables
swmm.subcatch.rainfall     = 0;  %rainfall (in/hr or mm/hr)
swmm.subcatch.snowdepth    = 1;  %snow depth (in or mm)
swmm.subcatch.loss         = 2;  %evaporation loss (in/day or mm/day)
swmm.subcatch.infiltration = 3;  %infiltration losses (in/hr or mm/hr)
swmm.subcatch.runoff       = 4;  %runoff rate (flow units)
swmm.subcatch.gwoutflow    = 5;  %groundwater outflow rate (flow units)
swmm.subcatch.gwelevation  = 6;  %groundwater water table elevation (ft or m)
swmm.subcatch.unsaturated  = 7;  %unsaturated zone moisture content (fraction)
swmm.subcatch.con1stpoll   = 8;  %runoff concentration of first pollutant

%  node variables
swmm.node.depth           = 0;  %depth of water above invert (ft or m)
swmm.node.head            = 1;  %hydraulic head (ft or m)
swmm.node.volume          = 2;  %volume of stored + ponded water (ft3 or m3)
swmm.node.lateralinflow   = 3;  %lateral inflow (flow units)
swmm.node.totalinflow     = 4;  %total inflow (lateral + upstream) (flow units)
swmm.node.flooding        = 5;  %flow lost to flooding (flow units)
swmm.node.con1stpoll      = 6;  %concentration of first pollutant

%  link variables
swmm.link.flow            = 0;  %flow rate (flow units)
swmm.link.depth           = 1;  %flow depth (ft or m)
swmm.link.velocity        = 2;  %flow velocity (ft/s or m/s)
swmm.link.volume          = 3;  %flow volume (ft3 or m3)
swmm.link.filledfrac      = 4;  %fraction of conduit's area filled or settingnon-conduits
swmm.link.con1stpoll      = 5;  %concentration of first pollutant

%  system-wide variables 
swmm.sys.temp             = 0;  %air temperature (deg. F or deg. C)
swmm.sys.rainfall         = 0;  %rainfall (in/hr or mm/hr)
swmm.sys.snowdepth        = 0;  %snow depth (in or mm)
swmm.sys.lossrate         = 0;  %evaporation + infiltration loss rate (in/hr or mm/hr)
swmm.sys.runoff           = 0;  %runoff flow (flow units)
swmm.sys.dryweatherinflow = 0;  %dry weather inflow (flow units)
swmm.sys.gwinflow         = 0;  %groundwater inflow (flow units)
swmm.sys.RDIIinflow       = 0;  %RDII inflow (flow units)
swmm.sys.directinflow     = 0;  %user supplied direct inflow (flow units)
swmm.sys.totallatinflow   = 0;  %total lateral inflow (sum of variables 4 to 8) (flow units)
swmm.sys.flooding         = 0;  %flow lost to flooding (flow units)
swmm.sys.outfalls         = 0;  %flow leaving through outfalls (flow units)
swmm.sys.storedvolume     = 0;  %volume of stored water (ft3 or m3)
swmm.sys.actevap          = 0;  %actual evaporation rate (in/day or mm/day)
swmm.sys.potevap          = 0;  %potential evaporation rate (PET) (in/day or mm/day)

%% 
% Node type codes
swmm.node.Junction = 0;
swmm.node.Outfall  = 1;
swmm.node.Storage  = 2;
swmm.node.Divider  = 3;


% Link type codes
swmm.link.Conduit = 0;
swmm.link.Pump    = 1;
swmm.link.Orifice = 2;
swmm.link.Weir    = 3;
swmm.link.Outlet  = 4;







