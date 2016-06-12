#NoEnv
#Warn
#NoTrayIcon
SendMode Input
SetWorkingDir %A_ScriptDir%
#Singleinstance, Force

Gosub, SetParamaters
Gosub, ShowSplashscreen
Gosub, CreateMenu
Return

SetParamaters:
QuoteList = %A_ScriptDir%\Resources\Quotes.txt
Button1 = %A_ScriptDir%\Resources\Button.tiff
Decal = %A_ScriptDir%\Resources\Decal.tiff
Pointer = %A_ScriptDir%\Resources\Arrows.tiff
Block = %A_ScriptDir%\Resources\Block.tiff
Schemafil = %A_ScriptDir%\Resources\Schema.png
Tick = *16
Blocknumber = 5
Preferences = %A_ScriptDir%\Resources\Preferences.txt
Return

ShowSplashscreen:
Gui, Splashscreen:New
Gui, Splashscreen:Color, EEAA99
Gui, Splashscreen:+LastFound +ToolWindow
WinSet, TransColor, EEAA99
Gui, Splashscreen:Add, Picture, x0 y0 +BackgroundTrans, %Button1%
Gui, Splashscreen:Add, Picture, x0 y450 +BackgroundTrans, %Decal%
Gui, Splashscreen:Add, Progress, x128 Y455 w223 h10 cGreen BackgroundE8E8E8 Range0-221 vProgress
Prog := 0
Gui, Splashscreen:Font, s11,, Verdana
Gui, Splashscreen:Add, Text, x0 y542 w475 Center cBlack BackgroundTrans vQuoteText, PlaceHolderText
Gosub, NewQuote
Gui Splashscreen:-Caption
Gui, Splashscreen:Show,,Splashscreen
SetTimer, NewQuote,300
SetTimer, Update, 10
Return

CreateMenu:
line := GetRandomLine(QuoteList)
FileReadLine, Quote, %QuoteList%, %line%
Gui, Menu1:New,+HwndMenuguiisbest
Gui, Menu1:Color, EEAA99
Gui Menu1:+LastFound
WinSet, TransColor, EEAA99
Gui, Menu1:Add, Picture, x0 y0 +BackgroundTrans gGuiMove HwndtopMenu1, %Decal%
Gui, Menu1:Font, s11,, Verdana
textposy := 92
Gui, Menu1:Add, Text, x0 y%textposy% w475 Center cBlack +BackgroundTrans HwndtopMenu2 vQuotetext, %Quote%
isquote := 0
Gui, Menu1:Font, s20,, Verdana
Gosub, AddBlock
Gui Menu1:-Caption
Gui, Arrowg:New
Gui, Arrowg:Color, EEAA99
Gui, Arrowg:+LastFound +ToolWindow
WinSet, TransColor, EEAA99
Gui, Arrowg:Add, Picture, x0 y0 HwndOnlyArrow +BackgroundTrans, %Pointer%
Gui Arrowg:-Caption
Gui, Arrowg:+OwnerMenu1
SysGet, Mon1 , MonitorWorkArea, 1
TranslationY := ((Mon1Bottom/2) - ((162 + ((Blocknumber-1) * 55))/2))
If (TranslationY < 0)
TranslationY := 0
TranslationX := ((Mon1Right/2) - (475/2))
GuiControl, Menu1:, Option1, Schema
GuiControl, Menu1:, Option2, Auto Shutdown
StringRight, Week, A_YWeek, 2
Return

Menu1GuiClose:
SetTimer, UpdateMouse, OFF
Gui, Menu1:Hide
Gui, Arrowg:Hide
Return

continuetogui:
Gui, Splashscreen:Destroy
Return

^+q::
IfWinActive, RosenKnapp
{
SetTimer, UpdateMouse, OFF
Gui, Menu1:Hide
Gui, Arrowg:Hide
}
Else
{
SetTimer, UpdateMouse, 10
Gui, Arrowg:Show,,RosenPil
Gui, Menu1:Show,,RosenKnapp
}
Return

