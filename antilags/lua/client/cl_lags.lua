function sendmsg()
	local str = net.ReadString()
	chat.AddText( Color(255, 77, 77), "[Обнаружены лаги!] ", Color(178, 245, 179), str)
end

net.Receive("SendChatWarning", sendmsg)