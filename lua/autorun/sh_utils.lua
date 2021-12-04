-- initialize global tables
comp3190 = comp3190 or {}
comp3190.goals = comp3190.goals or {}
comp3190.bot_states = {
	IDLE = 1,
	MOVE = 2,
	POST_MOVE = 3
}

-- create namespaced function
function comp3190.DeleteGoalPost(entity)
	-- search our global table and remove it
	for k, goal in pairs(comp3190.goals) do
		if (goal == entity) then
			-- remove goal post from global table and from world
			table.remove(comp3190.goals, k)
			entity:Remove()
			
			break
		end
	end
end