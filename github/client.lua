function Manifest()
  return {
    name = 'Hatch',
    description = "A computer craft package manager that uses httpapi to support remote repos",
    version = '0.0.1',
    command = 'hatch',
    author = "Zenobius Jiricek <airtonix@gmail.com>",
    contributors = {},
    license = "CCA 3.0 Unported License. <http://creativecommons.org/licenses/by/3.0/deed.en_US>"
  }
end

local filePattern = "^(.*(%..*))$"
local app = {}
      app.settings = {
        cleanupOnSuccess = true,
        paths = {
          dir = {
            sourcesRoot = "/etc/apt/",
            packageCache = "/var/cache/apt/",
            binaryRoot = "/usr/local/bin/",
            installRoot = "/usr/local/share/",
            temp = "/tmp/",
          },
          files = {
            sourcesFile = "/etc/apt/sources.list",
            packageIndex = "/var/cache/apt/package.index",
          }
        }
      }

      app.commands = {
        {name="help",     value=nil,
          help={
            description= "This list."
          }},
        {name="update",   value=nil,
          help={
            description="update package index."
          }},
        {name="install",  value=nil,
          help={
            description="install packages.",
            example="Install one or more packages by package name:\n\n\t > hatch install n1 [n2 n3]"
          }},
        {name="upgrade",  value=nil,
          help={
            description="upgrade all packages."
          }},
        {name="remove",   value=nil,
          help={
            description="remove package.",
            example="Remove one or more packages by package name:\n\n\t > hatch remove n1 [n2 n3 n4]"
          }}
      }

--[[ Program entry point
  ]]
      function app:init(args)
          local commandList = {}
          for i=1, #app.commands do
            commandList[app.commands[i].name] = app.commands[i].name
          end

          if #args > 0 then
            -- yay for hidden features!
            if args[1] ~= "setup" and commandList[args[1]] == nil then
              print("Invalid command")
              error()
            end
          end

          if #args == 0 or args[1] == "help" then
            self:showUsage(args)
            return
          elseif #args > 1 then

            local command = app[args[1]]
            if command ~= nil then
              table.remove(args, 1)
              command(app, args)
            end
          end
        end

      function app:showHelp(search, long)
        local command = nil

        for i=1, #app.commands do
          if app.commands[i].name == search then
            command = app.commands[i]
            break
          end
        end

        if command~=nil then
          print(command.help.example)
        else
          print("No such command \"", search, "\"")
        end
      end

      function app:showUsage(args)
        local manifest = Manifest()
        local command
        if #args > 1 then
          self:showHelp(args[2])
        else
          print( string.format("%s %s", manifest.name, manifest.version))
          for i=1, #app.commands do
            command = app.commands[i]
            print( string.format("  %s : %s", self:padString(command.name, 8), command.help.description))
          end
        end
      end

