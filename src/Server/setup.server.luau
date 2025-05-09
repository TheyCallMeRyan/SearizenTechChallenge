-- workspace:SetAttribute("DebugNetworking", true)

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Setup
local Assets = ReplicatedStorage.Assets
Assets.Enemies.Parent = workspace

require("@ServerECS/setup")