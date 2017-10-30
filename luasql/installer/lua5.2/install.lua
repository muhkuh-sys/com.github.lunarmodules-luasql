local t = ...
local strDistId, strDistVersion, strCpuArch = t:get_platform()
local tResult

if strDistId=='windows' then
  if strCpuArch=='x86' then
    t:install('windows_x86/lua_plugins/luasql/mysql.dll',            '${install_lua_cpath}/luasql/')
    t:install('windows_x86/lua_plugins/luasql/sqlite3.dll',          '${install_lua_cpath}/luasql/')
    tResult = true
  elseif strCpuArch=='x86_64' then
    t:install('windows_x86_64/lua_plugins/luasql/mysql.dll',         '${install_lua_cpath}/luasql/')
    t:install('windows_x86_64/lua_plugins/luasql/sqlite3.dll',       '${install_lua_cpath}/luasql/')
    tResult = true
  end

elseif strDistId=='ubuntu' then
  if strDistVersion=='12.04' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1204_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1204_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
      tResult = true
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1204_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1204_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
      tResult = true
    end

  elseif strDistVersion=='14.04' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1404_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1404_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
      tResult = true
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1404_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1404_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
      tResult = true
    end

  elseif strDistVersion=='16.04' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1604_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1604_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
      tResult = true
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1604_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1604_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
      tResult = true
    end

  elseif strDistVersion=='17.04' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1704_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1704_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
      tResult = true
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1704_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1704_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
      tResult = true
    end

  elseif strDistVersion=='17.10' then
    if strCpuArch=='x86' then
      t:install('ubuntu_1710_x86/lua_plugins/luasql/mysql.so',       '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1710_x86/lua_plugins/luasql/sqlite3.so',     '${install_lua_cpath}/luasql/')
      tResult = true
    elseif strCpuArch=='x86_64' then
      t:install('ubuntu_1710_x86_64/lua_plugins/luasql/mysql.so',    '${install_lua_cpath}/luasql/')
      t:install('ubuntu_1710_x86_64/lua_plugins/luasql/sqlite3.so',  '${install_lua_cpath}/luasql/')
      tResult = true
    end
  end
end

return tResult
