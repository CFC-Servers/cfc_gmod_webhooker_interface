require "logger"
import TableToJSON from util

logger = Logger "CFC Webhooker Interface"
realm = CreateConVar "cfc_realm", "unknown", FCVAR_REPLICATED + FCVAR_ARCHIVE
url = CreateConVar "cfc_webhooker_url", "", FCVAR_PROTECTED
disabled = CreateConVar "cfc_webhooker_disabled", "false", FCVAR_PROTECTED

export WebhookerInterface
class WebhookerInterface
    @disabled = disabled

    new: =>
        @baseURL = url\GetString!
        @onSuccess = (success) -> logger\info success
        @onFailure = (failure) -> logger\error failure

    send: (endpoint, content={}, onSuccess=@onSuccess, onFailure=@onFailure) =>
        return if @@disabled\GetBool!

        url = "#{@baseURL}/webhooks/gmod/#{endpoint}"
        content.realm or= realm\GetString!
        body = TableToJSON content

        HTTP
            success: onSuccess
            failed: onFailure
            method: "POST"
            type: "application/json"
            :url
            :body

logger\info "Loaded!"
