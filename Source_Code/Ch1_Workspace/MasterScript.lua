Code = "5831" --change To any numbers You like
Input = ""


--This Is for my buddy siros

--created by
------------------------------------------
--Clear And Enter

function Clear()
print("Cleared")
Input = ""
end

script.Parent.Clear.ClickDetector.MouseClick:connect(Clear)




function Enter()
if Input == Code then
print("Entered")
Input = ""

local door = script.Parent.Parent.Door

door.CanCollide = false
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = door.Transparency + 0.1
wait(0.1)
door.Transparency = 0.8
wait(3)--
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = door.Transparency - 0.1
wait(0.1)
door.Transparency = 0
door.CanCollide = true



return end
Input = ""
print("Wrong Code")
end




script.Parent.Enter.ClickDetector.MouseClick:connect(Enter)

------------------------------------------
--Digets


function Click0()
Input = Input..0
print("0") 
script.Parent.B0.Decal.Texture = "http://www.roblox.com/asset/?id=2767674"
wait(0.1)
script.Parent.B0.Decal.Texture = "http://www.roblox.com/asset/?id=2761903"
end

script.Parent.B0.ClickDetector.MouseClick:connect(Click0)

function Click1()
Input = Input..1
print("1")
script.Parent.B1.Decal.Texture = "http://www.roblox.com/asset/?id=2767677"
wait(0.1)
script.Parent.B1.Decal.Texture = "http://www.roblox.com/asset/?id=2761913"
end

script.Parent.B1.ClickDetector.MouseClick:connect(Click1)

function Click2()
Input = Input..2
print("2")
script.Parent.B2.Decal.Texture = "http://www.roblox.com/asset/?id=2767680"
wait(0.1)
script.Parent.B2.Decal.Texture = "http://www.roblox.com/asset/?id=2761922"
end

script.Parent.B2.ClickDetector.MouseClick:connect(Click2)

function Click3()
Input = Input..3
print("3")
script.Parent.B3.Decal.Texture = "http://www.roblox.com/asset/?id=2767686"
wait(0.1)
script.Parent.B3.Decal.Texture = "http://www.roblox.com/asset/?id=2761927"
end

script.Parent.B3.ClickDetector.MouseClick:connect(Click3)

function Click4()
Input = Input..4
print("4")
script.Parent.B4.Decal.Texture = "http://www.roblox.com/asset/?id=2767693"
wait(0.1)
script.Parent.B4.Decal.Texture = "http://www.roblox.com/asset/?id=2761938"
end

script.Parent.B4.ClickDetector.MouseClick:connect(Click4)

function Click5()
Input = Input..5
print("5")
script.Parent.B5.Decal.Texture = "http://www.roblox.com/asset/?id=2767695"
wait(0.1)
script.Parent.B5.Decal.Texture = "http://www.roblox.com/asset/?id=2761943"
end

script.Parent.B5.ClickDetector.MouseClick:connect(Click5)

function Click6()
Input = Input..6
print("6")
script.Parent.B6.Decal.Texture = "http://www.roblox.com/asset/?id=2767699"
wait(0.1)
script.Parent.B6.Decal.Texture = "http://www.roblox.com/asset/?id=2761948"
end

script.Parent.B6.ClickDetector.MouseClick:connect(Click6)

function Click7()
Input = Input..7
print("7")
script.Parent.B7.Decal.Texture = "http://www.roblox.com/asset/?id=2767701"
wait(0.1)
script.Parent.B7.Decal.Texture = "http://www.roblox.com/asset/?id=2761956"
end

script.Parent.B7.ClickDetector.MouseClick:connect(Click7)

function Click8()
Input = Input..8
print("8")
script.Parent.B8.Decal.Texture = "http://www.roblox.com/asset/?id=2767707"
wait(0.1)
script.Parent.B8.Decal.Texture = "http://www.roblox.com/asset/?id=2761961"
end

script.Parent.B8.ClickDetector.MouseClick:connect(Click8)

function Click9()
Input = Input..9
print("9")
script.Parent.B9.Decal.Texture = "http://www.roblox.com/asset/?id=2767714"
wait(0.1)
script.Parent.B9.Decal.Texture = "http://www.roblox.com/asset/?id=2761971"
end

script.Parent.B9.ClickDetector.MouseClick:connect(Click9)















