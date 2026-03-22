local module = {}

local HttpService = game:GetService("HttpService")

module.meta = {
    name = "Config",
    tab = "Misc",
    side = "Right",
    priority = 999
}

local folder = "MunkeyHub/Configs/"
local file = folder .. game.PlaceId .. ".json"

module.Custom = {}

local function ensureFolder()

    if not isfolder("MunkeyHub") then
        makefolder("MunkeyHub")
    end

    if not isfolder(folder) then
        makefolder(folder)
    end

end

function module.save()

    ensureFolder()

    local data = {
        Toggles = {},
        Options = {},
        Custom = module.Custom
    }

    for k,v in pairs(Toggles) do
        data.Toggles[k] = v.Value
    end

    for k,v in pairs(Options) do

        if typeof(v.Value) == "Color3" then

            data.Options[k] = {
                __type = "Color3",
                r = v.Value.R,
                g = v.Value.G,
                b = v.Value.B
            }

        else
            data.Options[k] = v.Value
        end

    end

    writefile(file,HttpService:JSONEncode(data))

end

function module.load()

    if not isfile(file) then return end

    local data = HttpService:JSONDecode(readfile(file))

    if data.Toggles then
        for k,v in pairs(data.Toggles) do
            if Toggles[k] then
                Toggles[k]:SetValue(v)
            end
        end
    end

    if data.Options then
        for k,v in pairs(data.Options) do

            if Options[k] then

                if type(v) == "table" and v.__type == "Color3" then

                    Options[k]:SetValue(
                        Color3.new(v.r,v.g,v.b)
                    )

                else
                    Options[k]:SetValue(v)
                end

            end

        end
    end

    module.Custom = data.Custom or {}

end

function module.init(ctx)

    local box = ctx.box

    box:AddButton("Save Config",function()
        module.save()
    end)

    box:AddButton("Load Config",function()
        module.load()
    end)

end

return module