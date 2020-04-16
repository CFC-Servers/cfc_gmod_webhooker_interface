require "cfclogger"

import TableToJSON from util
import Read from file
import gsub from string

getContents = (cfcPath) ->
    contents = Read "cfc/#{cfcPath}", "DATA"
    gsub contents, "%s", ""

LOGGER = CFCLogger "CFC Webhooker Interface"
REALM = getContents "realm.txt"
WEBHOOKER_URL = getContents "webhooker/url.txt"

unless REALM
    return LOGGER\fatal "No realm set in cfc/realm.txt! Cannot load."

unless WEBHOOKER_URL
    return LOGGER\fatal "No webhooker URL set in cfc/webhooker/url.txt! Cannot load."

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
