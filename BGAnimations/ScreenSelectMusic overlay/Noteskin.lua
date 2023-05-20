local GameDirections = { ["dance"] = "Down", ["pump"] = "UpLeft" }

return NOTESKIN:LoadActorForNoteSkin(GameDirections[GAMESTATE:GetCurrentGame():GetName()],"Tap Note",highlightedNoteSkin or "default")
