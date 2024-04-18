--Poltiquette, Accursed Lord
--Scripted by Beanbag
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(s.matfilter),3,99)
end

function s.matfilter(c,fc,sumtype,tp)
	return c:IsSpellTrap(fc,sumtype,tp) and c:IsSetCard(0x3D4,fc,sumtype,tp)
end