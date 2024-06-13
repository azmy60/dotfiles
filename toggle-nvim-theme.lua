-- Define the path to the file
local configPath = os.getenv("NVIM_CONFIG_PATH")
local filePath = configPath .. "/lua/theme.lua"

-- Function to read the file content
local function readFile(filePath)
    local file = io.open(filePath, "r")
    if not file then
        print("Could not open file " .. filePath)
        os.exit(1)
    end
    local content = file:read("*all")
    file:close()
    return content
end

-- Function to write the file content
local function writeFile(filePath, content)
    local file = io.open(filePath, "w")
    if not file then
        print("Could not open file " .. filePath)
        os.exit(1)
    end
    file:write(content)
    file:close()
end

-- Read the file content
local content = readFile(filePath)

-- Define the patterns to search for
local themesPattern = "-- THEMES:%s*([%w%-]+),%s*([%w%-]+)"
local flavourPattern = "flavour%s*=%s*'([%w%-]+)'"

-- Extract themes and current flavour
local theme1, theme2 = content:match(themesPattern)
local themes = { theme1, theme2 }
local currentFlavour = content:match(flavourPattern)

-- Determine the new flavour
local newFlavour
if #themes > 1 and currentFlavour then
    for i, theme in ipairs(themes) do
        if theme == currentFlavour then
            newFlavour = themes[(i % #themes) + 1]
            break
        end
    end

    -- Update the file content with the new flavour
    content = content:gsub(flavourPattern, "flavour = '" .. newFlavour .. "'")
end

-- Write the modified content back to the file
writeFile(filePath, content)

-- Output a message indicating success
print("File updated successfully to flavour: " .. newFlavour)
