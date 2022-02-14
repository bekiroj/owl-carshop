carshop = Service:new('vehicle-shop')
dxDrawText = dxDrawText
exports = exports
dxDrawRectangle = dxDrawRectangle
dxDrawImage = dxDrawImage
localPlayer = getLocalPlayer()
getTickCount = getTickCount

carshop.constructor = function()
    screen = Vector2(guiGetScreenSize())
    width, height = 300, 300
    sizeX, sizeY = (screen.x-width), (screen.y-height)
    robotoB = exports.slua_fonts:getFont('Roboto',27)
    robotoB2 = exports.slua_fonts:getFont('RobotoB',13)
    roboto = exports.slua_fonts:getFont('Roboto',14)
    roboto2 = exports.slua_fonts:getFont('Roboto',11)

    npc = createPed(2, 519.9501953125, -1293.3408203125, 17.2421875, 0.09063720703125)
    npc:setData('name', 'David Smith')
    npc.frozen = true

    addEvent('carshop.open', true)
    addEventHandler('carshop.open', root, carshop.open)
end

carshop.open = function()
    previewObject = createVehicle(540, 0, 0, 0)
    previewObject:setData('alpha', 255)
    previewObject:setDimension(999)
    previewObject:setColor(255,255,255)
    preview = exports['slua_object_preview']:createObjectPreview(previewObject, -5, 0, 150, 0.30, 0.15, 0.46, 0.40, true, true)
    click = 0
    maxScroll = 1
    buyButton = false
    scroll = 0
    showChat(false)
    showCursor(true)
    addEventHandler('onClientRender', root, carshop.render, true, 'low-10')
end

