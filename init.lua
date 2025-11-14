AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local PRINT_SOUND = Sound("ambient/machines/combine_terminal_idle4.wav")
local OVERHEAT_SOUND = Sound("ambient/fire/gascan_ignite1.wav")

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self.LastPrint = CurTime()
    self.Heat = 0

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

-- Securely network printer data
function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "HeatLevel")
    self:NetworkVar("Int", 1, "StoredMoney")
end

function ENT:Think()
    -- Cooling
    self.Heat = math.max(self.Heat - ENT.CoolRate * FrameTime(), 0)
    self:SetHeatLevel(math.Round(self.Heat))

    -- Money printing
    if CurTime() - self.LastPrint >= ENT.PrintRate then
        self.LastPrint = CurTime()

        if self.Heat >= ENT.MaxHeat then
            self:Overheat()
            return
        end

        self:PrintMoney()
    end

    self:NextThink(CurTime())
    return true
end

function ENT:PrintMoney()
    self:EmitSound(PRINT_SOUND, 55, 120)
    self.Heat = self.Heat + ENT.HeatIncrease * ENT.MultHeat

    local amount = math.floor(ENT.PrintAmount * ENT.MultMoney)
    self:SetStoredMoney(self:GetStoredMoney() + amount)
end

function ENT:Overheat()
    self:EmitSound(OVERHEAT_SOUND, 80, 100)
    local effect = EffectData()
    effect:SetOrigin(self:GetPos())
    util.Effect("HelicopterMegaBomb", effect)

    self:Remove()
end

-- Collect money
function ENT:Use(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local amt = self:GetStoredMoney()
    if amt <= 0 then return end

    ply:addMoney(amt)
    self:SetStoredMoney(0)
    ply:ChatPrint("You collected $" .. amt .. " from your Quantum Printer!")
end
