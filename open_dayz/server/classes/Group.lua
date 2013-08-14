-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Group.lua
-- *  PURPOSE:     Simple group class
-- *
-- ****************************************************************************
Group = inherit(Exported)

enum("GROUP_RANK_MEMBER", "grouprank")
enum("GROUP_RANK_SUBLEADER", "grouprank")
enum("GROUP_RANK_LEADER", "grouprank")

-- Possible signatures:
-- - Group:constructor(id) - load a group from database
-- - Group:constructor(name) - creates a new group
function Group:constructor(param1)
	Async.create(function()
		self.m_Members = {}

		if type(param1) == "number" then
			local Id = param1
			
			-- Read name
			local result = sql:queryFetchSingle(Async.waitFor(self), "SELECT Name FROM ??_groups WHERE Id = ?", sql:getPrefix(), Id)
			local row = Async.wait()
			self.m_Id = Id
			self.m_Name = row.Name
			
			-- Read members
			result = sql:queryFetch(Async.waitFor(self), "SELECT UserId, Rank FROM ??_groups_players WHERE GroupId = ?", sql:getPrefix(), self.m_Id)
			local rows = Async.wait()
			for k, row in ipairs(rows) do
				self.m_Members[tonumber(row.UserId)] = tonumber(row.Rank)
			end
			
		elseif type(param1) == "string" then
			-- Create a totally new group
			self.m_Name = param1
			sql:queryExec("INSERT INTO ??_groups (Name) VALUES(?)", sql:getPrefix(), self.m_Name)
			self.m_Id = sql:lastInsertId()
		else
			error("Bad argument passed to Group:constructor")
		end
	end)()
end

function Group:purge()
	-- Delete everything that's related to this group
	sql:queryExec("DELETE FROM ??_groups_players WHERE GroupId = ?", self.m_Id)
	sql:queryExec("DELETE FROM ??_groups WHERE Id = ?", self.m_Id)
	
	-- Call the destructor
	delete(self)
end

function Group:getName()
	return self.m_Name
end

function Group:addMember(player, rank)
	checkArgs("Group:addMember", "userdata")
	self.m_Members[player:getId()] = rank or 1
	
	return sql:queryExec("INSERT INTO ??_groups_players (GroupId, UserId, Rank) VALUES(?, ?, ?)", sql:getPrefix(), self.m_Id, player:getId(), rank)
end

function Group:removeMember(player)
	checkArgs("Group:removeMember", "userdata")
	self.m_Members[player:getId()] = nil
	
	return sql:queryExec("DELETE FROM ??_groups_players WHERE GroupId = ? AND UserId = ?", sql:getPrefix(), self.m_Id, player:getId())
end

function Group:getMembers()
	return self.m_Members
end

function Group:isPlayerMember(player)
	checkArgs("Group:isPlayerMember", "userdata")
	return self.m_Members[player:getId()] ~= nil
end

function Group:setMemberRank(player, rank)
	checkArgs("Group:setMemberRank", "userdata", "number")
	
	if not self.m_Members[player:getId()] then
		return false
	end
	
	self.m_Members[player:getId()] = rank
	
	return sql:queryExec("UPDATE ??_groups_players SET Rank = ? WHERE GroupId = ? AND UserId = ?", sql:getPrefix(), rank, self.m_Id, player:getId())
end

function Group:getMemberRank(player)
	checkArgs("Group:getMemberRank", "userdata")
	return self.m_Members[player:getId()]
end

function Group:sendMessage(text, r, g, b, ...)
	for k, player in ipairs(getElementsByType("player")) do
		player:sendMessage(text:format(...), r, g, b)
	end
end
