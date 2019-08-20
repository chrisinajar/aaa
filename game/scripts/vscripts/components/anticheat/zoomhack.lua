
ZoomHack = Components:Register('ZoomHack', COMPONENT_STRATEGY)

function ZoomHack:Init ()
  FilterManager:AddFilter(FilterManager.ExecuteOrder, ZoomHack, Dynamic_Wrap(ZoomHack, "Filter"))
end

function ZoomHack:Filter (order)
  Debug:EnableDebugging()
  DebugPrintTable(order)

  -- always let through
  return true
end