--[[ Utilities
  ]]
      function app:padString (sText, iLen, iDir)
        local iTextLen = string.len(sText)
        -- Too short, pad
        if iTextLen < iLen then
              local iDiff = iLen - iTextLen
              return(sText..string.rep(" ",iDiff))
        end
        -- Too long, trim
        if iTextLen > iLen then
              return(string.sub(sText,1,iLen))
        end
        -- Exact length
        return(sText)
      end

      function app:formatTimeStamp(time)
        return string.format("%.3fs", time)
      end

      function app:getTimestamp()
          -- return current time in some form
          return os.time()
        end

      function app:alias(source, target)
        end

      function app:mergeTable(...)
      --[[ return a new array containing the concatenation of all of its
           parameters. Scaler parameters are included in place, and array
           parameters have their values shallow-copied to the final array.
           Note that userdata and function values are treated as scalar.]]
          local t = {}
          for n = 1,select("#",...) do
              local arg = select(n,...)
              if type(arg)=="table" then
                  for _,v in ipairs(arg) do
                      t[#t+1] = v
                  end
              else
                  t[#t+1] = arg
              end
          end
          return t
      end

      function app:getTmpDir()
          return string.format("%s/%d/", app.settings.dirs.tmp, self:getTimestamp())
        end

      function app:wget(url)
          http.request(url)
          while true do
            local event, url, body = os.pullEvent()
            if event == "http_success" then
              print("HTTP SUCCESSnURL = ", url)
              return body
            elseif event == "http_failure" then
              error("HTTP FAILUREnURL = ", url)     -- If the error is not catched, this will exit the program.
              return nil      -- In case this function is called via pcall.
            end
          end
        end

      function app:readPackage(sourceFile)
        local manifest = {}
          -- parse package details from package index
          -- return a table for that package
          return manifest
        end

      function app:getPackageDetails(lookingFor)
          local sourceFile = fs.open(app.settings.files.packageIndex, "r")
          local manifest = {}
          local found = false
          local EOF = false

          while not found and not EOF do
              manifest = self:readPackage(sourceFile)
              if manifest == nil then
                EOF = true
              elseif manifest.name == lookingFor then
                found = true
              end
          end
          sourceFile.close()
          return manifest
        end

      function app:downloadManifest(manifest)
        -- fetch files for package
        local tmpDir = self:getTmpDir()
        local installRoot = app.settings.dirs.installRoot
        local index
        local fileIndex = 1
        local file, fileTarget, downloadCache

        for index=1, #manifest do
            package = manifest[index]
            print( string.format("Processing: %s", package.name))
            downloadCache = string.format("%s/%s/", tmpDir, package.name)

            for fileIndex=1, #package.files do
              fileTarget = string.format("%s/%s/", downloadCache, file.name)
              print( string.format("Downloading: %s \n\t > %s", file.url, fileTarget) )
              self:wget(file.url, fileTarget)
            end

            os.move(downloadCache, string.format("%s/%s/", installRoot, manifest.name))
        end

        print( string.format("Downloaded: %s files", file.url, fileTarget) )
      end

      function app:buildDownloadManifest(...)
          local index
          local requiresIndex=1
          local manifest={}
          for index = 1,select("#",...) do
            -- get the meta data about this package
            package = self:getPackageDetails(select(index,...))
            -- check if it has dependancies
            if #package.requires > 0 then
              -- merge the manifest of dependancies into this manifest
              manifest = self:mergeTable(manifest, self:buildDownloadManifest(package.requires))
            end
            -- add this package after its dependancies
            manifest[#manifest+1] = package
          end
          return manifest
      end

      function app:addToIndex()
      end

      function app:postInstall()
        print("Post install")
        return true
      end

--[[ Public Methods
  ]]
      function app:install(...)
          local startTime = os.clock()
          print("Installing: ", table.concat(..., ", "))

          local manifest = self:buildDownloadManifest(arg)
          -- self:downloadManifest( manifest )
          -- self:postInstall( manifest )

          print(string.format("Finished in: %s\n", self:formatTimeStamp(os.clock() - startTime)))
        end

      function app:update()
        -- update package index
          local startTime = os.clock()

          local repoUrl
          local errors = {}
          local EOF = false
          local sourcesPath = app.settings.paths.files.sourcesFile

          if not fs.exists(sourcesPath) then
              print("apt/source.list does not exist! Abording.")
              error()
          end

          local sourcesFile = fs.open(sourcesPath, "r")

          while not EOF do
            repoUrl = sourcesFile.readLine()
            repoIndex = self:wget(repoUrl)
            if repoIndex ~= nil then
              self:addToIndex(repoPackages)
            else
              print(string.format("Missing index: %s", repoUrl))
              errors[#errors+1] = repoUrl
            end
          end

          print(string.format("Finished in: %s\n", self:formatTimeStamp(os.clock() - startTime)))

          if errorCount>0 then
            print("There were errors:")
            for i=0, #errors do
              print(errors[i])
            end
          end
          os.exit()
        end

      function app:upgrade(...)
          local startTime = os.clock()
        -- updates source list
          print(string.format("Finished in: %s\n", self:formatTimeStamp(os.clock() - startTime)))
          os.exit()
        end

      function app:setup()
          --create the directories and blank initial files
          print("Creating directories")
          for key, value in pairs(app.settings.paths.dir) do
            if not fs.exists(value) then
              print(key.." > "..value)
              fs.makeDir(value)
            end
          end

          print("Creating files")
          for key, value in pairs(app.settings.paths.files) do
            if not fs.exists(value) then
              print(key.." > "..value)
              fs.open(value, "w").close()
            end
          end

          -- backup the old sources list
          if fs.exists(app.settings.paths.files.sourceFile) then
            local sourceFileBackup = sourceFile.."-"..self:getTimestamp()..".old"
            print("Saving old sources.list to"..sourceFileBackup)
            fs.move(app.settings.paths.files.sourceFile, sourceFileBackup)
          end
        end



app:init({...})