carshop.render = function()
	dxDrawImage(0, 0, screen.x, screen.y, 'components/images/background.png')
    dxDrawText('Arayüzü kapatmak için "BACKSPACE" tuşuna basın.', 15, 15, 35, 35, tocolor(225,225,225,235), 0.90, roboto2)

    if getKeyState('backspace') and click+800 <= getTickCount() then
        click = getTickCount()
        showChat(true)
        showCursor(false)
        previewObject:destroy() -- kapatma
        exports['slua_object_preview']:destroyObjectPreview(preview)
        removeEventHandler('onClientRender', getRootElement(), carshop.render)
    end

	if carshop.isInBox(sizeX/2-200, sizeY/2, 35, 35) then
		dxDrawText('<', sizeX/2-200, sizeY/2, 35, 35, tocolor(125,125,125,235), 1, robotoB)
        if getKeyState('mouse1') and click+800 <= getTickCount() then
            click = getTickCount()
            if scroll > 0 then
                scroll = scroll - 1
            end
        end
	else
		dxDrawText('<', sizeX/2-200, sizeY/2, 35, 35, tocolor(155,155,155,235), 1, robotoB)
	end

	if carshop.isInBox(sizeX/2+500, sizeY/2, 35, 35) then
		dxDrawText('>', sizeX/2+500, sizeY/2, 35, 35, tocolor(125,125,125,235), 1, robotoB)
        if getKeyState('mouse1') and click+800 <= getTickCount() then
            click = getTickCount()
            if scroll < #carshopCars - maxScroll then
                scroll = scroll + 1
            end
        end
	else
		dxDrawText('>', sizeX/2+500, sizeY/2, 35, 35, tocolor(155,155,155,235), 1, robotoB)
	end

	carshop.roundedRectangle(sizeX/2, sizeY/2+355, 300, 150, tocolor(15,15,15,235))
	dxDrawImage(sizeX/2+35, sizeY/2+380, 60, 50, 'components/images/icon.png')
    dxDrawText('Yukarıda araç bilgileri yer alıyor.', sizeX/2+15, sizeY/2+453, 35, 35, tocolor(225,225,225,235), 0.80, roboto2)
    dxDrawText('Satın almak için "ENTER" tuşuna basın.', sizeX/2+15, sizeY/2+468, 35, 35, tocolor(225,225,225,235), 0.80, roboto2)

    count = 0
    
    for index, value in ipairs(carshopCars) do
        if index > scroll and count < maxScroll then
            count = count + 1
            setElementModel(previewObject, value[3])
            dxDrawText(value[1], sizeX/2+135, sizeY/2+370, 35, 35, tocolor(225,225,225,235), 1, roboto)
            dxDrawText(value[2], sizeX/2+135, sizeY/2+390, 35, 35, tocolor(175,175,175,235), 0.75, roboto)
            dxDrawText('Araç fiyatı: '..exports.slua_global:formatMoney(value[5])..''..exports.config:getServerMoneyType(), sizeX/2+135, sizeY/2+405, 35, 35, tocolor(175,175,175,235), 0.70, roboto)
            dxDrawText('Araç vergisi: '..exports.slua_global:formatMoney(value[6])..''..exports.config:getServerMoneyType(), sizeX/2+135, sizeY/2+417, 35, 35, tocolor(175,175,175,235), 0.70, roboto)
            if getKeyState('enter') and click+800 <= getTickCount() then
                click = getTickCount()
                buyButton = true
            end
            if buyButton then
                carshop.roundedRectangle(sizeX/2, sizeY/2+265, 300, 75, tocolor(15,15,15,235))
                dxDrawText('Satın almak istediğine emin misin?', sizeX/2+38, sizeY/2+273, 35, 35, tocolor(225,225,225,235), 0.80, robotoB2)
                if carshop.isInBox(sizeX/2+40, sizeY/2+305, 100, 25) then
                    carshop.roundedRectangle(sizeX/2+40, sizeY/2+305, 100, 25, tocolor(25,25,25,235))
                    dxDrawText('EVET', sizeX/2+72, sizeY/2+309, 35, 35, tocolor(225,225,225,235), 0.80, robotoB2)
                    if getKeyState('mouse1') and click+800 <= getTickCount() then
                        click = getTickCount()
                        buyButton = false
                        showChat(true)
                        showCursor(false)
                        previewObject:destroy()
                        exports['slua_object_preview']:destroyObjectPreview(preview)
                        removeEventHandler('onClientRender', getRootElement(), carshop.render)
						triggerServerEvent("carshop.buy",localPlayer, value[4], value[3], value[1], value[5])
                    end
                else
                    carshop.roundedRectangle(sizeX/2+40, sizeY/2+305, 100, 25, tocolor(35,35,35,235))
                    dxDrawText('EVET', sizeX/2+72, sizeY/2+309, 35, 35, tocolor(225,225,225,235), 0.80, robotoB2)
                end

                if carshop.isInBox(sizeX/2+160, sizeY/2+305, 100, 25) then
                    carshop.roundedRectangle(sizeX/2+160, sizeY/2+305, 100, 25, tocolor(25,25,25,235))
                    dxDrawText('HAYIR', sizeX/2+188, sizeY/2+309, 35, 35, tocolor(225,225,225,235), 0.80, robotoB2)
                    if getKeyState('mouse1') and click+800 <= getTickCount() then
                        click = getTickCount()
                        buyButton = false
                    end
                else
                    carshop.roundedRectangle(sizeX/2+160, sizeY/2+305, 100, 25, tocolor(35,35,35,235))
                    dxDrawText('HAYIR', sizeX/2+188, sizeY/2+309, 35, 35, tocolor(225,225,225,235), 0.80, robotoB2)
                end
            end
        end
    end
end

carshop.isInBox = function(xS,yS,wS,hS)
    if(isCursorShowing()) then
        local cursorX, cursorY = getCursorPosition()
        sX,sY = guiGetScreenSize()
        cursorX, cursorY = cursorX*sX, cursorY*sY
        if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
            return true
        else
            return false
        end
    end
end

carshop.roundedRectangle = function(x, y, w, h, borderColor, bgColor, postGUI)
    if (x and y and w and h) then
        if (not borderColor) then
            borderColor = tocolor(0, 0, 0, 200);
        end
        if (not bgColor) then
            bgColor = borderColor;
        end
        dxDrawRectangle(x, y, w, h, bgColor, postGUI);
        dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
        dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
        dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
        dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
    end
end

carshop.constructor()