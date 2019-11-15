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

        print "[WebhookInterface] Sending the following form to #{url}:"
        PrintTable content
        print ""

        -- Keys and values must be strings
        http_content = {}
        for k, v in pairs content
            string_k = tostring k
            string_v = tostring v

            http_content[string_k] = string_v

        http.Post url, http_content, on_success, on_failure

print("[WebhookerInterface] Loaded!")