GuiMove:
PostMessage, 0xA1, 2,,, A
Return

Option1:
Gosub, VisaSchema
Return
Option2:
Gosub, AutoShutdown
Return
Option3:
Return
Option4:
Return
Option5:
Return
Option6:
Return
Option7:
Return
Option8:
Return
Option9:
Return
Option10:
Return
Option11:
Return
Option12:
Return
Option13:
Return
Option14:
Return
Option15:
Return
Option16:
Return
Option17:
Return
Option18:
Return
Option19:
Return
Option20:
Return

CloseSchema:
Gui, Schema1:Destroy
Gui, Schema2:Destroy
Return

NewQuote:
line := GetRandomLine(QuoteList)
FileReadLine, Quote, %QuoteList%, %line%
GuiControl,Splashscreen:, QuoteText, %Quote%
Return

Update:
If (Prog < 221)
{
GuiControl,Splashscreen:, Progress, +5
Prog += 5
}
Else
{
SetTimer, NewQuote,OFF
SetTimer, Update, OFF
Goto, continuetogui
}
Return

AddBlock:
iteration := 0
Loop, %Blocknumber%
{
iteration += 1
posyblock := (90+55*iteration)
posytext := (100+55*iteration)
Gui, Menu1:Add, Picture, x0 y%posyblock%  HwndZorro1%iteration% vBlock%iteration% gOption%iteration%, %Block%
Gui, Menu1:Add, Text, x0 y%posytext% w475 Center cBlack +BackgroundTrans HwndZorro2%iteration% vOption%iteration% gOption%iteration%
}
Return

UpdateMouse:
IfWinExist, RosenKnapp
{
WinGetPos, MainX, MainY,,, RosenKnapp
TranslationY := MainY
TranslationX := MainX
}
CoordMode, Mouse
MouseGetPos, Mosx, Mosy,,id, 2
Mosy += (-TranslationY)
Windy :=Mosy-27
If (Windy < 129)
Windy := 129
Bottom := (162 + ((Blocknumber-1) * 55))
If (Windy > Bottom)
Windy := Bottom
Windy += TranslationY
Cursorx := ((Mon1Right/2)-Mosx)
If (Cursorx > 0)
{
If (Cursorx > 150)
Cursorx := 150
}
Else
{
If (Cursorx < (-150))
Cursorx := (-150)
}
Windx := (Translationx - (Cursorx/15))
Gui, Arrowg:Show, NoActivate x%Windx% y%Windy%,RosenPil

If (id = OnlyArrow)
Return
If (((id = topMenu1) or (id = topMenu2)) and (isquote = 1))
{
	GuiControl, Menu1:, QuoteText, CTRL + SHIFT Q to close
	isquote := 0
}
If (id <> topMenu1) and (id <> topMenu2) and (isquote <> 1)
{
	GuiControl, Menu1:, QuoteText, % Quote
	isquote := 1
}
Return

GetRandomLine(List)
{
Rowcount := 0
Loop, read, %List%
{
Rowcount += 1
}
Random, randline, 1, %Rowcount%
Return randline
}

Destroy:
SetTimer, UpdateMouse, OFF
Gui, Menu1:Hide
Gui, Arrowg:Hide
Return

Right::
IfWinActive, Schema
{
Week += 1
If (Aktivschema := 1)
{
CreateSchema("Schema2", "9907169255", Week, Schemafil, Mon1Bottom, 1)
Aktivschema := 2
}
Else
{
CreateSchema("Schema1", "9907169255", Week, Schemafil, Mon1Bottom, 1)
Aktivschema := 1
}
}
Else
Send, {Right}
Return

