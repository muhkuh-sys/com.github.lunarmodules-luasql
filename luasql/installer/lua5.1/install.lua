local t = ...
local strDistId, strDistVersion, strCpuArch = t:get_platform()

if strDistId=='windows' then
  if strCpuArch=='x86' then
    t:install('windows_x86/lua_plugins/luasql/mysql.dll',            '${install_lua_cpath}/luasql/')
    t:install('windows_x86/lua_plugins/luasql/sqlite3.dll',          '${install_lua_cpath}/luasql/')
  elseif strCpuArch=='x86_64' then
    t:install('windows_x86_64/lua_plugins/luasql/mysql.dll',         '${install_lua_cpath}/luasql/')
    t:install('windows_x86_64/lua_plugins/luasql/sqlite3.dll',       '${install_lua_cpath}/luasql/')
  end

elseif strDistId=='ubuntu' then
  if strDistVersion=='12.04' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1204_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1204_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1204_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1204_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
    end

  elseif strDistVersion=='14.04' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1404_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1404_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1404_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1404_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
    end

  elseif strDistVersion=='16.04' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1604_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1604_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1604_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1604_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
    end
  end
end

return true
