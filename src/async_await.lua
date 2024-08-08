

local co = coroutine


local pong = function (func, callback)
  assert(type(func) == "function", "type error :: expected func")
  local thread = co.create(func)
  local step = nil
  step = function (...)
    local stat, ret = co.resume(thread, ...)
    assert(stat, ret)
    if co.status(thread) == "dead" then
      (callback or function () end)(ret)
    else
      assert(type(ret) == "function", "type error :: expected func")
      ret(step)
    end
  end
  step()
end

local wrap = function (func)
  assert(type(func) == "function", "type error :: expected func")
  local factory = function (...)
    local params = {...}
    local thunk = function (step)
      table.insert(params, step)
      return func(unpack(params))
    end
    return thunk
  end
  return factory
end

local join = function (thunks)
  local len = table.getn(thunks)
  local done = 0
  local acc = {}

  local thunk = function (step)
    if len == 0 then
      return step()
    end
    for i, tk in ipairs(thunks) do
      assert(type(tk) == "function", "thunk must be function")
      local callback = function (...)
        acc[i] = {...}
        done = done + 1
        if done == len then
          step(unpack(acc))
        end
      end
      tk(callback)
    end
  end
  return thunk
end

local await = function (defer)
  assert(type(defer) == "function", "type error :: expected func")
  return co.yield(defer)
end


local await_all = function (defer)
  assert(type(defer) == "table", "type error :: expected table")
  return co.yield(join(defer))
end


return {
  async = wrap(pong),
  await = await,
  await_all = await_all,
  wrap = wrap,
}
















































-- local co = coroutine
-- local unp = table.unpack ~= nil and table.unpack or unpack
-- local M = {}

-- local function next_step (thread, success, ...)
--   local res = {co.resume(thread, ...)}
--   assert(res[1], unp(res, 2))
--   if co.status(thread) ~= 'dead' then
--     res[2](function (...)
--       next_step(thread, success, ...)
--     end)
--   else
--     success(unp(res, 2))
--   end
-- end

-- M.async = function (func)
--   assert(type(func) == 'function', 'async params must be function')
--   local res = {
--     is_done = false,
--     data = nil,
--     cb = nil
--   }
--   next_step(co.create(func), function (...)
--     res.is_done = true
--     res.data = {...}
--     if res.cb ~= nil then
--       res.cb(unp(res.data))
--     end
--   end)
--   return function (cb)
--     if cb ~= nil and res.is_done then
--       cb(unp(res.data))
--     else
--       res.cb = cb
--     end
--   end
-- end

-- M.await = function (async_cb)
--   assert(type(async_cb) == 'function', 'await params must be function')
--   return co.yield(async_cb)
-- end

-- return M