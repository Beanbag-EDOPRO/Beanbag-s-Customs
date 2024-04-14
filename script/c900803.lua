--Poltiquette Telephantom
--Scripted by Beanbag
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcMixRep(c,false,false,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3D4),2)
end