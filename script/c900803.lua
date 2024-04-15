--Poltiquette Telephantom
--Scripted by Beanbag
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
    Fusion.AddProcMix(c,true,true,s.ffilter,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SPELL),2,2)
end

function s.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x3D4,fc,sumtype,tp) and c:IsType(TYPE_SPELL+TRAP,fc,sumtype,tp)
end