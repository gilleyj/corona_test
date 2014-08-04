-- debug logging:
print ("Scale factor: ", display.pixelWidth / display.actualContentWidth )

-- end debug logging

-- set up
-- Physics needs to be set up and started before any other require's in order to ensure physics is available to all modules
local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )
local json = require("json")
local widget = require("widget")

local Star = require("star")
local hilite = require("hilite")

-- my ship pooper
local ship = require("ship")


display.setStatusBar( display.HiddenStatusBar )

local initGUI, initStars, toggleDebug, start, processTap, tapCollision

local stars = {}

local NUM_STARS = 400

function initStars()
    local starGroup = display.newGroup( )
    for i=1, NUM_STARS do
        stars[i] = Star:new()
        stars[i]:init()
    end
    print( "Generated " .. #stars .. " stars" )
end

function initGUI()
    local debugButton = widget.newButton( {
        top = 20,
        left = 20,
        label = "D",
        labelAlign = "center",
        labelColor = { default = { 0.62, 0.07, 0.04 }},
        labelXOffset = 8,
        labelYOffset = -7,
        font = "Erbos Draco 1st Open NBP",
        fontSize = 40,
        onEvent = toggleDebug,
        emboss = true,
        shape = "roundedRect",
        width = 50,
        height = 50,
        cornerRadius = 5,
        fillColor = {
            default = { 0.6, 0.6, 0.6 },
            over = { 0.4, 0.4, 0.4 },
        },
    } )
    debugButton:addEventListener( "tap", toggleDebug )
end

function start() 
    initStars()
    initGUI()
    hilite:init()
 
    ship:init()

end

function processTap(event)
    if event.phase == "ended" then
        print("Tapped: ", event.x, ", ", event.y)
        local soi = display.newCircle(event.x, event.y, 30)
        timer.performWithDelay( 50, function () soi:removeSelf() end )
        physics.addBody( soi, "dynamic", { filter = { maskBits = 4, categoryBits = 1 } } )
        soi:addEventListener( "collision", tapCollision )
    end
end

function tapCollision(collision) 
    -- print("Collision from: ", collision.target.x, collision.target.y)
    -- print("Collision with: ", collision.other.x, collision.other.y)
    hilite:highlight(collision.other, collision.target.x, collision.target.y)
end

local isDebug = false
function toggleDebug(event)
    if event.phase == "ended" then
        isDebug = not isDebug

        if isDebug then
            physics.setDrawMode( "hybrid" )
        else
            physics.setDrawMode( "normal" )
        end
    end
    return true
end

local function main() 
    local font = "Erbos Draco 1st Open NBP"
    --local font = "HelveticaNeue-Light"
    local helloWordText = display.newText( "hello", display.contentWidth / 2, display.contentHeight / 2 - 25, font, 60)
    timer.performWithDelay( 1000, function() display.remove( helloWordText ); start() end )

    Runtime:addEventListener( "touch", processTap )

end

main()