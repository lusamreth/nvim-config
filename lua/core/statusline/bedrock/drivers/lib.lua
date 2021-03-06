H = {}

Uniq = {}
function Uniq:init()
    local ld = {}
    self.prefixes = {}
    self.state = {}
    self.set = function(k, v)
        local p = {
            [k] = v
        }
        self.prefixes = p
    end
    setmetatable(ld, Uniq)
    return self
end

function Uniq:insert_prefix(prefix, item)
    local p = self.prefixes[prefix]
    if p == nil then
        error("Cannot push to nil value", 1)
    end

    local l = self.state[prefix]

    self.prefixes[prefix][l] = item
    table.insert(self.prefixes[prefix], l + 1, item)
    self.state[prefix] = l + 1
    return item
end

function Uniq:get_id(prefix)
    self.prefixes[prefix] = {}

    if self.state[prefix] == nil then
        self.state[prefix] = 1
    end

    --self.prefixes[prefix]
    local a = self:insert_prefix(prefix, prefix .. self.state[prefix] .. "_" .. RandomString(6))
    return a
end

H.uniq = Uniq

H.nest = function(k, v)
    local arr = {}
    arr[k] = v
    return arr
end

-- test
function TestUniq()
    local u = Uniq:init()

    local p = u:get_id("apple")
    local p1 = u:get_id("apple")

    local id = u:get_id("padding")
    local id1 = u:get_id("padding")

    assert(id1 ~= id)
    assert(p1 ~= p)
end

local u = Uniq:init()

H.uniq = {}
H.uniq.get_id = function(a)
    return u:get_id(a)
end

H.uniq.get_key = function(tab)
    -- assert(tab)
    -- print("nex", next(tab), tab, #pt)
    local k, _ = next(tab)
    return k
    -- return get_key_set(tab)[1]
end

H.uniq.get_key_set = function(tab)
    local keyset = {}

    for n, k in pairs(tab) do
        keyset[n] = H.uniq.get_key(k)
    end
    return keyset
end

return H
