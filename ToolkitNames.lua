require 'Properties'

PartNames = {}
PartCount = {}

PartNames.Value = { 
	-1="Negative", 0="Neutral", 1="Positive" }
PartCount.Value = { 
	-1=100, 0=100, 1=100 }

PartNames.Intensity = {0="Vacuous",1="Weak",2="Moderate",3="Strong",4="Powerful",5="Dominating"}
PartCount.Intensity = {0=100,      1=75,    2=50,        3=25,      4=10,        5=5}

PartNames.Axis = {
                "R"="Passion","G"="Fear","B"="Happiness"}
PartCount.Axis = {
                "R"=100,"G"=100,"B"=100}

                       
PartNames.Effector = {
	             "Neumann"="Neumann", "Blast"="Blast", "Sphere"="Sphere"
                     }
PartCount.Effector = {
	             "Neumann"=5,         "Blast"=25,      "Sphere"=100
                     }

PartNames.EffectorSize = { 
	      3="Minor",
              --5, -- default
	      8="Major",10="Extreme" }
PartCount.EffectorSize = { 
	      3=50,
              --5, -- default
	      8=50,    10=25 }

PartNames.Vehicle = {
                    "Torch"="Close",
                    "Thrown"="Thrown",
                    "Gun"="Fired",
                    "Projection"="Beamed"
                    }
PartCount.Vehicle = {
                    "Torch"=100,
                    "Thrown"=50,
                    "Gun"=25,
                    "Projection"=10
                    }
		    
PartNames.VehiclePower = { 
                      --4, --default
                  8="Significant",16="Far-reaching" }
PartCount.VehiclePower = { 
                      --4, --default
                  8=50,           16=25 }

PartNames.VehicleTrigger = { 
                           --"Contact-trigger", -- no attribute (default)
                           "Timed"="Delayed",
                           "Sticky"="Unrelenting", 
                           "Spider"="Searching"
                           }
PartCount.VehicleTrigger = { 
                           --"Contact-trigger", -- no attribute (default)
                           "Timed"=50,
                           "Sticky"=25, 
                           "Spider"=10

PartNames.ManualTrigger = {
                     true="Deliberate" }
PartCount.ManualTrigger = {
                     true=25}


PartNames.VehicleTime = {
                     1="Momentary",2="Fleeting",3="Brief",
		     --5, --default
		     8="Long",13="Lasting",21="Enduring" }
PartCount.VehicleTime = {
                     1=25,         2=25,        3=25,
		     --5, --default
		     8=25,    13=25,       21=25 }

PartNames.VehicleMass = {
                     1="Volatile",
		     -- 4, --default
		     10="Heavy" }
PartCount.VehicleMass = {
                     1=25,
		     -- 4, --default
		     10=25 }

PartNames.VehicleSize = { 
                     1="Precise",3="Particular",
		    -- 5, --default
		     8="Lenient",10="General" }
PartCount.VehicleSize = { 
                     1=25,       3=25,
		    -- 5, --default
		     8=25,       10=25 }

PartNames.VehicleSub = {
                    "Cascade"="Avalanche", 
                    "Emitter"="Deluge" 
                    }
PartCount.VehicleSub = {
                    "Cascade"=5, 
                    "Emitter"=5 
                    }

PartNames.VehicleSubAmount = { 
	2="Odd",4="Strange",6="Astonishing",8="Bizarre",10="Extraordinary" })
PartCount.VehicleSubAmount = { 
	2=5,   4=4,        6=3,            8=2,        10=1 })

PartNames.Firemode = { 
        --             "Semi-automatic", -- One vehicle per trigger (ok) default
                     "Burst"="Outburst",
                     "Automatic"="Torrent",
                     "Autoburst"="Cataract"
                     }
PartCount.Firemode = { 
        --             "Semi-automatic", -- One vehicle per trigger (ok) default
                     "Burst"=25,
                     "Automatic"=10,
                     "Autoburst"=5

PartNames.AutoReload = {
                         "Standard"="Repeating",   
                         "Fast"="Rapid-fire"
                         }
PartCount.AutoReload = {
                         "Standard"=25,   
                         "Fast"=10
                         }
                    
PartNames.Bot = { 
                       "Crane"="Parrot",
		       "Drone"="Disciple"
                      }
PartCount.Bot = { 
                       "Crane"=2,
		       "Drone"=1
                      }
                      
PartNames.Utility = {  
                     "Probe"="Observation",
                     "Illuminator"="Illumination",
	             "Cleaner"="Silence",
                     "Rope"="Navigation",
	             "Teleporter"="Transportation"
                      }
		      
PartCount.Utility = {  
                     "Probe"=25,
                     "Illuminator"=10,
	             "Cleaner"=5,
                     "Rope"=5,
	             "Teleporter"=5
                      }
		      
