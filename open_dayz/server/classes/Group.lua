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

function Group:constructor(groupName)
	self.m_Name = groupName
	self.m_Members = {}
end

function Group:addMember(player, rank)
	checkArgs("Group:addMember", "userdata")
	self.m_Members[player] = rank or 1
end

function Group:removeMember(player)
	self.m_Members[player] = nil
end

function Group:setMemberRank(player, rank)
	checkArgs("Group:setMemberRank", "userdata", "number")
	self.m_Members[player] = rank
end

function Group:getMemberRank(player)
	checkArgs("Group:getMemberRank", "userdata")
	return self.m_Members[player]
end
