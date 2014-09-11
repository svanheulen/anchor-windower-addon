--[[
Copyright 2014 Seth VanHeulen

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
--]]

_addon.name = 'anchor'
_addon.version = '1.0.0'
_addon.command = 'anchor'
_addon.author = 'Seth VanHeulen (Acacia@Odin)'

function bit(p)
    return 2 ^ (p - 1)
end

function checkbit(x, p)
    return x % (p + p) >= p
end

function clearbit(x, p)
    return checkbit(x, p) and x - p or x
end

function string.clearbits(s, p, c)
    if c and c > 1 then
        s = s:clearbits(p + 1, c - 1)
    end
    local b = math.floor(p / 8)
    return s:sub(1, b) .. string.char(clearbit(s:byte(b + 1), bit(p % 8))) .. s:sub(b + 2)
end

function string.checkbit(s, p)
    local b = s:byte(math.floor(p / 8) + 1)
    return checkbit(b, bit(p % 8))
end

function check_incoming_chunk(id, original, modified, injected, blocked)
    if id == 0x28 then
        local category = math.floor((original:byte(11) % 64) / 4)
        if category == 11 then
            local new = original
            local startbit = 150
            for target = 1,original:byte(10) do
                new = new:clearbits(startbit + 60, 3)
                if original:checkbit(startbit + 121) then
                    startbit = startbit + 37
                end
                if original:checkbit(startbit + 122) then
                    startbit = startbit + 34
                end
                startbit = startbit + 123
            end
            return new
        end
    end
end

windower.register_event('incoming chunk', check_incoming_chunk)
