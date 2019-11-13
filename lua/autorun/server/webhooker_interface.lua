local WebhookerUrl = (function()
  local contents = file.Read("cfc/webhooker/url.txt", "DATA")
  return string.gsub(contents, "%s", "")
end)()
do
  local _class_0
  local _base_0 = {
    send = function(self, endpoint, content, on_success, on_failure)
      if content == nil then
        content = { }
      end
      if on_success == nil then
        on_success = self.on_success
      end
      if on_failure == nil then
        on_failure = self.on_failure
      end
      local url = tostring(self.base_url) .. "/" .. tostring(endpoint)
      print(url)
      print(content)
      return http.Post(tostring(self.base_url) .. "/webhooks/gmod/" .. tostring(endpoint), content, on_success, on_failure)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.base_url = WebhookerUrl
      self.on_success = function(success)
        return print(success)
      end
      self.on_failure = function(failure)
        return print(failure)
      end
    end,
    __base = _base_0,
    __name = "WebhookerInterface"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  WebhookerInterface = _class_0
end
return print("[WebhookerInterface] Loaded!")
