local t = ...
local strDistId, strDistVersion, strCpuArch = t:get_platform()
local tResult

if strDistId=='@JONCHKI_PLATFORM_DIST_ID@' and strDistVersion=='@JONCHKI_PLATFORM_DIST_VERSION@' then
  t:install('lua_plugins/luasql/mysql.dll',    '${install_lua_cpath}/luasql/')
  t:install('lua_plugins/luasql/sqlite3.dll',  '${install_lua_cpath}/luasql/')
  tResult = true
end

return tResult
