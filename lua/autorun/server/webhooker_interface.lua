local WebhookerUrl = (function()
  local contents = file.Read("cfc/webhooker/url.txt", "DATA")
  return string.gsub(contents, "%s", "")
end)()
local onSuccess
onSuccess = function(success)
  return print(success)
end
local onFailure
onFailure = function(failure)
  return print(failure)
end
do
  local _class_0
  local _base_0 = {
    send = function(self, endpoint, content, onSuccess, onFailure)
      if content == nil then
        content = { }
      end
      if onSuccess == nil then
        onSuccess = self.onSuccess
      end
      if onFailure == nil then
        onFailure = self.onFailure
      end
      return http.Post(tostring(self.baseUrl) .. "/" .. tostring(endpoint), content, onSuccess, onFailure)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.baseUrl = WebhookerUrl
      self.onSuccess = onSuccess
      self.onFailure = onFailure
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
  return _class_0
end
