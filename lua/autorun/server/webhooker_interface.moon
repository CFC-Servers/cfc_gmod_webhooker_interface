WebhookerUrl = (
    ->
        contents = file.Read "cfc/webhooker/url.txt", "DATA"
        string.gsub contents, "%s", ""
)!

export WebhookerInterface
class WebhookerInterface
    new: =>
        @base_url = WebhookerUrl
        @on_success = (success) -> print success
        @on_failure = (failure) -> print failure

    send: (endpoint, content={}, on_success=@on_success, on_failure=@on_failure) =>
        url = "#{@base_url}/webhooks/gmod/#{endpoint}"
        http.Post url, content, on_success, on_failure

print("[WebhookerInterface] Loaded!")
