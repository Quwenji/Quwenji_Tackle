-- Standardtaste ist E. Wenn du die Taste ändern möchtest, gehe hierhin: https://docs.fivem.net/game-references/controls/
-- Dieses Script enthält keinerlei Berechtigungen. Du musst diese selbst hinzufügen.

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Prüfe, ob der Spieler sprintet und die Tackletaste (Standard E, Kontrolle 38) losgelassen wurde
        if IsPedSprinting(PlayerPedId()) and IsControlJustReleased(0, 38) then -- Ändere hier die Taste zum Tackeln.
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                -- Nichts tun, wenn der Spieler in einem Fahrzeug ist
            else
                local playerPed = PlayerPedId()
                local ForwardVector = GetEntityForwardVector(playerPed)
                local Tackled = {}
                
                -- Setze den Ped in den Ragdoll-Modus mit Fall
                SetPedToRagdollWithFall(playerPed, 1000, 1500, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) -- Wie lange der Tackler liegen bleibt.

                -- Während der Ped im Ragdoll-Modus ist
                while IsPedRagdoll(playerPed) do
                    Citizen.Wait(0)
                    for _, player in ipairs(getTouchedPlayers()) do
                        if not Tackled[player] then
                            Tackled[player] = true
                            TriggerServerEvent('Quwenji_Tackle:Server:TacklePlayer', GetPlayerServerId(player), ForwardVector, GetPlayerName(PlayerId()))
                        end
                    end
                end

                -- Optional: Kann hinzugefügt werden, um nach dem Ragdoll-Modus etwas zu tun
                -- z.B. ClearPedTasks(playerPed)
            end
        end
    end
end)

-- Event-Handler für das Tackeln eines anderen Spielers
RegisterNetEvent('Quwenji_Tackle:Client:TacklePlayer')
AddEventHandler('Quwenji_Tackle:Client:TacklePlayer', function(ForwardVector, Tackler)
    local playerPed = PlayerPedId()
    
    -- Setze den getackelten Ped in den Ragdoll-Modus mit Fall
    SetPedToRagdollWithFall(playerPed, 4000, 4000, 0, ForwardVector, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) -- Wie lange die getackelte Person liegen bleibt.
end)

-- Funktion zum Abrufen aller aktiven Spieler
function getPlayers()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

-- Funktion zum Abrufen der Spieler, die den aktuellen Spieler berühren
function getTouchedPlayers()
    local touchedPlayers = {}
    local playerPed = PlayerPedId()
    for _, player in ipairs(getPlayers()) do
        if player ~= PlayerId() and IsEntityTouchingEntity(playerPed, GetPlayerPed(player)) then
            table.insert(touchedPlayers, player)
        end
    end
    return touchedPlayers
end
