
local WASD = {
  pause = "return",
  jump = "w",
  left = "a",
  right = "d",
  drop = "s",
  aimup = "up",
  aimdown = "down",
  grapple = "space",
  sail = "x",
  power = "lshift",
  powerlock = "capslock",
  nexttool = "pageup",
  prevtool = "pagedown",
  usetool = "kp0",
  triggertool = "kp,",
  discardtool = "delete",
  
  inventoryview = "1",
  newtool = "kp0",
  canceltool ="delete",
  setpart = "space"
}
local WASD2 = {
  pause = "return",
  jump = "space",
  left = "a",
  right = "d",
  drop = "s",
  aimup = "up",
  aimdown = "down",
  grapple = "w",
  sail = "x",
  power = "lshift",
  powerlock = "capslock",
  nexttool = "e",
  prevtool = "q",
  usetool = "rshift",
  triggertool = "rctrl",
  discardtool = "delete",
  
  inventoryview = "1",
  newtool = "kp0",
  setpart = "space"
}
local ARROWS = {
  pause = "return",
  jump = "up",
  left = "left",
  right = "right",
  drop = "down",
  aimup = "w",
  aimdown = "s",
  grapple = "space",
  sail = "lalt",
  power = "lshift",
  powerlock = "capslock",
  nexttool = "d",
  prevtool = "a",
  usetool = "e",
  triggertool = "r",
  discardtool = "x",
  
  inventoryview = "1",
  newtool = "e",
  setpart = "space"
}

Properties = {}

Properties.Identity = "HyperMind"

Properties.Keybindings = ARROWS

Properties.WindowWidth = 1200
Properties.WindowHeight = 800

Properties.ChunkSize = {x=400,y=400}
Properties.NrChunkWide = math.ceil(Properties.WindowWidth / Properties.ChunkSize.x)
Properties.NrChunkHigh = math.ceil(Properties.WindowHeight / Properties.ChunkSize.y)

Properties.DropShadow = 1

Properties.Gravity = {x=0,y=500}
Properties.LevelOV = math.pi / 2
Properties.MaximumTimestep = 0.15
Properties.MaximumSimulationDistance = 2000
Properties.MaximumSimulationChunks = math.floor(Properties.MaximumSimulationDistance / Properties.ChunkSize.x)
Properties.LinkNeighborhood = 5


Properties.PlayerRadius = 5
Properties.PlayerMass = 10
Properties.PlayerInvMass = 0.1
Properties.MaxVelocity = 300
Properties.PlayerFreefallRotationPeriod = 2

Properties.PowerFactor = 2

Properties.PlayerStepWidth = 2
Properties.PlayerCrawlSpeed = 1
Properties.PlayerCrawlScanStep = 0.1
Properties.PlayerCrawlSpeedPowFactor = Properties.PowerFactor
Properties.PlayerRestitution = 0.2

Properties.LaunchPowerRate = 1
Properties.JumpPower = 1200
Properties.JumpPowerPowFactor = Properties.PowerFactor

Properties.GrapplePower = 600
Properties.GrappleDrawRadius = 2
Properties.GrappleFireTime = 1
Properties.GrappleChainLinkLength = 5
Properties.GrappleChainMaxLength = 500
Properties.GrappleChainLinkMass = 0.05
Properties.GrappleChainLinkInvMass = 20

Properties.SailFactor = 50
Properties.SailGraphicFactor = 5

Properties.VehicleLifetime = 5
Properties.SingleUseFactor = 2
Properties.ToolThingLaunchPower = 1000
Properties.ToolThingMass = 0.10
Properties.ToolThingInvMass = 10
Properties.ToolThingRadius = 3
Properties.ToolThingRestitution = 0.7
Properties.StandardReloadTime = 2
Properties.FastReloadTime = 0.25
Properties.VehicleStickThreshold = 2
Properties.BurstSpread = 0.1
Properties.BurstModeShots = 5
Properties.EmitterRate = 1
Properties.EmitterPeriod = 0.1
Properties.EmitterSpread = 0.3
Properties.EmittedToolThingSize = 1/3
Properties.CascadeNumber = 1.5
Properties.CascadeSpread = 0.3
Properties.CascadedToolThingSize = 0.5

Properties.ProjectionFalloff = 3
Properties.FadeLengthFactor = 0.5
Properties.VehicleTimeGrace = 2

Properties.AimSpeedMax = 4.2
Properties.AimSpeedAccel = 2.2
Properties.AimSpeedSlow = 4.8
Properties.AimDistance = 40
Properties.AimDrawRadius = 5
Properties.AimFocusDistance = 180

Properties.CollisionAlpha = 128
Properties.MaterialLevels = 4

Properties.PregenChunkBorder = 6

Properties.CameraPosResponse = 0.8
Properties.CameraVelResponse = 1.8

Properties.Windiness = 0.3
Properties.WindHorizontalness = 3
Properties.AirViscosity = 0.2

