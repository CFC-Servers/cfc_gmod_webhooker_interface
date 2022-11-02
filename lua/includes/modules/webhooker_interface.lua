require("logger")
local TableToJSON
TableToJSON = util.TableToJSON
local logger = Logger("CFC Webhooker Interface")
local REALM = CreateConVar("cfc_realm", "unknown", FCVAR_REPLICATED + FCVAR_ARCHIVE, "The Realm Name")
local URL = CreateConVar("cfc_webhooker_url", "", FCVAR_PROTECTED)
local DISABLED = CreateConVar("cfc_webhooker_disabled", 0, FCVAR_PROTECTED)
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
      if self.__class.disabled:GetBool() then
        return 
      end
      local url = tostring(self.baseURL or URL:GetString()) .. "/webhooks/gmod/" .. tostring(endpoint)
      content.realm = content.realm or REALM:GetString()
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
      do
        local _base_1 = logger
        local _fn_0 = _base_1.info
        self.onSuccess = function(...)
          return _fn_0(_base_1, ...)
        end
      end
      do
        local _base_1 = logger
        local _fn_0 = _base_1.error
        self.onFailure = function(...)
          return _fn_0(_base_1, ...)
        end
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
  local self = _class_0
  self.disabled = DISABLED
  WebhookerInterface = _class_0
end
return logger:info("Loaded!")