Left::
IfWinActive, Schema
{
Week += (-1)
If (Aktivschema := 1)
{
CreateSchema("Schema2", "9907169255", Week, Schemafil, Mon1Bottom, 1)
Aktivschema := 2
}
Else
{
CreateSchema("Schema1", "9907169255", Week, Schemafil, Mon1Bottom, 1)
Aktivschema := 1
}
}
Else
Send, {Left}
Return

^+s::
VisaSchema:
IfWinActive, Schema
Gosub, CloseSchema
Else
{
CreateSchema("Schema1", "9907169255", Week, Schemafil, Mon1Bottom, 1)
Aktivschema := 1
}
Return


CreateSchema(Windowname, personID, Week, Schemafil, Screenheight, visa)
{
Margin := 100
SchemaX := ((Screenheight*1.4) - Margin)
SchemaY := ((Screenheight) - Margin)
RequestX := (Round(SchemaX/0.999))
RequestY := (Round(SchemaY/0.67))
CutTop := (Round(RequestY*0.13))
CutBottom := (Round((RequestY)-(RequestY*0.8)))
CutLeft := 0
CutRight := (Round((RequestX)-(RequestX * 0.999)))
LaddaDetta = http://www.novasoftware.se/ImgGen/schedulegenerator.aspx?format=png&schoolid=81320/sv-se&type=-1&id=%personID%&period=&week=%Week%&mode=0&printer=1&colors=0&head=1&clock=1&foot=1&day=0&width=%RequestX%&height=%RequestY%&count=1&decrypt=0
UrlDownloadToFile, %LaddaDetta%, %Schemafil%
crop(Schemafil, CutLeft, CutTop, CutRight, CutBottom)
Gui, %Windowname%:New
Gui, %Windowname%:Color, EEAA99
Gui, %Windowname%:+LastFound +ToolWindow
WinSet, TransColor, EEAA99
Gui, %Windowname%:Add, Picture, x0 y0 +BackgroundTrans gCloseSchema, %Schemafil%
Gui, %Windowname%:-Caption
If (visa := 1)
Sleep, 50
Gui, %Windowname%:Show,,%Windowname%
Return
}

crop(Schemafil, x, y, r, b)
{
	img := ComObjCreate("WIA.ImageFile")
	img.LoadFile(Schemafil)
	IP:=ComObjCreate("WIA.ImageProcess")
	ip.Filters.Add(IP.FilterInfos("Crop").FilterID)
	ip.filters[1].properties("Left") := x
	ip.filters[1].properties("Top") := y
	ip.filters[1].properties("Right") := r
	ip.filters[1].properties("Bottom") := b
	img := IP.Apply(img)
	FileDelete, %Schemafil%
	while FileExist(Schemafil)
	Sleep, 10
	img.SaveFile(Schemafil)
	return
}

AutoShutdown:
Gui, Shut:new
Gui, Shut:Font, s11,, Verdana
Gui, Shut:Add, Text, w70 Right x5 y14, Action:
Gui, Shut:Add, DropDownList, Choose5 y10 x80 vAction, Shutdown|Hibernate|Sleep|Restart|Do nothing
Iteration32 := 5
Loopiteration := -1
Loop, 4
{
Iteration32 += -1
Loopiteration += 1
Position := Loopiteration * 40 + 50
Textpos := Position + 4
If (Iteration32 = 1)
{
TimeUnit = Seconds
RangeInterval := 59
}

Else If (Iteration32 = 2)
{
TimeUnit = Minutes
RangeInterval := 59
}

Else If (Iteration32 = 3)
{
TimeUnit = Hours
RangeInterval := 23
}

Else If (Iteration32 = 4)
{
TimeUnit = Days
RangeInterval := 42
}
Gui, Shut:Font, s11,, Verdana
Gui, Shut:Add, Text, w70 Right x5 y%Textpos%, %TimeUnit%:
Gui, Shut:Add, Edit, x50 limit2 Number vVisualValue%TimeUnit% gCheckvalue%TimeUnit% x80 y%Position%
Gui, Shut:Add, UpDown, vUpDownArrows%TimeUnit% gUpdateSlider%TimeUnit% Range0-%RangeInterval%, 0
Gui, Shut:Font, s20,, Verdana
Gui, Shut:Add, Slider, AltSubmit Center -TabStop NoTicks gUpdateText%TimeUnit% x250 y%Position% vSlider%TimeUnit% Range0-%RangeInterval%, 0
}
Gui, Shut:Font, s11,, Verdana
Gui, Shut:Add, Button, -TabStop Default gSavethevaluesAndsettimer x410 y205, Set Timer
Gui, Shut:Add, Button, gGuiClose -TabStop x490 y205, Cancel
Gui, Shut:Show,, AutoShutdown
Return

