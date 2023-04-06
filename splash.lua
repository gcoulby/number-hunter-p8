splashShown = false
splashStartTime = 0
splashPosition = -10


function updateSplash()
    cls()
    if splashPosition < 50 then
        splashPosition = splashPosition + 0.8
    end

    print("copyright", 46, splashPosition, 12)
    print("graham coulby 2023", 28, splashPosition + 10, 12)
    yield()
end 

function startSplash()
    splashStartTIme = t()
    sfx(63)
    
    repeat
        updateSplash()
    until t() - splashStartTime > 3.5
    splashShown = true
end
splashScreen = cocreate(startSplash)
