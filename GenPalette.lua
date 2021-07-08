local spr = app.activeSprite
if not spr then
    return app.alert("There is no active sprite")
end

-- Each Palette:setColor() call will be grouped in one undoable
-- transaction. In this way the Edit > Undo History will contain only
-- one item that can be undone.

--local dlg = Dialog()
--dlg:entry{ id="user_value", label="User Value:", text="Default User" }
--dlg:button{ id="confirm", text="Confirm" }
--dlg:button{ id="cancel", text="Cancel" }
--dlg:show()
--local data = dlg.data
--if data.confirm then
--    app.alert("The given value is '" .. data.user_value .. "'")
--end

app.transaction(
        function()
            local status, err = pcall(function()
                -- How much to shift blue/yellow relative to how far away the root hue is
                local hueShiftVal = -.1
                local extremeLBuffer = .1
                local nHues = 10
                local ramps = {}
                local nColors = 0
                for i=1,nHues do
                    local rampSize = 5
                    ramps[i] = {(i-1) / nHues * 360.0, rampSize}
                    nColors = nColors+rampSize
                end
                app.alert(tostring(#ramps))
                math.randomseed(os.time())
                local pal = spr.palettes[1]
                pal:resize(nColors)
                local colorIndex = 0
                for i = 1,#ramps do
                    local rootHue = ramps[i][1]
                    local rampSize = ramps[i][2]
                    for j=1, rampSize do
                        -- Here we change each color of the palette with random RGB
                        -- values from 0-255 for each Red, Green, Blue component.
                        local saturation = .4
                        local newLightness =  extremeLBuffer + (j-1) * (1-2.0*extremeLBuffer) / (rampSize-1);
                        local newColor = Color{ hue=rootHue, saturation=0.4, lightness=newLightness, alpha=255}
                        newColor.lightness = newLightness
                        newColor.saturation = saturation
                        --local newColor = Color{r=1.0, g=0.0, b=1.0}
                        pal:setColor(colorIndex, newColor)
                        colorIndex = colorIndex + 1 
                    end
                end
            end)
            app.alert(err);
        end)

-- Here we redraw the screen to show the new palette, in a future this
-- shouldn't be necessary, but just in case...
app.refresh()