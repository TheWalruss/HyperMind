Toolkit = {}

Toolkit.PartTypes = {
                     "Operation",
                     "OperationStrength",
                     "Effector",
		     "EffectorSize",
                     "Vehicle",
                     "VehicleMaxPower",
                     "VehicleAttribute",
                     "VehicleTime",
                     "VehicleMass",
                     "VehicleSize",
                     "Special",
                     "SpecialPower",
                     "Firemode",
                     "Reloadperiod",
                     "DeviceType",
                     "DeviceSpeed",
                     "Powermod"  } 
                       
-- >>1,24416e+12 unique tools (minus a few orders - can't have emitter-type teleporters, etc.)
Toolkit.Operation = { "Probe",       -- marks pixel type (ok)
                      "Annihilator", -- removes pixels entirely (ok)
                  --    "Harvester",   -- harvests pixels for credits (todo)
                      "Converter",   -- changes pixel color (todo)
                      "Dilator"--,     -- expands pixels radially or in crystals (depending on pixel type) (ok - todo: should place set pixel type?)
                --      "Extruder",    -- expands pixels over time with angular or sinusoidal branches (depending on pixel type), previously "vegetation" (todo)
               --       "Hacker",      -- hacks stuff (todo)
               --       "Thief",       -- steals stuff (todo)
               --       "Rope"         -- trails a rope with a hook (todo)
               --       "Illuminator"  -- flashlight (todo)
	       --       "Cleaner",    -- gets rid of existing tools (todo)
	       --       "Teleporter",    -- sets up teleportation network (todo)
                      }
		      
Toolkit.OperationStrength = { 1,2,3,4,5,6,7,8,9,10 }
                       
Toolkit.Effector = { "Precision",     -- a single pixel (todo: should work on all materials?)
                    -- "Blast",         -- a star-shaped pattern (todo)
                     "Sphere"        -- a circular pattern (todo > radius 10)
                     }

Toolkit.EffectorSize = { 3,5,8,10 }

Toolkit.Vehicle = { "Torch",       -- a close-range projection-like vehicle (todo)
                    "Thrown",      -- a lobbed projectile (ok)
                    "Gun",         -- a projectile with fixed power (ok)
                    "Projection"   -- a ray (laser) (ok)
                    }
		    
Toolkit.VehicleMaxPower = { 1,2,4,8,16 }

Toolkit.VehicleAttribute = { "Contact-trigger", -- no attribute (ok)
                             "Timed",     -- timed vehicles don't detonate at contact, but after some time (todo timer)
                             "Sticky",    -- a timed vehicle that doesn't roll, slide, or bounce 
                             "Spider"      -- a timed vehicle which crawls along surfaces
                              }
                              
Toolkit.VehicleTime = { 1,2,3,4,5,6,7,8,9,10 }

Toolkit.VehicleMass = { 1,4,10 }

Toolkit.VehicleSize = { 1,3,5,8,10 }

Toolkit.Special = { "Standard",       -- No special
                    "Manual-trigger", -- Vehicles can also be detonated manually - does not remove contact or time trigger
                    "Neumann",        -- Operation replicates to adjacent pixels
                    "Cascade",        -- Vehicle produces a number of child vehicles at trigger time (inherit all attributes except special, smaller effect size) 
                    "Emitter"         -- Vehicle emits vehiclets throughout its lifetime (inherit all attributes except special, smaller effect size) 
                    }

Toolkit.SpecialPower = { 2,4,6,8,10 }		    -- (What is this supposed to do?)

Toolkit.Firemode = { "Semi-automatic", -- One vehicle per trigger (ok)
                     "Burst",          -- A spread of vehicles per trigger (ok)
                     "Automatic"       -- Holding the trigger produces a stream of vehicles (ok)
                     }

Toolkit.Reloadperiod = { "Single-Use", -- Tool can only be used once.  (ok - todo: either remove from inventory or provide reload mechanic)
                         "Standard",   -- Tool has a long refractory period
                         "Repeating"   -- Tool has a short refractory period
                         }
                    
Toolkit.DeviceType = { "Handheld",        -- standard hand-held tool
                    --   "Crane",           -- stationary device which works autonomously   (todo)
                     --  "Drone",           -- mobile device which works autonomously   (todo)
                   --    "Tractor"          -- large mobile unit operated by player  (todo)
                      }
                      
Toolkit.DeviceSpeed = { 1,2,3,4,5,6,7,8,9,10 }         
                      
                      
Toolkit.Powermod = { "OperationStrength",   -- increases the set of affected pixel types  (todo)
                     "EffectorSize",        -- increases the range of the effect
                     "VehicleTime",         -- increases the time of a timed, sticky, or smart vehicle 
                     "VehicleMaxPower",     -- increases the max throwing power of a grenade, the fixed power of a gun, and no effect on a ray. (ok/todo)
                     "SpecialPower",        -- increases the effectiveness of the special (higher % chance of neumann effect, more cascade vehicles, longer max time on the trigger)  (todo)
                     "DeviceSpeed",         -- increases the tracking and motive speed of a crane, drone, or tractor. (todo)
                     "VehicleMass",         -- increases the mass of effectors, to more easily plunge through the atmosphere (todo)
                     "VehicleSize"          -- increases the size of effectors, to more easily catch the wind currents (todo)
                     }

local HardwareCompanies = {
  "Swedish Space Corporation",
  "Asgardia",
  "SpaceX",
  "Planetary Resources",
  "Deep Space Industries",
  "Foxconn",
  "Tata",
  "Samsung",
  "Koch"
}
