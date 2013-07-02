
local url
local JSON = os.loadAPI("lib/json")

local Gist = {}

    Gist.defaults = {
        root = "/gists/",
        temp = "/tmp/",
        cleanupOnSuccess = true,
        gistApiRoot = 'https://api.github.com/gists/'
    }

    Gist.get = function( url )
            http.request( url )
            while true do
                    local event, url, body = os.pullEvent()
                    if event == "http_success" then
                            print( "HTTP SUCCESSnURL = "..url )
                            return body
                    elseif event == "http_failure" then
                            error( "HTTP FAILUREnURL = "..url )     -- If the error is not catched, this will exit the program.
                            return nil      -- In case this function is called via pcall.
                    end
            end
    end

    Gist.getPackage = function(gist_id, ...)
            local jsonResponse, json
            jsonResponse = Gist.get(Gist.settings.gistApiRoot .. gist_id)
            if jsonResponse then
                json = JSON:decode(jsonResponse.readAll())

            end
        end


    Gist.update = function(package, ... )
        -- updates a package to either the pinned version or the latest discovered version
        end

    Gist.init = function( ... )

        end


Gist.init(arg)
