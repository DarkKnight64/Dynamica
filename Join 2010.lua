game.Players:SetAbuseReportUrl("http://abuse/report/url/handler/here") --Where report abuse is sent (XML Chat log on submit)
game:GetService("Players"):SetChatStyle(Enum.ChatStyle.ClassicAndBubble)
local name = ""--Username here
local ip = "" --IP here
local port = 0 --Port here
local pid = 0 --Player ID here
local hash = 0 --Player hash here used for verification
local appearance = "" --Player appearance URL
game:GetService("Visit")
game:SetMessage("Connecting to server...")
local client = game:GetService("NetworkClient")
client.Name = "connection"
local co2 = coroutine.create(
   function ()
     while true do
     	g = dofile("http://check/ban/url/here?name=" .. name .. "&time=" .. tick()) --This will move to server side
     	if g == true then
     		game:SetMessage("You have been banned from [ Insert revival name here ]")
			client:remove()
     	end
     	wait(30)
     end
   end)




local player = game:GetService("Players"):CreateLocalPlayer(pid)
player:SetSuperSafeChat(false)
player.CharacterAppearance = appearance
player:SetUnder13(false)
player.Name = name .. ";" .. hash --Append hash to username to be split and verified server side
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
    replicator:RequestCharacter()
    game:SetMessage("Waiting for character")
    
		co = coroutine.create(
		   function ()
		     while player.Character == nil do
		     	wait(1) --Wait for character to actually exist in the world
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
