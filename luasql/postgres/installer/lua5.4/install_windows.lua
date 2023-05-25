local t = ...
local strDistId, strDistVersion, strCpuArch = t:get_platform()
local tResult

if strDistId=='@JONCHKI_PLATFORM_DIST_ID@' and strCpuArch=='@JONCHKI_PLATFORM_CPU_ARCH@' then
  t:install('lua_plugins/luasql/postgres.dll',    '${install_lua_cpath}/luasql/')
  tResult = true
end

return tResult
