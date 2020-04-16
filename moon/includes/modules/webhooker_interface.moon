require "cfclogger"

import TableToJSON from util
import Read from file
import gsub from string

LOGGER = CFCLogger "CFC Webhooker Interface"
REALM = Read "cfc/realm.txt", "DATA"
WEBHOOKER_URL = (
    ->
        contents = Read "cfc/webhooker/url.txt", "DATA"
        gsub contents, "%s", ""
)!

unless REALM
    return LOGGER\fatal "No realm set in cfc/realm.txt! Cannot load."

export WebhookerInterface
class WebhookerInterface
    new: =>
        @baseURL = WEBHOOKER_URL
        @onSuccess = (success) -> LOGGER\info success
        @onFailure = (failure) -> LOGGER\error failure

    send: (endpoint, content={}, onSuccess=@onSuccess, onFailure=@onFailure) =>
        url = "#{@baseURL}/webhooks/gmod/#{endpoint}"

        content.realm or= REALM
        body = TableToJSON content

        HTTP
            success: onSuccess
            failed: onFailure
            method: "POST"
            type: "application/json"
            :url
            :body

LOGGER\info "Loaded!"
