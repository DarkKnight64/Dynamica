settings().Rendering.FrameRateManager = 2
settings().Network.SendRate = 30
settings().Network.ReceiveRate = 60
settings().Network.PhysicsReplicationUpdateRate = 30000
settings().Network.PhysicsReceiveDelayFactor = 0
settings().Network.PhysicsReliability = 4
settings().Network.PhysicsSend = 1
local name = "" --Set the name here using PHP or another thing
local ip = "" --Set the IP
local port = 0--Set the port
local pid = 0--Set the player ID
local hash = ""--Set the hash to be used in name verification
local appearance = ""--URL of character appearance
game:GetService("Visit")
game:SetMessage("Connecting to server...")
local client = game:GetService("NetworkClient")
client.Name = "connection"
local co2 = coroutine.create(
   function ()
     while true do
     	g = dofile("http://url/to/see/if/banned?name=" .. name .. "&time=" .. tick()) --Check to see if the user is banned (This will be moved to server side)
		--sending the server tick in a useless request helps prevent roblox from caching it and therefor returning not banned even when banned.
		--httpget can also be used for this, but i prefer using dofile and having the php file return "return true" or "return false"
		--Some newer clients don't like dofile or httpget so they may need to be patched as well
     	if g == true then
     		game:SetMessage("You have been banned from [Revival name here]")
			client:remove()
     	end
     	wait(30)
     end
   end)




local player = game:GetService("Players"):CreateLocalPlayer(pid) --Create the player
player.Name = name .. ";" .. hash --Connect the user hash and the name to be seperated by server
if name ~= "" then
client:Connect(ip,port,0,10)
else
game:SetMessage("You did not login")
end
client.ConnectionFailed:connect(function(ip,code,reason)
    game:SetMessage("Failed to connect to the Game. (ID="..code.." ["..reason.."])")
end)
client.ConnectionRejected:connect(function()
    game:SetMessage("Failed to connect to the Game. (ID=22 [ID_CONNECTION_REJECT])")
end)
client.ConnectionAccepted:connect(function(ip,replicator)
    game:SetMessageBrickCount()
    replicator:SendMarker().Received:connect(function()
    player.Idled:connect(idlekick)
    game:SetMessage("Requesting character")
    player.CharacterAppearance = appearance --Sets the character appearance
    replicator:RequestCharacter()
    game:SetMessage("Waiting for character")
    
		co = coroutine.create(
		   function ()
		     while player.Character == nil do
		     	wait(1)
		     end
		game:ClearMessage()
		coroutine.resume(co2)
		   end)
		coroutine.resume(co)
        replicator.Disconnection:connect(function(a,b)
    	game:SetMessage("Server has shut down")
    	end)	
        while game:service("RunService").Stepped:wait() do
            replicator:SendMarker()
        end
    end)
end)
function idlekick(time)
	if time > 900 then
	game:SetMessage("You were disconnected for idling 15 minutes")
	client:remove()
	end
end