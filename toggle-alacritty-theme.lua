-- Define the path to the file
local configPath = os.getenv("ALACRITTY_CONFIG_PATH")
local filePath = configPath .. "/alacritty.yml"

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
local startPattern = "# --- DONT MODIFY THIS. THIS IS AUTOMATED ---"
local endPattern = "# --- END ---"
local colorsPattern = "colors: *"
local themesPattern = "# %-%- THEMES:"

-- Split the content into lines
local lines = {}
for line in content:gmatch("[^\r\n]+") do
    table.insert(lines, line)
end

-- Initialize variables to track the section and themes
local inSection = false
local themes = {}
local currentTheme = ""

-- Process the file content
for i, line in ipairs(lines) do
    if line == startPattern then
        inSection = true
    elseif line == endPattern then
        inSection = false
    elseif inSection then
        if line:find(themesPattern) then
            -- Collect themes
            for j = i + 1, #lines do
                local themeLine = lines[j]:match("# %- (.+)")
                if themeLine then
                    table.insert(themes, themeLine)
                else
                    break
                end
            end
        elseif line:find(colorsPattern) then
            -- Capture the current theme
            currentTheme = line:match("colors: %*(.+)")
        end
    end
end

local newTheme = ""

-- Determine the new theme
if #themes > 1 and currentTheme ~= "" then
    local currentThemeIndex = 0
    for i, theme in ipairs(themes) do
        if theme == currentTheme then
            currentThemeIndex = i
            break
        end
    end
    local newThemeIndex = (currentThemeIndex % #themes) + 1
    newTheme = themes[newThemeIndex]

    -- Update the file content with the new theme
    for i, line in ipairs(lines) do
        if line:find(colorsPattern) then
            lines[i] = "colors: *" .. newTheme
            break
        end
    end
end

-- Join the lines back into a single string
local updatedContent = table.concat(lines, "\n")

-- Write the modified content back to the file
writeFile(filePath, updatedContent)

-- Output a message indicating success
print("Theme updated successfully to: " .. newTheme)

