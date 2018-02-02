require 'Properties'

Toolkit = {}

Toolkit.PartTypes = {"Value",           -- -1, 0, 1 -- the emotional direction
	             "Intensity",	-- 1 to Properties.MaterialLevels
		     "Axis",            -- R, G, B
                     "Effector",        -- The shape of the effect
		     "EffectorSize",    -- The size or area
                     "Vehicle",         -- How the effector travels
                     "VehiclePower",    -- Affects torch range (todo), throwing distance, gun velocity, and projection penetration (todo)
                     "VehicleTrigger",  -- How the vehicle's effect is triggered
                     "ManualTrigger",   -- Whether the effect can also be triggered manually
                     "VehicleTime",     -- Lifetime of the vehicle and projection distance (todo)
                     "VehicleMass",     -- (todo- projection?)
                     "VehicleSize",     -- Radius of vehicle (todo- projection?)
                     "VehicleSub",
                     "VehicleSubAmount",
                     "Firemode",
                     "AutoReload",
                     "Bot",
                     "Utility"  } 

Toolkit.Value = { 
	required = true,-1, 0, 1 }

local function getIntensity()
  local i = {"required = true"}
  for intensity = 0, Properties.MaterialLevels do
    i[intensity] = intensity
  end
  return i
end
Toolkit.Intensity = getIntensity()

Toolkit.Axis = {
                required = true,
                "R","G","B"}

                       
Toolkit.Effector = {
                     required = true,
	             "Neumann",     -- all contiguous pixels (todo) (todo: should work on all materials?)
                     "Blast",       -- a star-shaped pattern (todo)
                     "Sphere"       -- a circular pattern (todo > radius 10)
                     }

Toolkit.EffectorSize = { 
	      required=false, 
	      3,
              --5, -- default
	      8,10 }

Toolkit.Vehicle = {
                    required = true, -- Must have a vehicle
                    "Torch",       -- a close-range projection-like vehicle (todo)
                    "Thrown",      -- a lobbed projectile (ok)
                    "Gun",         -- a projectile with fixed power (ok)
                    "Projection"   -- a ray (laser) (ok)
                    }
		    
Toolkit.VehiclePower = { 
	                   required=false, 
                      --4, --default
                  8,16 }

Toolkit.VehicleTrigger = { 
	                   required=false, 
                           --"Contact-trigger", -- no attribute (default)
                           "Timed",     -- timed vehicles don't detonate at contact, but after some time (todo timer)
                           "Sticky",    -- a timed vehicle that doesn't roll, slide, or bounce 
                           "Spider"      -- a timed vehicle which crawls along surfaces
                           }

Toolkit.ManualTrigger = {
	             required=false, --default no manual trigger
                     true }

Toolkit.VehicleTime = {
	             required=false,
                     1,2,3,
		     --5, --default
		     8,13,21 }

Toolkit.VehicleMass = {
	             required=false,
                     1,
		     -- 4, --default
		     10 }

Toolkit.VehicleSize = { 
	             required=false,
                     1,3,
		    -- 5, --default
		     8,10 }

Toolkit.VehicleSub = {
	             required=false, -- VehicleSubAmount without VehicleSub is stupid
                    "Cascade",        -- Vehicle produces a number of child vehicles at trigger time (inherit all attributes except special, smaller effect size) 
                    "Emitter"         -- Vehicle emits vehiclets throughout its lifetime (inherit all attributes except special, smaller effect size) 
                    }

Toolkit.VehicleSubAmount = { 
	             required=false, -- VehicleSub without VehicleSubAmount is stupid
	2,4,6,8,10 } -- (todo)

Toolkit.Firemode = { 
	             required=false,
        --             "Semi-automatic", -- One vehicle per trigger (ok) default
                     "Burst",          -- A spread of vehicles per trigger (ok)
                     "Automatic",      -- Holding the trigger produces a stream of vehicles (ok)
                     "Autoburst"       -- Holding the trigger produces a torrent of vehicles (todo)
                     }

Toolkit.AutoReload = {
	                 required=false, -- default means you need to hit the reload button every shot
                         "Standard",   -- Tool has a long refractory period
                         "Fast"   -- Tool has a short refractory period
                         }
                    
Toolkit.Bot = { 
	               required=false,  -- default is handheld
                       "Crane",           -- stationary device which works autonomously   (todo)
                       "Drone",           -- mobile device which works autonomously   (todo)
                      }
                      
Toolkit.DeviceSpeed = {
	             required=false,
                     1,2,3,4,
		     --5, --default
		     6,7,8,9,10 }        
                     

Toolkit.Utility = {  
	             required=false,
                     "Probe",       -- marks pixel type (ok)
                     "Illuminator",  -- flashlight (todo)
	             "Cleaner",    -- gets rid of existing tools (todo)
                     "Rope",         -- trails a rope with a hook (todo)
	             "Teleporter"    -- sets up teleportation network (todo)
--                      "Annihilator", -- removes pixels entirely (ok)
--                      "Converter",   -- changes pixel color (todo)
--                      "Dilator",     -- expands pixels radially or in crystals (depending on pixel type) (ok - todo: should place set pixel type?)
                 --todo    "Harvester",   -- harvests pixels for credits (todo)
                 --todo     "Extruder",    -- expands pixels over time with angular or sinusoidal branches (depending on pixel type), previously "vegetation" (todo)
                 --todo     "Hacker",      -- hacks stuff (todo)
                 --todo     "Thief",       -- steals stuff (todo)
                      }
		      
