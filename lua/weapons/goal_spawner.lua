-- initialize global tables
comp3190 = comp3190 or {}
comp3190.goals = comp3190.goals or {}

-- send the file to the client
AddCSLuaFile()

-- weapon setup
SWEP.Spawnable = true
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Category = "COMP 3190"
SWEP.DrawAmmo = false

-- spawner does not use ammo
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

-- left click to spawn goals
function SWEP:PrimaryAttack()

	-- create a goal post
	local goal = ents.Create("prop_physics")
	goal:SetModel("models/hunter/blocks/cube025x3x025.mdl")
	goal:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	-- perform raycast to spawn on ground
	goal:SetPos(self:GetOwner():GetEyeTrace().HitPos)
	goal:Spawn()
	
	-- rotate and freeze the bar so it is facing upright
	goal:GetPhysicsObject():SetAngles(Angle(0, 0, -90))
	goal:GetPhysicsObject():EnableMotion(false)
	
	-- flag to identify this custom object
	goal.goal_post = true
	
	-- add it to the goals
	table.insert(comp3190.goals, goal)
end

-- right click to delete goals
function SWEP:SecondaryAttack()
	-- get raytraced entity (if there is one)
	local entity = self:GetOwner():GetEyeTrace().Entity
	
	-- check if it is our custom object
	if (entity.goal_post) then
		comp3190.DeleteGoalPost(entity)
	end
end