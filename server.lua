ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Registriere das Fernglas als benutzbaren Gegenstand
ESX.RegisterUsableItem('fernglas', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('binoculars:Activate', source)
end)
