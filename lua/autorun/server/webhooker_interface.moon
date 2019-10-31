require "moonscript"

getWebhookerUrl = ->
    contents = file.Read "cfc/webhooker/url.txt", "DATA"
    string.gsub contents, "%s", ""

webhookerUrl = getWebhookerUrl!

onSuccess = (success) -> print(success)
onFailure = (failure) -> print(failure)

export WebhookerInterface

class WebhookerInterface
    new: =>
        @baseUrl = webhookerUrl
        @onSuccess = onSuccess
        @onFailure = onFailure

    send: (endpoint, content={}, onSuccess=@onSuccess, onFailure=@onFailure) =>
        data = util.TableToJSON content

        http.Post "#{@baseUrl}/#{endpoint}", data, onSuccess, onFailure
