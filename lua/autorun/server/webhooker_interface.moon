require "moonscript"

webhookerUrl = (
    ->
        contents = file.Read "cfc/webhooker/url.txt", "DATA"
        string.gsub contents, "%s", ""
)!

onSuccess = (success) -> print success
onFailure = (failure) -> print(failure)

export WebhookerInterface
class WebhookerInterface
    new: =>
        @baseUrl = webhookerUrl
        @onSuccess = onSuccess
        @onFailure = onFailure

    send: (endpoint, content={}, onSuccess=@onSuccess, onFailure=@onFailure) =>
        http.Post "#{@baseUrl}/#{endpoint}", content, onSuccess, onFailure