GuiClose:
Gui, Shut:Destroy
Return

SavethevaluesAndsettimer:
Gui, Shut:Submit
Seconds := VisualValueSeconds
Minutes := VisualValueMinutes
Hours := VisualValueHours
Days := VisualValueDays
Milliseconds := (((((((Days * 24) + Hours) * 60) + Minutes) * 60) + Seconds) * 1000)
SetTimer, PerformAction, %Milliseconds%
Return

PerformAction:
SetTimer, PerformAction, OFF
If (Action = "Shutdown")
{
Shutdown, 1
Exitapp
}
Else If (Action = "Hibernate")
{
DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
Exitapp
}
Else If (Action = "Sleep")
{
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
Exitapp
}
Else If (Action = "Restart")
{
Shutdown, 2
Exitapp
}
Else If (Action = "Do nothing")
{
MsgBox, 0, Nothing, No action has been taken
}
Return

UpdateSliderSeconds:
Guicontrol,Shut:, SliderSeconds , %UpDownArrowsSeconds%
Return

UpdateTextSeconds:
Guicontrol,Shut:, VisualValueSeconds , %SliderSeconds%
Return

CheckvalueSeconds:
GuiControlGet, TextValueSeconds ,Shut:, VisualValueSeconds
If (TextValueSeconds > 59)
{
Guicontrol,Shut:, VisualValueSeconds , 59
Guicontrol,Shut:, SliderSeconds , 59
}
Else
Guicontrol,Shut:, SliderSeconds , %TextValueSeconds%
Return


UpdateSliderMinutes:
Guicontrol,Shut:, SliderMinutes , %UpDownArrowsMinutes%
Return

UpdateTextMinutes:
Guicontrol,Shut:, VisualValueMinutes , %SliderMinutes%
Return

CheckvalueMinutes:
GuiControlGet, TextValueMinutes ,Shut:, VisualValueMinutes
If (TextValueMinutes > 59)
{
Guicontrol,Shut:, VisualValueMinutes , 59
Guicontrol,Shut:, SliderMinutes , 59
}
Else
Guicontrol,Shut:, SliderMinutes , %TextValueMinutes%
Return

UpdateSliderHours:
Guicontrol,Shut:, SliderHours , %UpDownArrowsHours%
Return

UpdateTextHours:
Guicontrol,Shut:, VisualValueHours , %SliderHours%
Return

CheckvalueHours:
GuiControlGet, TextValueHours ,Shut:, VisualValueHours
If (TextValueHours > 23)
{
Guicontrol,Shut:, VisualValueHours , 23
Guicontrol,Shut:, SliderHours , 23
}
Else
Guicontrol,Shut:, SliderHours , %TextValueHours%
Return

UpdateSliderDays:
Guicontrol,Shut:, SliderDays , %UpDownArrowsDays%
Return

UpdateTextDays:
Guicontrol,Shut:, VisualValueDays , %SliderDays%
Return

CheckvalueDays:
GuiControlGet, TextValueDays ,Shut:, VisualValueDays
If (TextValueDays > 42)
{
Guicontrol,Shut:, VisualValueDays , 42
Guicontrol,Shut:, SliderDays , 42
}
Else
Guicontrol,Shut:, SliderDays , %TextValueDays%
Return