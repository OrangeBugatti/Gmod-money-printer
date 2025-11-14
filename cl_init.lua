include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos() + Vector(0, 0, 20)
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)

    cam.Start3D2D(pos, ang, 0.1)
        draw.SimpleText("Quantum Printer", "DermaLarge", 0, 0, Color(150, 200, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText("Stored Money: $" .. self:GetStoredMoney(), "DermaDefault", 0, 40, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText("Heat: " .. self:GetHeatLevel() .. "%", "DermaDefault", 0, 60, Color(255, 180, 180), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
