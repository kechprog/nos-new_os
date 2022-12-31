---@diagnostic disable: need-check-nil, unused-local, unused-function

local naughty = require("naughty")

local exec = function(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

local M = {}

local function display_volume(volume)
  naughty.notify({
    title = "VOLUME",
    text = tostring(volume),
    timeout = M.TIME_OUT
  })
end

------------------------
----      LIB       ----
------------------------

M.VOL_DELTA = 10
M.TIME_OUT  = 2

function M.vol_up()
  local vol = tonumber(exec("pamixer --get-volume"))
  if vol == 100 then display_volume(vol); return end
  vol = vol + M.VOL_DELTA
  exec("pamixer --set-volume " .. vol)
  display_volume(vol)
end

return M
