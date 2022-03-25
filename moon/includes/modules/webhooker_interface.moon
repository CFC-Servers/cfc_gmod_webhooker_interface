require "logger"
import TableToJSON from util

logger = Logger "CFC Webhooker Interface"
REALM = CreateConVar "cfc_realm", "unknown", FCVAR_REPLICATED + FCVAR_ARCHIVE
URL = CreateConVar "cfc_webhooker_url", "", FCVAR_PROTECTED
DISABLED = CreateConVar "cfc_webhooker_disabled", 0, FCVAR_PROTECTED

export WebhookerInterface
class WebhookerInterface
    @disabled = DISABLED

    new: =>
        @onSuccess = logger\info
        @onFailure = logger\error

    send: (endpoint, content={}, onSuccess=@onSuccess, onFailure=@onFailure) =>
        return if @@disabled\GetBool!

        url = "#{@baseURL or URL\GetString!}/webhooks/gmod/#{endpoint}"
        content.realm or= REALM\GetString!
        body = TableToJSON content

        HTTP
            success: onSuccess
            failed: onFailure
            method: "POST"
            type: "application/json"
            :url
            :body

logger\info "Loaded!"
