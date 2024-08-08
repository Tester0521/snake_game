function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

local func = function () 
	print("lol")
	sleep(2)
	print("lol2")
end

local func2 = function () 
	print("yep")
	sleep(2)
	print("yep2")
end

co = coroutine.create(func2)

while true do
	func()
	coroutine.resume(co)
	coroutine.resume(co)
	sleep(2)
end