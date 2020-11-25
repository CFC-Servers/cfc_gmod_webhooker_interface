require("cfclogger")
local TableToJSON
TableToJSON = util.TableToJSON
local Read
Read = file.Read
local gsub
gsub = string.gsub
local getContents
getContents = function(cfcPath)
  local contents = Read("cfc/" .. tostring(cfcPath), "DATA")
  return gsub(contents, "%s", "")
end
local LOGGER = CFCLogger("CFC Webhooker Interface")
local REALM = getContents("realm.txt")
local WEBHOOKER_URL = getContents("webhooker/url.txt")
if not (REALM) then
  return LOGGER:fatal("No realm set in cfc/realm.txt! Cannot load.")
end
if not (WEBHOOKER_URL) then
  return LOGGER:fatal("No webhooker URL set in cfc/webhooker/url.txt! Cannot load.")
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
      local url = tostring(self.baseURL) .. "/webhooks/gmod/" .. tostring(endpoint)
      content.realm = content.realm or REALM
      local body = TableToJSON(content)
      return HTTP({
        success = onSuccess,
        failed = onFailure,
        method = "POST",
        type = "application/json",
        url = url,
        body = body
      })
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.baseURL = WEBHOOKER_URL
      self.onSuccess = function(success)
        return LOGGER:info(success)
      end
      self.onFailure = function(failure)
        return LOGGER:error(failure)
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
return LOGGER:info("Loaded!")
