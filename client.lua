local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local coords = GetEntityCoords(veh ~= 0 and veh or ped)
        local _, z = GetGroundZCoordWithOffsets(coords.x, coords.y, 150.0, 0)
        local ground, groundz = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 1)

        local minHeight = 3.0
        local controlKey = 38
        local shouldFreeze = false

        if coords.z < groundz and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped) and (IsPedFalling(ped) or (veh ~= 0 and IsEntityInAir(veh))) then
            DrawText2D("~r~⚠️ Vous tombez sous le sol, appuyez sur E", 0.5, 0.8, 0.7)

            if IsControlJustPressed(0, 38) then
                ClearPedTasksImmediately(ped)

                local targetCoords = { x = coords.x, y = coords.y, z = z}

                if veh ~= 0 then
                    SetEntityCoordsNoOffset(veh, targetCoords.x, targetCoords.y, targetCoords.z, true, false, false)
                    SetPedIntoVehicle(ped, veh, -1)
                else
                    SetEntityCoordsNoOffset(ped, targetCoords.x, targetCoords.y, targetCoords.z, true, false, false)
                end

                ESX.ShowNotification("~c Vous êtes de nouveau sur le sol")

                if shouldFreeze then
                    CreateThread(function()
                        FreezeEntityPosition(ped, true)
                        Wait(5000)
                        FreezeEntityPosition(ped, false)
                    end)
                end
            end
        else
            Wait(1000)
        end
        Wait(0)
