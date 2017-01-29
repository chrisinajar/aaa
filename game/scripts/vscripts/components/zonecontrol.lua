
-- Taken from bb template
if ZoneControl == nil then
    DebugPrint ( '[ZoneControl] creating new ZoneControl object' )
    ZoneControl = class({})
end

function ZoneControl:Init ()

  local zones = Entities:FindAllByName('block_blink')
  for _,zone in pairs(zones) do
    DebugPrint ( zone:GetBounds() )
  end
end
