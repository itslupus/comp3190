-- initialize global tables
comp3190 = comp3190 or {}
comp3190.goals = comp3190.goals or {}
comp3190.bot_states = comp3190.bot_states or {}

-- send file to client
AddCSLuaFile()

-- initialize bot
ENT.Base = "base_nextbot"
ENT.Spawnable = true

-- make it spawnable by adding it in game
list.Set("NPC", "bot", {
	Name = "Bot",
	Class = "bot",
	Category = "COMP 3190"
})

-- models for the bot
local models = {
	"models/Humans/Group01/Female_01.mdl",
	"models/Humans/Group01/Female_02.mdl",
	"models/Humans/Group01/Female_03.mdl",
	"models/Humans/Group01/Female_04.mdl",
	"models/Humans/Group01/Female_06.mdl",
	"models/Humans/Group01/Female_07.mdl",
	"models/Humans/Group01/Male_01.mdl",
	"models/Humans/Group01/male_02.mdl",
	"models/Humans/Group01/male_03.mdl",
	"models/Humans/Group01/Male_04.mdl",
	"models/Humans/Group01/Male_05.mdl",
	"models/Humans/Group01/male_06.mdl",
	"models/Humans/Group01/male_07.mdl",
	"models/Humans/Group01/male_08.mdl",
	"models/Humans/Group01/male_09.mdl"
}

--[[
	getter and setters
]]
function ENT:SetGoal(entity)
	self.curr_goal = entity
end

function ENT:GetGoal()
	return self.curr_goal or nil
end

function ENT:SetState(state)
	self.curr_state = state
end

function ENT:GetState()
	return self.curr_state or nil
end

--[[
	ENTITY related overrides
]]
function ENT:Initialize()
	-- pick random model
	self:SetModel(models[math.random(#models)])
	self:SetState(comp3190.bot_states.IDLE)
end

-- main loop
function ENT:RunBehaviour()
	self.loco:SetDesiredSpeed(200)
	
	while (1) do
		if (self:GetState() == comp3190.bot_states.IDLE) then
			--[[
				IDLE state, bot is waiting around for goal
			]]
			self:StartActivity(ACT_IDLE)
			
			local min_dist = 999999999
			local closest_goal = nil
		
			-- search for the closest goal (if any)
			for _, goal in pairs(comp3190.goals) do
				local dist = self:GetRangeSquaredTo(goal:GetPos())
				
				if (dist <= min_dist) then
					min_dist = dist
					closest_goal = goal
				end
			end
			
			if (closest_goal ~= nil) then
				-- found closest goal
				self:SetGoal(closest_goal)
				self:SetState(comp3190.bot_states.MOVE)
			else
				-- no goal, wait a second before searching again
				coroutine.wait(1)
			end
		elseif (self:GetState() == comp3190.bot_states.MOVE) then
			--[[
				MOVE state, bot is currently moving to the goal
			]]
			
			self:StartActivity(ACT_RUN)
			
			-- blocking function call, move to goal
			self:MoveToPos(self:GetGoal():GetPos())
			
			-- moved to goal post, post move state
			self:SetState(comp3190.bot_states.POST_MOVE)
		elseif (self:GetState() == comp3190.bot_states.POST_MOVE) then
			--[[
				POST state, bot has reached goal, reset back to IDLE state
			]]
			if (IsValid(self:GetGoal())) then
				comp3190.DeleteGoalPost(self:GetGoal())
			end
		
			-- moved to goal post, post move state
			self:SetState(comp3190.bot_states.IDLE)
		end
		
		coroutine.yield()
	end
	
end